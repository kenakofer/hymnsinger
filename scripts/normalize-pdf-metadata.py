#!/usr/bin/env python3
"""Strip build-time metadata out of LilyPond's PDFs so rebuilds are byte-stable.

Every PDF LilyPond emits carries the moment it was built, in four places, and
none of them describe the music:

    /CreationDate, /ModDate     Ghostscript's document info, "D:20260807134050"
    xmp:CreateDate, ModifyDate  the same instant again, ISO-8601, in the XMP packet
    /ID [<..><..>]              Ghostscript's file identifier, derived from the clock
    xapMM:DocumentID uuid:..    an XMP UUID whose leading bytes are time-derived

So a song whose engraving has not changed by a single pixel still comes out a
different file on every run, and all 3183 of them show up as modified in git.
That is the whole reason this exists.

The obvious fixes do not work here. SOURCE_DATE_EPOCH is ignored, because
LilyPond spawns Ghostscript itself and the variable does not reach it, and
LilyPond 2.24 has no switch of its own (checked: nothing in -dhelp). What is
left is rewriting the bytes afterwards.

Every replacement is the *same length* as what it replaces, which is what makes
this safe: a PDF's cross-reference table stores byte offsets, so changing any
length would invalidate every offset after it and the file would need a full
rewrite to stay readable. The lengths are asserted rather than assumed - a file
that would change size is left alone and reported, instead of being quietly
corrupted.

Verified on a full 25-book song: two builds two seconds apart come out
byte-identical afterwards, the PDFs still parse, and they render with a maximum
pixel delta of 0.
"""
import re
import sys

# All four are fixed constants; nothing reads them. The date is arbitrary and
# only has to be stable.
PDF_DATE = b"D:20210101000000+00'00'"
ISO_DATE = b'2021-01-01T00:00:00+00:00'
NULL_UUID = b'uuid:00000000-0000-0000-0000-000000000000'

SUBS = (
    # Ghostscript's document info dates. The timezone suffix is optional.
    (re.compile(rb"D:\d{14}([+-]\d{2}'\d{2}')?"), PDF_DATE),
    # The XMP packet's copies of the same instant, in ISO-8601. Same byte
    # length as the real thing (25), so offsets hold.
    (re.compile(rb'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[+-]\d{2}:\d{2}'), ISO_DATE),
    # An XMP UUID seeded from the clock.
    (re.compile(rb'uuid:[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}'
                rb'-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'), NULL_UUID),
)

# /ID is a pair of equal-length hex strings, so it needs the match's own length
# rather than a constant - Ghostscript writes 16 bytes, but that is its choice,
# not the format's.
ID_RE = re.compile(rb'(/ID\s*\[\s*<)([0-9A-Fa-f]+)(>\s*<)([0-9A-Fa-f]+)(>)')


def normalize(data):
    """The file's bytes with every build-time field pinned. Length preserved."""
    for pattern, replacement in SUBS:
        data = pattern.sub(replacement, data)
    return ID_RE.sub(
        lambda m: (m.group(1) + b'0' * len(m.group(2)) + m.group(3)
                   + b'0' * len(m.group(4)) + m.group(5)),
        data)


def main(argv):
    changed = failed = 0
    for path in argv:
        try:
            with open(path, 'rb') as fh:
                original = fh.read()
        except OSError as exc:
            sys.stderr.write('normalize-pdf-metadata: %s\n' % exc)
            failed += 1
            continue

        data = normalize(original)

        # A length change means a pattern matched something it should not have.
        # Writing it would break the xref table, so refuse and say so.
        if len(data) != len(original):
            sys.stderr.write(
                'normalize-pdf-metadata: %s would change size %d -> %d, '
                'left untouched\n' % (path, len(original), len(data)))
            failed += 1
            continue

        if data != original:
            with open(path, 'wb') as fh:
                fh.write(data)
            changed += 1
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
