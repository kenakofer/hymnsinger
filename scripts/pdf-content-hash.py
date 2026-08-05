#!/usr/bin/env python3
"""Hash a PDF's engraved content, ignoring the metadata that changes every run.

Two LilyPond runs over identical source never produce byte-identical PDFs:
Ghostscript stamps a wall-clock timestamp and a random document id into each
one. Strip those and what remains - the page content streams - is stable, so
the hash answers "did the music change?" rather than "was this rebuilt?".

Finding all the churn took some digging; each pattern below is here because
leaving it out let a diff through:

  - /CreationDate and /ModDate in the trailer.
  - the SAME two timestamps again inside the embedded XMP packet. Stripping
    only the trailer keys leaves these behind, which is easy to miss.
  - /ID, which appears in two different syntaxes depending on the file - hex
    <..><..> and literal (..)(..) with escaped binary.
  - xapMM:DocumentID / InstanceID, written as XML *attributes*, not elements.

Binary-safe by construction: it works on bytes and never decodes as text.

Usage:
    pdf-content-hash.py FILE [FILE ...]      # "<sha256>  <path>" per line

Note this is a *content* hash of an output file, not a build cache key. By the
time a PDF exists the engraving is already paid for, so it cannot be used to
skip LilyPond; song_fingerprint in generate-all-outputs.sh is the gate that
does that. This is for telling real changes from rebuild noise.
"""
import hashlib
import re
import sys

PATTERNS = [
    re.compile(rb'/CreationDate\s*\(D:[^)]*\)'),
    re.compile(rb'/ModDate\s*\(D:[^)]*\)'),
    re.compile(rb'/ID\s*\[\s*<[0-9A-Fa-f]*>\s*<[0-9A-Fa-f]*>\s*\]'),
    re.compile(rb'/ID\s*\[\s*\((?:[^()\\]|\\.)*\)\s*\((?:[^()\\]|\\.)*\)\s*\]', re.S),
    re.compile(rb'<xmp:ModifyDate>[^<]*</xmp:ModifyDate>'),
    re.compile(rb'<xmp:CreateDate>[^<]*</xmp:CreateDate>'),
    re.compile(rb'<xmp:MetadataDate>[^<]*</xmp:MetadataDate>'),
    re.compile(rb"xapMM:DocumentID='[^']*'"),
    re.compile(rb"xapMM:InstanceID='[^']*'"),
]


def pdf_content_hash(path):
    with open(path, 'rb') as fh:
        data = fh.read()
    for pat in PATTERNS:
        data = pat.sub(b'', data)
    return hashlib.sha256(data).hexdigest()


def main(argv):
    if not argv:
        print(__doc__.strip().splitlines()[0], file=sys.stderr)
        print("usage: pdf-content-hash.py FILE [FILE ...]", file=sys.stderr)
        return 2
    status = 0
    for path in argv:
        try:
            print("%s  %s" % (pdf_content_hash(path), path))
        except OSError as exc:
            print("pdf-content-hash: %s" % exc, file=sys.stderr)
            status = 1
    return status


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
