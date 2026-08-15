#!/usr/bin/env python3
r"""Drop all but the first \partial inside the soprano block of a song file.

    drop-repeated-partial.py [--dry] <file.ly> [...]

Only touches the soprano voice: a \partial in a lower voice is that
voice's own pickup declaration, and breaks are driven from soprano
anyway. Leaves everything else -- \relative, notes, bar checks -- alone.

ALWAYS REBUILD AND COMPARE AFTERWARDS. This edit is unsafe on most files
and there is no way to tell which from reading them. A repeated \partial
is sometimes leftover break scaffolding and sometimes a real declaration
that a measure is short; drop the latter and the next measure goes
overfull, failing every subsequent bar check in that voice. Measured
across the corpus: 20 songs tolerate this, 31 do not.

Neither the lower voices' \partial counts nor the file's history predicts
which group a song is in -- see docs/removing-break-workarounds.md. Build
it and check, with scripts/compare-song-outputs.py.
"""
import re, sys

def main(path, dry=False):
    txt = open(path, errors='ignore').read()
    m = re.search(r'^(soprano\s*=\s*\{)(.*?)(^\})', txt, re.S | re.M)
    if not m:
        print(f"SKIP {path}: no soprano block"); return 0
    head, body, tail = m.groups()
    hits = list(re.finditer(r'\\partial\s+[0-9]+\.*\s*', body))
    if len(hits) <= 1:
        print(f"SKIP {path}: {len(hits)} partial(s)"); return 0
    # keep the first, drop the rest (walk backwards so offsets stay valid)
    new = body
    for h in reversed(hits[1:]):
        new = new[:h.start()] + new[h.end():]
    out = txt[:m.start()] + head + new + tail + txt[m.end():]
    if not dry:
        open(path, 'w').write(out)
    print(f"EDIT {path}: dropped {len(hits)-1}, kept 1")
    return len(hits) - 1

if __name__ == '__main__':
    args = [a for a in sys.argv[1:] if a != '--dry']
    for p in args:
        main(p, dry='--dry' in sys.argv)
