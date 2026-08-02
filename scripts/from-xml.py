#!/usr/bin/env python3
"""Convert MusicXML (exported from MuseScore) into LilyPond note/chord fragments.

Companion to from-muse.py, which parses .mscx directly. MusicXML is preferred
because MuseScore resolves things the raw .mscx leaves implicit:
  - chord symbols carry a named root and quality, not an opaque tpc integer
  - <divisions> gives exact integer tick timing
  - pitches are spelled (<step>/<alter>), so no pitch-class guessing
  - tempo/time/key are always present, even when inherited

Timing is done entirely in integer divisions to avoid the float drift that
made the .mscx parser trip its "negative beats" assertion.
"""
import argparse
import collections
import re
import sys
import xml.etree.ElementTree as ET
from fractions import Fraction

# LilyPond note names for a given step + alteration.
STEP_NAMES = ['c', 'd', 'e', 'f', 'g', 'a', 'b']
ALTER_SUFFIX = {-2: 'ff', -1: 'f', 0: '', 1: 's', 2: 'ss'}

# MusicXML <kind> -> LilyPond \chordmode quality suffix.
CHORD_KINDS = {
    'major': '',
    'minor': ':m',
    'augmented': ':aug',
    'diminished': ':dim',
    'dominant': ':7',
    'major-seventh': ':maj7',
    'minor-seventh': ':m7',
    'diminished-seventh': ':dim7',
    'augmented-seventh': ':aug7',
    'half-diminished': ':m7.5-',
    'major-sixth': ':6',
    'minor-sixth': ':m6',
    'dominant-ninth': ':9',
    'major-ninth': ':maj9',
    'minor-ninth': ':m9',
    'suspended-second': ':sus2',
    'suspended-fourth': ':sus4',
    'power': ':5',
}

# Key signature fifths -> LilyPond major key tonic.
KEY_SIG_MAP = {
    0: 'c', 1: 'g', 2: 'd', 3: 'a', 4: 'e', 5: 'b', 6: 'fs', 7: 'cs',
    -1: 'f', -2: 'bf', -3: 'ef', -4: 'af', -5: 'df', -6: 'gf', -7: 'cf',
}

PARTS = ['soprano', 'alto', 'tenor', 'bass']

# Placeholder titles left behind by the shared MuseScore template.
TEMPLATE_TITLE = re.compile(r'^\s*(hymn[_\s-]*template|untitled|score)\s*$', re.I)


class ConversionError(Exception):
    """Raised for input we cannot faithfully represent."""


_STEP_SEMITONE = {'c': 0, 'd': 2, 'e': 4, 'f': 5, 'g': 7, 'a': 9, 'b': 11}


def _pitch_rank(name):
    """Sort key for a LilyPond absolute pitch such as ``ees'`` or ``a,``."""
    match = re.match(r"^([a-g])(is|es|s|f)*('*|,*)$", name)
    if not match:
        return 0
    semitone = _STEP_SEMITONE.get(match.group(1), 0)
    for suffix in re.findall(r'is|es|s|f', name[1:]):
        semitone += 1 if suffix == 'is' else -1
    marks = match.group(3)
    octave = 3 + len(marks) if marks.startswith("'") else 3 - len(marks)
    return semitone + 12 * octave


def text_of(elem, path, default=None):
    found = elem.find(path) if elem is not None else None
    return found.text if found is not None and found.text is not None else default


def duration_to_lily(dur, divisions):
    """Turn a duration in divisions into LilyPond duration tokens.

    Returns a list of (duration_string, divisions) pieces. A duration that is
    not a single writable note value is split into tied components, so
    irregular values survive instead of raising a KeyError the way the
    .mscx path did.
    """
    if dur <= 0:
        return []
    # Whole note = 4 quarter notes = 4 * divisions.
    whole = Fraction(dur, divisions * 4)
    pieces = []
    remaining = whole
    guard = 0
    while remaining > 0 and guard < 16:
        guard += 1
        best = None
        # Try plain and dotted values from longest to shortest.
        for power in range(0, 7):          # 1, 2, 4, 8, 16, 32, 64
            base = Fraction(1, 2 ** power)
            for dots in (2, 1, 0):
                value = base * (Fraction(2) - Fraction(1, 2 ** dots))
                if value <= remaining and (best is None or value > best[0]):
                    best = (value, 2 ** power, dots)
        if best is None:
            break
        value, denom, dots = best
        pieces.append((f"{denom}{'.' * dots}", int(value * divisions * 4)))
        remaining -= value
    return pieces


class Score:
    def __init__(self):
        self.divisions = 1
        self.fifths = 0
        self.time_sig = None
        self.tempo = None
        self.title = None
        self.events = []          # note events, absolute tick
        self.chords = []          # harmony events, absolute tick
        self.measures = []        # (start_tick, length_ticks, implicit)
        self.voice_map = {}
        self.warnings = []

    # ---- parsing -------------------------------------------------------

    def parse(self, path):
        root = ET.parse(path).getroot()
        self._read_header(root)
        self._discover_voices(root)
        self._read_notes(root)
        self._fill_implied_parts()
        self._spread_chord_slurs()
        self._detect_pickup()
        if self.time_sig is None:
            self.time_sig = (4, 4)
            self.warnings.append('no time signature found; assumed 4/4')
        # After the 4/4 fallback: the check needs a time_sig to compare against.
        self._warn_irregular_measures()
        if self.tempo is None:
            self.tempo = 90
            self.warnings.append('no tempo found; assumed 90')
        if not self.title:
            self.title = 'MUSE_TITLE_TODO_REPLACEME'
            self.warnings.append('no title found')
        return self

    def _read_header(self, root):
        # Prefer the engraved title credit: many of these scores were started
        # from a shared MuseScore template and still carry its work-title.
        title = None
        for credit in root.findall('credit'):
            words = credit.find('credit-words')
            ctype = text_of(credit, 'credit-type')
            if words is not None and words.text and (ctype in (None, 'title')):
                title = words.text.strip()
                break
        work_title = text_of(root, 'work/work-title')
        if not title and work_title and not TEMPLATE_TITLE.match(work_title):
            title = work_title
        if title:
            title = ' '.join(title.split())
            # Drop a leading hymnal number ("123 Come and see").
            first = title.split(' ', 1)
            if len(first) == 2 and re.fullmatch(r'[A-Za-z]?\d+\.?', first[0]):
                title = first[1]
        self.title = title

        first_attrs = root.find('.//measure/attributes')
        if first_attrs is not None:
            self.divisions = int(text_of(first_attrs, 'divisions', '1') or 1)
            fifths = text_of(first_attrs, 'key/fifths')
            if fifths is not None:
                self.fifths = int(fifths)
            beats = text_of(first_attrs, 'time/beats')
            beat_type = text_of(first_attrs, 'time/beat-type')
            if beats and beat_type:
                self.time_sig = (int(beats), int(beat_type))

        per_minute = root.find('.//sound[@tempo]')
        if per_minute is not None:
            self.tempo = int(round(float(per_minute.get('tempo'))))
        else:
            bpm = text_of(root, './/metronome/per-minute')
            if bpm:
                try:
                    self.tempo = int(round(float(bpm)))
                except ValueError:
                    pass

    def _discover_voices(self, root):
        """Map each (staff, voice, stack) triple onto an SATB part.

        Layouts vary across the corpus: single staff, two voices, four
        voices, and -- most commonly -- two staves where each voice carries
        two-note chords, so soprano/alto share one voice and tenor/bass
        share another. `stack` is the index of a note within a <chord>
        stack, which is what distinguishes those pairs; ignoring it silently
        drops every upper harmony note.
        """
        seen = []
        for note in root.iter('note'):
            if note.find('rest') is not None:
                continue
            if note.find('chord') is not None:
                continue
            key = (note.findtext('staff'), note.findtext('voice'))
            if key not in seen:
                seen.append(key)
        seen.sort(key=lambda k: ((k[0] or ''), (k[1] or '')))

        # How deep do chord stacks usually go in each voice? Use the most
        # common depth, not the maximum: an occasional 3-note chord in an
        # otherwise 2-part voice must not add a phantom part for the whole
        # score. Extra notes in a deeper-than-usual stack fold into the
        # lowest slot of that voice.
        runs = {key: [] for key in seen}
        current = None
        run = 0
        for note in root.iter('note'):
            if note.find('rest') is not None:
                continue
            key = (note.findtext('staff'), note.findtext('voice'))
            if note.find('chord') is not None and key == current:
                run += 1
            else:
                if current in runs and run:
                    runs[current].append(run)
                current, run = key, 1
        if current in runs and run:
            runs[current].append(run)
        depth = {}
        for key in seen:
            counts = collections.Counter(runs[key])
            depth[key] = counts.most_common(1)[0][0] if counts else 1

        self._max_stack = {key: depth[key] - 1 for key in seen}

        # Group by staff: in this corpus staff 1 carries soprano/alto and
        # staff 2 tenor/bass. Within a staff the primary voice (most notes)
        # holds the real parts; secondary voices are sparse divisi and are
        # merged into the nearest part rather than promoted to their own.
        counts = collections.Counter()
        for note in root.iter('note'):
            if note.find('rest') is not None:
                continue
            counts[(note.findtext('staff'), note.findtext('voice'))] += 1

        # Which slot is the upper part is a question about pitch, not about
        # how many notes a voice happens to carry: a soprano line with long
        # held notes has fewer notes than the alto under it. Rank each slot
        # by its median pitch, high to low.
        pitches = collections.defaultdict(list)
        last_key = None
        stack = 0
        for note in root.iter('note'):
            if note.find('rest') is not None:
                continue
            key = (note.findtext('staff'), note.findtext('voice'))
            if note.find('chord') is not None and key == last_key:
                stack += 1
            else:
                stack = 0
            last_key = key
            pitch = note.find('pitch')
            if pitch is None:
                continue
            step = (pitch.findtext('step') or 'C').upper()
            octave = int(pitch.findtext('octave') or 4)
            alter = int(float(pitch.findtext('alter') or 0))
            semitone = {'C': 0, 'D': 2, 'E': 4, 'F': 5,
                        'G': 7, 'A': 9, 'B': 11}.get(step, 0)
            slot = (key[0], key[1], min(stack, depth.get(key, 1) - 1))
            pitches[slot].append(semitone + alter + 12 * (octave + 1))

        def median_pitch(slot):
            values = sorted(pitches.get(slot, []))
            if not values:
                return -1
            return values[len(values) // 2]

        # Some exports leave <staff> off single-staff passages, so a score
        # can mix None with numbered staves; sort them together as strings.
        staves = sorted({key[0] for key in seen}, key=lambda s: (s is not None, s or ''))
        slots = []
        for staff in staves:
            in_staff = []
            for key in [k for k in seen if k[0] == staff]:
                for stack_index in range(depth[key]):
                    in_staff.append((key[0], key[1], stack_index))
            in_staff.sort(key=lambda s: -median_pitch(s))
            slots.extend(in_staff)

        # Two staves is the common SATB shape: give each staff two parts.
        assigned = {}
        if len(staves) > 2:
            # More than two staves is usually a keyboard reduction or an
            # extra instrumental line stacked under the vocal parts. Spread
            # parts across staves in order rather than crushing every extra
            # staff into bass.
            self.warnings.append(
                f'{len(staves)} staves found; parts assigned by staff order '
                '- check this score by hand')
            for index, slot in enumerate(slots):
                assigned[slot] = PARTS[min(index, 3)]
        elif len(staves) == 2 and len(slots) >= 4:
            upper = [s for s in slots if s[0] == staves[0]]
            lower = [s for s in slots if s[0] != staves[0]]
            for index, slot in enumerate(upper):
                assigned[slot] = PARTS[min(index, 1)]
            for index, slot in enumerate(lower):
                assigned[slot] = PARTS[min(2 + index, 3)]
        elif len(slots) == 1:
            assigned[slots[0][:3]] = 'soprano'
        elif len(slots) == 2:
            assigned[slots[0][:3]] = 'soprano'
            assigned[slots[1][:3]] = 'bass'
        else:
            for index, slot in enumerate(slots):
                assigned[slot] = PARTS[min(index, 3)]
        self.voice_map = assigned

        # Which parts share a staff, upper first. _fill_implied_parts needs
        # this: when a part has nothing written, the part it doubles or
        # divides from is always its stafffellow.
        by_staff = collections.OrderedDict()
        for slot, part in assigned.items():
            by_staff.setdefault(slot[0], [])
            if part not in by_staff[slot[0]]:
                by_staff[slot[0]].append(part)
        self.staff_parts = [
            sorted(parts, key=PARTS.index) for parts in by_staff.values()
            if len(parts) > 1]

    def _read_notes(self, root):
        divisions = self.divisions
        measure_start = 0
        for measure in root.iter('measure'):
            implicit = measure.get('implicit') == 'yes'
            attrs = measure.find('attributes')
            if attrs is not None:
                new_div = text_of(attrs, 'divisions')
                if new_div:
                    divisions = int(new_div)
                    self.divisions = max(self.divisions, divisions)
                beats = text_of(attrs, 'time/beats')
                beat_type = text_of(attrs, 'time/beat-type')
                if beats and beat_type:
                    sig = (int(beats), int(beat_type))
                    if self.time_sig is None:
                        self.time_sig = sig
                    else:
                        self.events.append({
                            'tick': measure_start, 'kind': 'time', 'time_sig': sig})

            cursor = measure_start
            measure_end = measure_start
            for child in measure:
                if child.tag == 'note':
                    cursor, measure_end = self._read_note(
                        child, cursor, measure_end, divisions)
                elif child.tag == 'backup':
                    cursor -= int(text_of(child, 'duration', '0') or 0)
                    cursor = max(cursor, measure_start)
                elif child.tag == 'forward':
                    cursor += int(text_of(child, 'duration', '0') or 0)
                    measure_end = max(measure_end, cursor)
                elif child.tag == 'harmony':
                    chord = self._read_harmony(child)
                    if chord:
                        self.chords.append({'tick': cursor, 'chord': chord})
                elif child.tag == 'sound' and child.get('tempo'):
                    if self.tempo is None:
                        self.tempo = int(round(float(child.get('tempo'))))

            length = measure_end - measure_start
            self.measures.append((measure_start, length, implicit))
            measure_start = measure_end
        return self

    def _spread_chord_slurs(self):
        """Give every part on a staff the slurs written on its chord root.

        MusicXML writes a chord bottom-up and hangs the chord's notations on
        its root, which is therefore always the LOWEST note. Across this
        corpus that is absolute: 3621 chords are ordered low-to-high and
        none the other way, and all 1490 slurs sit on a root, none on a
        stacked note. So a slur that belongs to the upper voice arrives
        attached to the lower one, and the parts land in alto and bass while
        soprano and tenor never receive a slur at all.

        MuseScore does record how many voices were slurred, by stacking that
        many <slur> elements on the one root: 1209 roots carry a single slur,
        278 carry two, 3 carry three. But the count is not worth reading,
        because a melisma is sung by every voice on the staff - the held
        syllable is the same syllable for all of them - so the answer is the
        whole staff either way.

        Spreading to the whole staff is also the only option that preserves
        the engraving. \\partCombine merges the two parts of a staff into
        chords; a slur present in just one of them forces the pair to split
        into separate stems for that span, which is a visible and wrong
        change to the notation. With the slur in both, the merge is
        unaffected and the two identical curves render as one.
        """
        if not self.staff_parts:
            return

        # Work in terms of whole spans, not loose endpoints. Pair each part's
        # own starts with its own stops by walking that part in time order,
        # so a span is only ever (start tick, stop tick) for one real slur.
        #
        # Reconstructing spans by matching a start to "the next stop anywhere
        # on the staff" is not good enough. Sources carry slurs that never
        # reach a given part - one voice's phrase mark, a stop whose start
        # sits in a part the converter routed elsewhere - and pairing across
        # parts spread stops to voices that had received no start, leaving
        # slur depth negative and the file unparseable.
        def spans_of(part):
            """(start, stop) pairs for the slurs already written in a part."""
            ev = sorted((e for e in self.events
                         if e.get('kind') == 'note' and e.get('part') == part),
                        key=lambda e: e['tick'])
            spans, open_ticks = [], []
            for event in ev:
                if event.get('slur_start'):
                    open_ticks.append(event['tick'])
                if event.get('slur_stop') and open_ticks:
                    spans.append((open_ticks.pop(), event['tick']))
            return spans

        # A part may only receive a span it can actually carry: it needs a
        # note starting at the start tick that ENDS at the stop tick, so the
        # slur covers one real pair of its own notes. Testing onsets alone
        # was not enough - a part holding one long note through the span also
        # has an onset at the stop, from the overlapping clone
        # _fill_implied_parts leaves behind. The emitter drops that clone as
        # starting before the cursor, and the closing paren went with it.
        onsets = collections.defaultdict(dict)
        for event in self.events:
            if event.get('kind') == 'note':
                ends = onsets[event.get('part')].setdefault(event['tick'], set())
                ends.add(event['tick'] + event['duration'])

        spreadable = set()
        for parts in self.staff_parts:
            wanted = set()
            for part in parts:
                wanted.update(spans_of(part))
            for start, stop in wanted:
                for part in parts:
                    ends = onsets[part].get(start)
                    if ends and stop in ends:
                        spreadable.add((part, start, 'start'))
                        spreadable.add((part, stop, 'stop'))

        spread = 0
        for event in self.events:
            if event.get('kind') != 'note':
                continue
            part = event.get('part')
            if (part, event['tick'], 'start') in spreadable \
                    and not event.get('slur_start'):
                event['slur_start'] = True
                spread += 1
            if (part, event['tick'], 'stop') in spreadable \
                    and not event.get('slur_stop'):
                event['slur_stop'] = True
                spread += 1
        if spread:
            self.warnings.append(
                f'{spread} chord-root slur endpoints spread to stafffellows '
                '(MusicXML hangs a chord\'s slurs on its lowest note)')

    def _fill_implied_parts(self):
        """Give a part its notes back where the source left them implied.

        In these MuseScore sources an absent voice does not mean silence.
        Silence is written out as a rest; absence means "nothing separate to
        say here". So where one part on a staff has nothing at a given
        moment, it is either doubling its stafffellow or riding inside that
        fellow's chord stack:

            fellow has a chord stack -> the parts diverge; take the note
                                        belonging to this part's register
            fellow has a single note -> the parts are in unison; double it
            an explicit rest         -> genuinely silent; leave it alone

        Reading absence as silence instead drops the lower part for those
        stretches. In the unison case the dropped part is doubling something
        still being sung, so the MIDI sounds right and only the printed part
        goes empty - which no amount of listening will catch.
        """
        if not self.staff_parts:
            return
        added = []
        reassigned = []
        for parts in self.staff_parts:
            upper, lower = parts[0], parts[1]
            # What each part has written at each onset.
            written = {part: {} for part in parts}
            for event in self.events:
                if event.get('part') in written and event['kind'] != 'time':
                    written[event['part']].setdefault(event['tick'], []).append(event)

            for part, fellow in ((upper, lower), (lower, upper)):
                for tick, group in written[fellow].items():
                    if tick in written[part]:
                        continue
                    if any(e['kind'] == 'rest' for e in group):
                        continue              # explicit rest: really silent
                    notes = sorted((e for e in group if e['kind'] == 'note'),
                                   key=lambda e: _pitch_rank(e['name']))
                    if not notes:
                        continue
                    if len(notes) > 1:
                        # One stack standing in for both parts: hand the end
                        # matching this part's register straight over, rather
                        # than copying it and leaving the original orphaned.
                        take = notes[0] if part is lower else notes[-1]
                        keep = notes[-1] if fellow is upper else notes[0]
                        if take is not keep:
                            reassigned.append((take, part))
                            continue
                        # This part's note is the one the fellow must keep,
                        # so there is nothing here to hand over.
                        continue
                    # Unison: both parts sing the single written note, so
                    # this one really is a copy.
                    clone = dict(notes[0])
                    clone['part'] = part
                    clone['implied'] = True
                    added.append(clone)

        for event, part in reassigned:
            event['part'] = part
        if added:
            self.events.extend(added)
            self.events.sort(key=lambda e: e['tick'])
            self.warnings.append(
                f'{len(added)} implied notes restored (absent voice = '
                'doubling or divisi, not silence)')

    def _warn_irregular_measures(self):
        """Flag interior measures LONGER than the metre.

        MuseScore writes these with len="9/8" on the <Measure> and no
        <TimeSig>, so nothing in the note data says the bar is longer.
        The converter emits one \\time for the song, LilyPond measures the
        bar against it, and every voice reports a barcheck failure at the
        same places - which reads like a bad conversion when the notes are
        in fact correct and only the metre declaration is wrong.

        Only over-long measures are reported. Short interior measures are
        common and harmless: they are phrase-end fermata bars and the two
        halves of a measure split across a repeat, which LilyPond absorbs
        without complaint. Warning on those too was the first version of
        this check and it fired on 166 of 297 songs, 146 of them for short
        bars alone - we-gather-together, when-jesus-wept and
        each-morning-brings-us all compile with 0 barchecks despite having
        them. A warning that cries wolf five times out of six is worse
        than none, because it trains you to skip the one that matters.

        Reported rather than fixed: the right answer is a \\time change (and
        usually a hidden signature, since hymnals rarely print these), and
        which of the two the engraving wants is a judgement about the page.
        woman-in-the-night is the worked example - m6-m9 are 9/8, 9/8, 4/4,
        4/4 inside a 7/8 song, and every voice barchecked three times.
        """
        if not self.measures or self.time_sig is None:
            return
        full = Fraction(self.time_sig[0], self.time_sig[1]) * 4 * self.divisions
        odd = []
        # Skip measure 0: a short first bar is a pickup, handled separately.
        for index, (_start, length, _implicit) in enumerate(self.measures[1:], 2):
            if length and length > full:
                odd.append((index, Fraction(length, self.divisions) / 4))
        if odd:
            shown = ', '.join(
                'm%d=%s/%s' % (i, f.numerator, f.denominator) for i, f in odd[:8])
            more = '' if len(odd) <= 8 else ' (+%d more)' % (len(odd) - 8)
            self.warnings.append(
                '%d measure(s) longer than %d/%d: %s%s. The notes are right; '
                'the metre declaration is not. Add a \\time change at each '
                '(and hide the signature if the hymnal prints none), or every '
                'voice will barcheck there.'
                % (len(odd), self.time_sig[0], self.time_sig[1], shown, more))

    def _detect_pickup(self):
        """Record an anacrusis so the parts can emit \\partial.

        MuseScore usually does not mark the pickup measure implicit="yes" -
        only 44 of the 136 scores here that begin with one carry the flag.
        What it always does is write a short first measure, so measure it
        rather than trusting the attribute. Without this every barline in
        the song lands a beat early and LilyPond reports a barcheck failure
        for the whole piece.
        """
        self.pickup = 0
        if not self.measures or self.time_sig is None:
            return
        start, length, implicit = self.measures[0]
        full = Fraction(self.time_sig[0], self.time_sig[1]) * 4 * self.divisions
        if length and length < full:
            self.pickup = length
            if not implicit:
                self.warnings.append(
                    f'pickup of {length}/{int(full)} not marked implicit in the '
                    'source; detected by measure length')

    def _read_note(self, note, cursor, measure_end, divisions):
        duration = int(text_of(note, 'duration', '0') or 0)
        is_chord_note = note.find('chord') is not None
        key = (note.findtext('staff'), note.findtext('voice'))
        if is_chord_note and key == self._last_key:
            # Stacked note: shares the onset of the note below it.
            cursor_start = cursor - self._last_duration
            self._stack += 1
        else:
            cursor_start = cursor
            self._stack = 0
        self._last_key = key

        if note.find('grace') is not None:
            self.warnings.append('grace note dropped')
            return cursor, measure_end

        # Clamp to the deepest slot this voice actually has, so a chord
        # thicker than usual folds into the lowest part instead of vanishing.
        stack = min(self._stack, self._max_stack.get(key, 0))
        part = self.voice_map.get(key + (stack,))
        if note.find('rest') is not None:
            event = {'tick': cursor_start, 'kind': 'rest',
                     'duration': duration, 'part': part}
            self.events.append(event)
        else:
            pitch = note.find('pitch')
            if pitch is None:
                return cursor, measure_end
            step = text_of(pitch, 'step', 'C')
            octave = int(text_of(pitch, 'octave', '4') or 4)
            alter = int(float(text_of(pitch, 'alter', '0') or 0))
            tie_start = any(t.get('type') == 'start' for t in note.findall('tie'))
            tie_stop = any(t.get('type') == 'stop' for t in note.findall('tie'))
            slur_start = any(
                s.get('type') == 'start' for s in note.findall('notations/slur'))
            slur_stop = any(
                s.get('type') == 'stop' for s in note.findall('notations/slur'))
            self.events.append({
                'tick': cursor_start,
                'kind': 'note',
                'duration': duration,
                'part': part,
                'name': self._pitch_name(step, alter, octave),
                'stacked': is_chord_note,
                'tie_start': tie_start,
                'tie_stop': tie_stop,
                'slur_start': slur_start,
                'slur_stop': slur_stop,
            })

        self._last_duration = 0 if is_chord_note else duration
        if not is_chord_note:
            cursor += duration
        measure_end = max(measure_end, cursor)
        return cursor, measure_end

    _last_duration = 0
    _last_key = None
    _stack = 0

    def _pitch_name(self, step, alter, octave):
        name = step.lower() + ALTER_SUFFIX.get(alter, '')
        # LilyPond absolute octaves: c' is middle C (MusicXML octave 4).
        if octave >= 4:
            name += "'" * (octave - 3)
        else:
            name += ',' * (3 - octave)
        return name

    def _read_harmony(self, harmony):
        root_step = text_of(harmony, 'root/root-step')
        if not root_step:
            return None
        root_alter = int(float(text_of(harmony, 'root/root-alter', '0') or 0))
        kind_elem = harmony.find('kind')
        kind = (kind_elem.text or '').strip() if kind_elem is not None else ''
        if kind == 'none':
            return None
        if kind not in CHORD_KINDS:
            text = kind_elem.get('text') if kind_elem is not None else None
            self.warnings.append(f'unmapped chord kind {kind!r}'
                                 + (f' (text {text!r})' if text else ''))
            suffix = ''
        else:
            suffix = CHORD_KINDS[kind]
        name = root_step.lower() + ALTER_SUFFIX.get(root_alter, '')
        bass_step = text_of(harmony, 'bass/bass-step')
        bass = ''
        if bass_step:
            bass_alter = int(float(text_of(harmony, 'bass/bass-alter', '0') or 0))
            bass = '/' + bass_step.lower() + ALTER_SUFFIX.get(bass_alter, '')
        return {'name': name, 'suffix': suffix, 'bass': bass}


def render_part(score, part):
    """Emit the LilyPond note sequence for one SATB part.

    Notes sharing an onset within a part are emitted as a chord (<c e>4)
    rather than dropped: divisi passages put two notes in one part, and
    keeping only the first silently loses a harmony line.
    """
    events = [e for e in score.events
              if e.get('part') == part or e.get('kind') == 'time']
    events.sort(key=lambda e: (e['tick'], 0 if e['kind'] == 'time' else 1))

    # Group note events that start at the same tick.
    grouped = []
    for event in events:
        if (event['kind'] == 'note' and grouped
                and grouped[-1][0]['kind'] == 'note'
                and grouped[-1][0]['tick'] == event['tick']):
            grouped[-1].append(event)
        else:
            grouped.append([event])

    out = []
    cursor = 0
    measure_index = 0
    measure_bounds = [(start, start + length)
                      for start, length, _ in score.measures]

    # An anacrusis has to be declared before the first note, and after the
    # \time it belongs to, or every barline after it lands a beat early.
    pickup = getattr(score, 'pickup', 0)
    pending_partial = None
    if pickup:
        pieces = duration_to_lily(pickup, score.divisions)
        if pieces:
            pending_partial = f'\\partial {pieces[0][0]}'

    def bar_to(tick):
        nonlocal measure_index
        while (measure_index < len(measure_bounds)
               and measure_bounds[measure_index][1] <= tick):
            measure_index += 1
            if measure_index < len(measure_bounds):
                out.append('|')

    def flush_partial():
        nonlocal pending_partial
        if pending_partial:
            out.append(pending_partial)
            pending_partial = None

    # A \time is emitted only when it actually changes the metre.
    # \globalParts already applies \hymnTime and then \hymnBeatStructure,
    # in that order; a redundant \time re-runs LilyPond's default grouping
    # for the metre and silently discards the beat structure. A 7/8 song
    # set to 3,2,2 came out with its eighths unbeamed for exactly this
    # reason.
    #
    # This tracks the metre in force rather than only skipping the opening
    # one, because MuseScore also restates the metre mid-score without
    # changing it - joyful-is-the-dark carries a second 2/2 <TimeSig> at
    # m9, which the hymnal does not print. Those restatements are not
    # harmless: a part whose m9 begins with a rest emitted the \time a
    # measure earlier than the others, so the same no-op landed in
    # different bars in different voices.
    current_time = tuple(score.time_sig)

    for group in grouped:
        event = group[0]
        if event['kind'] == 'time':
            redundant = tuple(event['time_sig']) == current_time
            current_time = tuple(event['time_sig'])
            if not redundant:
                out.append(
                    f"\\time {event['time_sig'][0]}/{event['time_sig'][1]}")
            flush_partial()
            continue
        flush_partial()
        if event['tick'] > cursor:
            for token, ticks in duration_to_lily(
                    event['tick'] - cursor, score.divisions):
                out.append('r' + token)
                cursor += ticks
                bar_to(cursor)
        if event['tick'] < cursor:
            # Starts before the cursor: it overlaps a longer note already
            # written in this part and cannot be placed on one voice.
            continue
        if event['kind'] == 'rest':
            for token, ticks in duration_to_lily(event['duration'], score.divisions):
                out.append('r' + token)
                cursor += ticks
                bar_to(cursor)
            continue

        # Simultaneous notes share the shortest duration so the part stays
        # rhythmically consistent.
        duration = min(e['duration'] for e in group)
        pieces = duration_to_lily(duration, score.divisions)
        if not pieces:
            continue
        names = []
        for e in group:
            if e['name'] not in names:
                names.append(e['name'])
        for index, (token, ticks) in enumerate(pieces):
            if len(names) > 1:
                head = '<' + ' '.join(names) + '>'
            else:
                head = names[0]
            text = head + token
            first, last = index == 0, index == len(pieces) - 1
            if first and any(e['slur_start'] for e in group):
                text += '('
            if last and any(e['slur_stop'] for e in group):
                text += ')'
            if last and any(e['tie_start'] for e in group):
                text += '~'
            elif not last:
                text += '~'
            out.append(text)
            cursor += ticks
            bar_to(cursor)
    return ' '.join(_balance_slurs(out))


def _balance_slurs(tokens):
    """Drop slur parens that no longer have a partner in this part.

    A slur endpoint can survive on the event while the note carrying it does
    not reach the output: overlapping events are skipped as starting before
    the cursor, and simultaneous ones are merged into a single chord token
    that takes only the group's first opener. Either way the partner paren is
    gone and LilyPond rejects the file outright, so the part is worth strictly
    less than the same part with one slur missing.

    This is deliberately a last-resort net rather than the primary fix. It
    runs on the emitted tokens, which is the only place that knows what was
    actually written, and it removes parens rather than inventing them: an
    unpaired paren is a slur that was already lost, not one to guess at.
    """
    depth = 0
    keep = []
    for token in tokens:
        # Closers first: ')' before any '(' in the same token closes an
        # earlier slur, and a token can carry both, as in "c'4)( d'4".
        for char in token:
            if char == '(':
                depth += 1
            elif char == ')':
                if depth > 0:
                    depth -= 1
                else:
                    token = token.replace(')', '', 1)
        keep.append(token)
    if depth > 0:
        # Unclosed openers: strip from the last one backwards.
        for index in range(len(keep) - 1, -1, -1):
            while depth > 0 and '(' in keep[index]:
                keep[index] = ''.join(keep[index].rsplit('(', 1))
                depth -= 1
            if depth == 0:
                break
    return keep


def render_chords(score):
    """Emit \\chordmode content, holding each chord until the next one."""
    if not score.chords:
        return None
    chords = sorted(score.chords, key=lambda c: c['tick'])
    total = max((start + length for start, length, _ in score.measures),
                default=0)
    out = []
    for index, entry in enumerate(chords):
        end = chords[index + 1]['tick'] if index + 1 < len(chords) else total
        span = end - entry['tick']
        if span <= 0:
            continue
        chord = entry['chord']
        for token, _ in duration_to_lily(span, score.divisions):
            out.append(f"{chord['name']}{token}{chord['suffix']}{chord['bass']}")
    return ' '.join(out)


def write_ly(score, out_path):
    with open(out_path, 'w', encoding='utf-8') as handle:
        handle.write('% This file fragment was generated by from-xml.py\n')
        handle.write(f'title = \\titleText "{score.title}"\n')
        handle.write(f'hymnKey = \\key {KEY_SIG_MAP.get(score.fifths, "c")} \\major\n')
        beats, beat_type = score.time_sig
        handle.write(f'hymnTime = \\time {beats}/{beat_type}\n')
        if beat_type == 8:
            handle.write('hymnBaseMoment = \\set Timing.baseMoment = '
                         '#(ly:make-moment 1/8)\n')
            if beats % 3 == 0:
                handle.write('hymnBeatStructure = \\set Timing.beatStructure = 3,3\n')
        handle.write(f'quarternoteTempo = {score.tempo}\n')
        handle.write('\\include "../../lib/global-parts.ily"\n')
        handle.write('\\include "../../lib/header.ily"\n\n')

        for part in PARTS:
            body = render_part(score, part)
            handle.write(f'{part} = {{ \\globalParts\n')
            if body:
                handle.write('  ' + body + '\n')
            if part == 'soprano':
                handle.write('\\bar "|."\n')
            handle.write('}\n')

        chords = render_chords(score)
        if chords:
            handle.write('\nsongChords = \\chords {\n')
            handle.write('  \\globalChordSymbols\n')
            handle.write('  ' + chords + '\n')
            handle.write('}\n')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', help='MusicXML file')
    parser.add_argument('output', help='LilyPond fragment to write')
    parser.add_argument('--quiet', action='store_true')
    args = parser.parse_args()

    score = Score().parse(args.input)
    write_ly(score, args.output)
    if score.warnings and not args.quiet:
        for warning in sorted(set(score.warnings)):
            print(f'warning: {warning}', file=sys.stderr)


if __name__ == '__main__':
    main()
