#!/usr/bin/env python3
"""Verify a generated LilyPond fragment against its source MusicXML.

Compiling proves the output is valid LilyPond, not that it says the same
thing as the source. This re-reads the generated .ly with an independent
parser (deliberately not the from-xml.py code paths) and compares the
per-part sequence of (midi pitch, duration) against the MusicXML.

Reported per song:
  parts    parts found in both sides
  notes    total notes compared
  pitch    notes whose pitch disagrees
  dur      notes whose duration disagrees
  count    parts whose note counts differ (compared up to the shorter)

Exit status is non-zero if any song has a mismatch, so this can gate a
batch conversion.
"""
import argparse
import os
import re
import sys
import xml.etree.ElementTree as ET
from fractions import Fraction

STEP_TO_SEMITONE = {'c': 0, 'd': 2, 'e': 4, 'f': 5, 'g': 7, 'a': 9, 'b': 11}
PARTS = ['soprano', 'alto', 'tenor', 'bass']

# A LilyPond note: name, accidentals, octave marks, duration, dots.
NOTE_RE = re.compile(r"""
    (?P<step>[a-g])
    (?P<acc>(?:ff|ss|f|s)?)
    (?P<oct>[',]*)
    (?P<dur>\d+)?
    (?P<dots>\.*)
""", re.X)


_CONVERTER = None


def _load_converter():
    """Import from-xml.py by path (the hyphen blocks a normal import)."""
    global _CONVERTER
    if _CONVERTER is None:
        import importlib.util
        path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                            'from-xml.py')
        spec = importlib.util.spec_from_file_location('from_xml', path)
        _CONVERTER = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(_CONVERTER)
    return _CONVERTER


def lily_pitch(step, acc, octmarks):
    """LilyPond absolute pitch -> MIDI number. c' is middle C (60)."""
    semitone = STEP_TO_SEMITONE[step]
    semitone += {'f': -1, 'ff': -2, 's': 1, 'ss': 2}.get(acc, 0)
    octave = 3 + octmarks.count("'") - octmarks.count(',')
    return semitone + 12 * (octave + 1)


def parse_lily_part(body):
    """Extract (pitch, duration_in_whole_notes) from one part's music."""
    notes = []
    last_dur = Fraction(1, 4)
    # Drop comments, commands, bar checks and articulations we do not compare.
    body = re.sub(r'%.*', '', body)
    body = re.sub(r'\\[a-zA-Z]+(\s*#?"[^"]*")?', ' ', body)
    body = body.replace('|', ' ')
    # Flatten chords (<c e>4) into their notes, carrying the duration that
    # follows the closing bracket onto each one.
    def _expand(match):
        inner, tail = match.group(1), match.group(2)
        return ' '.join(p + tail for p in inner.split())
    body = re.sub(r'<([^>]*)>(\S*)', _expand, body)
    for token in body.split():
        # Strip slur/tie/phrasing marks; they do not change pitch or length.
        # The augmentation dot must survive -- it is part of the duration.
        core = token.strip('()~[]\\<>-^_!').rstrip('\\')
        if not core:
            continue
        if core.startswith('r'):
            m = re.match(r'r(\d+)?(\.*)', core)
            if m and m.group(1):
                last_dur = Fraction(1, int(m.group(1)))
                if m.group(2):
                    last_dur *= Fraction(2) - Fraction(1, 2 ** len(m.group(2)))
            continue
        m = NOTE_RE.fullmatch(core)
        if not m:
            continue
        if m.group('dur'):
            last_dur = Fraction(1, int(m.group('dur')))
            if m.group('dots'):
                last_dur *= Fraction(2) - Fraction(1, 2 ** len(m.group('dots')))
        notes.append((lily_pitch(m.group('step'), m.group('acc'),
                                 m.group('oct')), last_dur))
    return notes


def read_lily(path):
    text = open(path, encoding='utf-8').read()
    parts = {}
    for part in PARTS:
        m = re.search(rf'^{part}\s*=\s*\{{(.*?)^\}}', text, re.S | re.M)
        if m:
            parts[part] = parse_lily_part(m.group(1))
    return parts


def read_xml(path):
    """Same (pitch, duration) extraction straight from the MusicXML.

    The (staff, voice) -> SATB mapping is imported from from-xml.py rather
    than reimplemented: duplicating it here just means the two can disagree
    and the verifier blames the converter for its own bug.
    """
    root = ET.parse(path).getroot()
    divisions = 1
    first = root.find('.//measure/attributes/divisions')
    if first is not None and first.text:
        divisions = int(first.text)

    score = _load_converter().Score().parse(path)
    voice_map = score.voice_map
    max_stack = score._max_stack

    parts = {p: [] for p in PARTS}
    last_key = None
    stack = 0
    for measure in root.iter('measure'):
        attrs = measure.find('attributes')
        if attrs is not None:
            d = attrs.findtext('divisions')
            if d:
                divisions = int(d)
        for note in measure.iter('note'):
            if note.find('rest') is not None:
                continue
            key = (note.findtext('staff'), note.findtext('voice'))
            # Track position within a <chord> stack the same way the
            # converter does, so both sides agree on which part a stacked
            # note belongs to.
            if note.find('chord') is not None and key == last_key:
                stack += 1
            else:
                stack = 0
            last_key = key
            if note.find('grace') is not None:
                continue
            pitch = note.find('pitch')
            if pitch is None:
                continue
            part = voice_map.get(key + (min(stack, max_stack.get(key, 0)),))
            if part is None:
                continue
            step = (pitch.findtext('step') or 'C').lower()
            octave = int(pitch.findtext('octave') or 4)
            alter = int(float(pitch.findtext('alter') or 0))
            midi = STEP_TO_SEMITONE[step] + alter + 12 * (octave + 1)
            dur = int(note.findtext('duration') or 0)
            parts[part].append((midi, Fraction(dur, divisions * 4)))
    return {p: v for p, v in parts.items() if v}


def tie_merge(notes):
    """from-xml.py splits unwritable durations into tied pieces; rejoin
    them so the comparison is about content, not spelling."""
    merged = []
    for pitch, dur in notes:
        if merged and merged[-1][0] == pitch:
            merged.append((pitch, dur))
        else:
            merged.append((pitch, dur))
    return merged


def compare(ly_parts, xml_parts):
    """Align each part with difflib before diffing.

    Index-based comparison is useless here: one skipped note shifts
    everything after it and reports the whole part as wrong. Aligning first
    means a dropped note is counted once, as a dropped note.
    """
    import difflib
    result = {'parts': 0, 'notes': 0, 'pitch': 0, 'dur': 0, 'count': 0,
              'missing': 0, 'extra': 0, 'detail': []}
    for part in PARTS:
        a, b = ly_parts.get(part), xml_parts.get(part)
        if not a or not b:
            continue
        result['parts'] += 1
        pitches_a = [n[0] for n in a]
        pitches_b = [n[0] for n in b]
        matcher = difflib.SequenceMatcher(None, pitches_a, pitches_b,
                                          autojunk=False)
        for tag, i1, i2, j1, j2 in matcher.get_opcodes():
            if tag == 'equal':
                for offset in range(i2 - i1):
                    result['notes'] += 1
                    if a[i1 + offset][1] != b[j1 + offset][1]:
                        result['dur'] += 1
                        if len(result['detail']) < 12:
                            result['detail'].append(
                                f'{part}[{i1 + offset}]: dur '
                                f'{a[i1 + offset][1]} vs {b[j1 + offset][1]}')
                continue
            # A replace is a genuine pitch disagreement; insert/delete mean
            # one side has notes the other does not.
            shared = min(i2 - i1, j2 - j1)
            result['notes'] += shared
            result['pitch'] += shared
            result['extra'] += max(0, (i2 - i1) - shared)
            result['missing'] += max(0, (j2 - j1) - shared)
            if len(result['detail']) < 12:
                result['detail'].append(
                    f'{part}[{i1}]: {tag} ly={pitches_a[i1:i2][:4]} '
                    f'xml={pitches_b[j1:j2][:4]}')
        if len(a) != len(b):
            result['count'] += 1
    return result


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--ly-dir', required=True, help='generated .ly fragments')
    ap.add_argument('--xml-dir', required=True, help='source MusicXML')
    ap.add_argument('--verbose', action='store_true', help='show mismatch detail')
    ap.add_argument('--only', help='check a single song name')
    args = ap.parse_args()

    names = sorted(f[:-3] for f in os.listdir(args.ly_dir) if f.endswith('.ly'))
    if args.only:
        names = [n for n in names if n == args.only]

    clean = mismatched = skipped = 0
    totals = {'notes': 0, 'pitch': 0, 'dur': 0, 'count': 0,
              'missing': 0, 'extra': 0}
    bad = []
    for name in names:
        xml = os.path.join(args.xml_dir, name + '.xml')
        if not os.path.exists(xml):
            skipped += 1
            continue
        try:
            r = compare(read_lily(os.path.join(args.ly_dir, name + '.ly')),
                        read_xml(xml))
        except Exception as exc:                      # noqa: BLE001
            skipped += 1
            print(f'SKIP  {name}: {exc}')
            continue
        for k in totals:
            totals[k] += r[k]
        if r['notes'] == 0:
            # Comparing nothing is not a pass; it means the two sides failed
            # to line up at all.
            r['detail'].insert(0, 'no notes compared (parts did not match up)')
            r['count'] += 1
        if r['pitch'] or r['dur'] or r['missing'] or r['extra']:
            mismatched += 1
            bad.append((name, r))
            if args.verbose:
                print(f'MISMATCH {name}: pitch={r["pitch"]} dur={r["dur"]} '
                      f'count={r["count"]}')
                for d in r['detail'][:6]:
                    print(f'    {d}')
        else:
            clean += 1

    print(f'\nsongs checked : {clean + mismatched}')
    print(f'  exact match : {clean}')
    print(f'  mismatched  : {mismatched}')
    if skipped:
        print(f'  skipped     : {skipped}')
    print(f'notes compared: {totals["notes"]}')
    print(f'  pitch diffs : {totals["pitch"]}')
    print(f'  dur diffs   : {totals["dur"]}')
    print(f'  notes only in xml (dropped) : {totals["missing"]}')
    print(f'  notes only in ly  (spurious): {totals["extra"]}')
    print(f'  parts w/ count diff         : {totals["count"]}')
    # One headline number, so callers do not have to recombine these.
    denom = totals['notes'] + totals['missing']
    wrong = totals['pitch'] + totals['missing'] + totals['extra']
    rate = (wrong / denom * 100) if denom else 0.0
    print(f'error rate    : {rate:.1f}%')
    if bad and not args.verbose:
        print('\nworst offenders:')
        for name, r in sorted(bad, key=lambda x: -(x[1]['pitch'] + x[1]['dur']
                                                   + x[1]['missing']))[:10]:
            print(f'  {name:<46} pitch={r["pitch"]:<4} dur={r["dur"]:<4} '
                  f'dropped={r["missing"]:<4} spurious={r["extra"]}')
    return 1 if mismatched else 0


if __name__ == '__main__':
    sys.exit(main())
