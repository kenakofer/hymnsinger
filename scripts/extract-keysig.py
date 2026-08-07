#!/usr/bin/env python3
"""Fold a build's landmark positions into a song's page data.

lilypond/lib/keysig-position.ily writes one line per book per landmark during
the ordinary PDF/PNG run:

    <book> <what> <x> <y> <w> <h>

as fractions of the engraving. This collects them under "landmarks" in
docs/_data/songs/<song>.json, which the song page reads to position UI against
the music - the transpose arrows on the key signature, and eventually
autoscroll on where the music ends.

Only the geometry is stored. How far the arrows sit from the key signature is
taste, and lives in the stylesheet, so retuning the look never means rebuilding
150 songs.
"""
import argparse
import json
import os
import sys

# What a landmark line must carry to be usable. Anything else is ignored rather
# than rejected, so a future landmark can be added to the .ily and shipped
# before this script knows about it.
FIELDS = ('x', 'y', 'w', 'h')

# The landmark whose only job is to be found again in the rendered image, so
# the rest can be corrected. Not stored.
REFERENCE = 'staffref'

# Landmarks that stay usable with no width, because nothing is positioned
# against their horizontal centre. The final bar line is wanted for where the
# music ends vertically; the arrows, which do need a width, are on the key
# signature.
ZERO_WIDTH_OK = frozenset({'lastbar'})

# How much of the image's width a row must be dark across to count as a staff
# line. Staff lines are the widest ink on the page by a long way; 0.8 clears
# lyrics, slurs and beams without needing the line to reach the margins.
STAFF_ROW_COVERAGE = 0.8

# The scan runs on a 1/8-scale decode, which is plenty to find a line that is
# hundreds of pixels wide and keeps the whole step to about 0.05s an image.
SCAN_DIVISOR = 8


def read_landmarks(path):
    """{book: {what: {x, y, w, h}}} from the .ily's output file."""
    out = {}
    with open(path) as fh:
        for line in fh:
            parts = line.split()
            if len(parts) != 2 + len(FIELDS):
                continue
            book, what = parts[0], parts[1]
            try:
                nums = [float(v) for v in parts[2:]]
            except ValueError:
                continue
            # A flat box carries no position to anchor to. Height is required
            # of everything; width only of the landmarks something is centred
            # on horizontally.
            #
            # A bar line really can report zero width: it is a thin rule, and
            # on the lead books its stencil's X extent collapses to a point.
            # Rejecting those cost every lead book its lastbar - the landmark
            # autoscroll is the whole reason for - while x and h were both
            # perfectly good.
            if nums[3] <= 0:
                continue
            if nums[2] <= 0 and what not in ZERO_WIDTH_OK:
                continue
            out.setdefault(book, {})[what] = dict(zip(FIELDS, [
                round(v, 5) for v in nums]))
    return out


def _scan(png):
    """A small greyscale array for `png`, or None. Cached per path.

    One decode serves both measurements; at 1/8 scale the whole scan is about
    0.05s an image, which is what keeps this affordable at 13 books a song.
    """
    if png in _scan.cache:
        return _scan.cache[png]
    result = None
    try:
        from PIL import Image
        import numpy as np
        im = Image.open(png)
        if im.height:
            im.draft('L', (max(1, im.width // SCAN_DIVISOR),
                           max(1, im.height // SCAN_DIVISOR)))
            arr = np.asarray(im.convert('L'))
            if arr.ndim == 2 and arr.size:
                result = arr
    except (ImportError, OSError, ValueError):
        result = None
    _scan.cache[png] = result
    return result


_scan.cache = {}


def music_bottom_row(png):
    """Where the music ends, as a fraction of the image height.

    The last thing on the page is not the music but the footer - the copyright
    waiver and engraver line - and it is nearly full width (measured: x 0.06 to
    0.94, against the final bar line's 0.95), so no column band separates them
    reliably.

    What does separate them is a gap. The footer sits well below the last staff
    - about 240px at 400dpi, far more than the leading inside a system - so the
    bottom of the music is the last ink before the largest gap near the end.
    """
    arr = _scan(png)
    if arr is None:
        return None
    import numpy as np
    h, w = arr.shape
    rows = (arr < 128).any(axis=1).nonzero()[0]
    if not len(rows):
        return None
    # Bands of consecutive inked rows.
    breaks = (np.diff(rows) > 1).nonzero()[0]
    starts = np.concatenate(([rows[0]], rows[breaks + 1]))
    ends = np.concatenate((rows[breaks], [rows[-1]]))

    # Walk up from the bottom past the footer's lines. The footer is two short
    # lines of text at a fixed place on every book - measured at y 4491..4582
    # of 4677 - so it is identified by where it begins rather than by the size
    # of the gap above it. "The largest gap" is the tempting test and it is
    # wrong: on the widely spaced books it picks a hole in the middle of the
    # music instead.
    footer_zone = h * (1.0 - 1.0 / 12.0)
    for start, end in zip(starts[::-1], ends[::-1]):
        if start < footer_zone:
            return float(end + 1) / h
    return float(rows[-1] + 1) / h


def first_staff_row(png):
    """Where the first staff line sits, as a fraction of the image height.

    Returns None if the image cannot be read or holds no staff-like row.

    This exists because LilyPond's own numbers put every landmark too high by
    the height of the title block: a page's `configuration` gives a system's
    offset within the music area, not from the paper's edge, and no \\paper
    term was found that supplies the rest. The error is identical for every
    landmark in a book, so measuring one line that is easy to find unambiguously
    corrects all of them. See the note on ht:ink-box in keysig-position.ily.
    """
    arr = _scan(png)
    if arr is None:
        return None
    import numpy as np
    h, w = arr.shape
    # The middle half only: a staff line spans it, while page furniture at the
    # edges does not.
    mid = arr[:, w // 4:3 * w // 4]
    if not mid.size:
        return None
    dark = (mid < 128).mean(axis=1)
    rows = (dark > STAFF_ROW_COVERAGE).nonzero()[0]
    if not len(rows):
        return None
    return float(rows[0]) / h


def anchor(found, image_for_book):
    """Put each book's landmarks where the ink actually is.

    LilyPond's y is short by the height of whatever sits above a system - the
    title block for the first, and a growing amount for each one after it - so
    a single offset does not fix a whole book. What is reliable is that the
    *first* system's error is measurable: find its staff line and shift the
    landmarks on it.

    The last bar line is on the last system, so it is measured directly
    instead, from the bottom up - the final barline is the lowest ink in the
    right-hand part of the page, which is unambiguous.

    A book whose image cannot be read keeps LilyPond's numbers. They are right
    in x and in size and wrong in y, which is more useful than nothing.
    """
    for book, marks in found.items():
        png = image_for_book(book)
        ref = marks.get(REFERENCE)
        if ref:
            measured = first_staff_row(png)
            if measured is not None:
                shift = measured - ref['y']
                # Only landmarks on the first system share this error.
                for what in ('keysig',):
                    if what in marks:
                        marks[what]['y'] = round(marks[what]['y'] + shift, 5)
        if 'lastbar' in marks:
            bottom = music_bottom_row(png)
            if bottom is not None:
                box = marks['lastbar']
                # Keep the height LilyPond reported and hang it off the
                # measured bottom edge.
                box['y'] = round(max(0.0, bottom - box['h']), 5)
    # The reference is scaffolding, not something the page needs.
    for marks in found.values():
        marks.pop(REFERENCE, None)
    return {b: m for b, m in found.items() if m}


def merge(data, found, partial):
    """Fold `found` into `data['landmarks']`.

    A full run replaces the block outright, so a book that has stopped printing
    a key signature loses its stale coordinates rather than keeping them and
    pointing the arrows at blank paper. A partial run only rebuilt some books,
    so it updates those and leaves the others as they were.
    """
    if partial:
        existing = data.get('landmarks') or {}
        existing.update(found)
        found = existing
    if found:
        data['landmarks'] = found
    else:
        data.pop('landmarks', None)
    return data


def main(argv):
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--base', required=True, help="the song's slug")
    ap.add_argument('--landmarks', required=True, metavar='FILE',
                    help='the positions file written by the LilyPond run')
    ap.add_argument('--into', metavar='JSON',
                    help='song data file to merge into; without it the parsed '
                         'landmarks go to stdout')
    ap.add_argument('--partial', action='store_true',
                    help='only some books were rebuilt, so keep the entries '
                         'for the ones that were not')
    ap.add_argument('--images', metavar='DIR',
                    default='docs/local-lilypond-outputs',
                    help='where the rendered PNGs are, for the staff-line '
                         'measurement that anchors the vertical positions')
    args = ap.parse_args(argv)

    try:
        found = read_landmarks(args.landmarks)
    except OSError as exc:
        sys.stderr.write('extract-keysig: %s\n' % exc)
        return 1

    found = anchor(found, lambda book: os.path.join(
        args.images, '%s-%s.png' % (args.base, book)))

    if not args.into:
        json.dump(found, sys.stdout, indent=2, sort_keys=True)
        print()
        return 0

    try:
        with open(args.into) as fh:
            data = json.load(fh)
    except FileNotFoundError:
        # Not an error worth failing a build over: a song can be engraved
        # before its page data exists.
        sys.stderr.write('extract-keysig: no song data yet for %s, skipping\n'
                         % args.base)
        return 0

    merge(data, found, args.partial)

    with open(args.into, 'w') as fh:
        json.dump(data, fh, indent=2, ensure_ascii=False)
        fh.write('\n')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
