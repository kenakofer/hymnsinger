#!/usr/bin/env python3
"""Find beamed runs that \\partCombine fragments.

Two parts share a staff via \\partCombine, which merges them into a
single voice where they sing the same pitch and splits them where they
do not. Both states beam fine on their own: a run that stays split gets
one beam per part, and a run that stays merged gets one beam over the
chord columns, which is what a hymnal prints when the parts move
together.

The break happens when a run contains *both*. The merged note cannot
share a beam with the split notes beside it, so the run comes out as a
flag plus a stub instead of a beam. blessed-assurance opens with the
case: soprano fs' e' d' against alto d' d' d', split for two notes and
merged on the third.

The fix is \\pa ... \\pt around the run, on one voice only. See "Beams
broken by part-combining" in docs/song-intake-protocol.md.

    find-broken-beams.py lilypond/songs/blessed-assurance/*.ly
    find-broken-beams.py lilypond/songs/*/*.ly --summary

Uniformly merged and uniformly split runs are not reported - they beam
correctly and want no annotation. Runs already inside \\pa ... \\pt are
skipped too.

Reported per run: the part pair, the measure it starts in, and the two
parts' pitches, with the merged (unison) notes bracketed. Measure
numbers count barlines in the source and are 0-based from the pickup,
so they locate the run in the .ly rather than on the printed page.
"""
import argparse
import glob
import os
import re
import sys

PAIRS = [('soprano', 'alto'), ('tenor', 'bass')]
BEAMED = ('8', '16', '32')

# A note: name, accidentals, octave marks, then an optional duration.
NOTE_RE = re.compile(r"^([a-g](?:ff|ss|f|s)?[',]*)(\d+)?(\.*)")


def part_body(text, part):
    m = re.search(rf'^{part}\s*=\s*\{{(.*?)^\}}', text, re.S | re.M)
    return m.group(1) if m else None


def tokens(body):
    """(pitch, duration, measure, apart) per note, duration carried forward.

    LilyPond repeats a duration only when it changes, so an unmarked note
    inherits the previous one - the same rule the engraver uses to decide
    what gets beamed.

    `apart` tracks whether \\pa is in force, so a run that has already been
    wrapped is not reported again. \\partCombineApart and \\partCombineAutomatic
    are accepted as well as the \\pa / \\pt shorthands.
    """
    body = re.sub(r'%.*', '', body)
    body = re.sub(r'\\[a-zA-Z]+\s*"[^"]*"', ' ', body)   # \bar "" and friends
    # Keep the part-combine marks; drop every other command.
    body = re.sub(r'\\(?!pa\b|pt\b|partCombineApart\b|partCombineAutomatic\b)'
                  r'[a-zA-Z]+', ' ', body)
    # Flatten chords; a divisi <c e>8 still beams as one column.
    body = re.sub(r'<([^>]*)>(\S*)',
                  lambda m: ' '.join(p + m.group(2) for p in m.group(1).split()),
                  body)

    out = []
    measure = 0
    duration = None
    apart = False
    for token in body.replace('|', ' | ').split():
        if token == '|':
            measure += 1
            continue
        if token in (r'\pa', r'\partCombineApart'):
            apart = True
            continue
        if token in (r'\pt', r'\partCombineAutomatic'):
            apart = False
            continue
        core = token.strip('()~[]\\<>-^_!').rstrip('\\')
        if not core or core.startswith('r'):
            continue
        m = NOTE_RE.match(core)
        if not m:
            continue
        if m.group(2):
            duration = m.group(2)
        out.append((m.group(1), duration, measure, apart))
    return out


def runs(upper, lower):
    """Beamed runs that mix merged and split notes, so the beam breaks."""
    found = []
    run = []
    for i in range(min(len(upper), len(lower))):
        if upper[i][1] in BEAMED:
            run.append(i)
            continue
        found.extend(_check(run, upper, lower))
        run = []
    found.extend(_check(run, upper, lower))
    return found


def _check(run, upper, lower):
    # A single note has no beam to break.
    if len(run) < 2:
        return []
    hits = [j for j in run if upper[j][0] == lower[j][0]]
    # A run that is entirely split, or entirely merged, beams cleanly.
    # Only the mixture fragments.
    if not hits or len(hits) == len(run):
        return []
    # Already wrapped. Marking either voice is enough, so either counts.
    if all(upper[j][3] or lower[j][3] for j in run):
        return []
    return [(run, hits)]


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('files', nargs='+', help='.ly fragments (globs ok)')
    ap.add_argument('--summary', action='store_true',
                    help='one line per song instead of per run')
    args = ap.parse_args()

    paths = []
    for pattern in args.files:
        paths.extend(sorted(glob.glob(pattern)) if any(c in pattern
                     for c in '*?[') else [pattern])

    totals = []
    for path in paths:
        try:
            text = open(path, encoding='utf-8').read()
        except OSError as exc:
            print(f'SKIP {path}: {exc}', file=sys.stderr)
            continue

        song = os.path.basename(path)[:-3]
        lines = []
        for high, low in PAIRS:
            a, b = part_body(text, high), part_body(text, low)
            if not a or not b:
                continue
            upper, lower = tokens(a), tokens(b)
            for run, hits in runs(upper, lower):
                marked = ' '.join(
                    f'[{upper[j][0]}]' if j in hits else upper[j][0]
                    for j in run)
                against = ' '.join(lower[j][0] for j in run)
                lines.append(f'  m{upper[run[0]][2]:<4} {high[:4]}/{low[:4]}'
                             f'  {marked}   vs   {against}')

        if lines:
            totals.append((song, len(lines)))
            if args.summary:
                print(f'{len(lines):4}  {song}')
            else:
                print(f'{song}')
                print('\n'.join(lines))

    if totals:
        print(f'\n{sum(n for _, n in totals)} run(s) in {len(totals)} '
              f'of {len(paths)} song(s)')
        print('fix: wrap each run in \\pa ... \\pt, on one voice only')
    else:
        print(f'no broken beams in {len(paths)} song(s)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
