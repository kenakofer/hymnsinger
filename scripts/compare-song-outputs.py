#!/usr/bin/env python3
"""Compare two builds of one song, book by book.

    compare-song-outputs.py <baseline-dir> <candidate-dir> [song-label]

Each directory is one song's LilyPond output: out.midi, build.log, and the
out-*.pdf books. Prints one line, prefixed OK or REVIEW.

Written for source cleanups that are meant to leave the music alone --
see docs/removing-break-workarounds.md. What it checks, and why:

  bar checks   Counted against the baseline rather than expected to be
               zero: several songs have pre-existing failures.
  MIDI         Byte equality. Necessary but nowhere near sufficient -- it
               proves no note or duration moved and says nothing at all
               about what is printed.
  page count   A book gaining or losing a page is always worth a look.
  text         The multiset of alphanumeric characters per book. Catches
               a dropped verse or marker.
  pixels       Reported as identical-vs-respaced, not thresholded.

Deliberately *not* an ink-volume threshold. A real stem-direction flip
came to 0.06% of page ink, which any sane threshold would wave through.
Ink tells you how much moved, never what -- so this reports that a book
changed and leaves judging it to a human looking at the render.

Two things that look like signal and are not:

  pdftotext word order and word grouping both shift with spacing on
  pixel-identical pages, and LilyPond glyphs come out as control bytes.
  Hence comparing characters rather than words.

  PDFs embed a build timestamp, so byte-comparing them always reports a
  difference. Compare rendered pages.
"""

import sys, os, glob, subprocess, tempfile, re
from collections import Counter
from PIL import Image, ImageChops


def barchecks(path):
    try:
        with open(path, errors="ignore") as fh:
            return len(re.findall(r"barcheck", fh.read(), re.I))
    except OSError:
        return -1


def chars(text):
    return Counter(c for c in text if c.isalnum())


def pdftotext(path):
    return subprocess.run(
        ["pdftotext", path, "-"], capture_output=True, text=True
    ).stdout


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    base, cand = sys.argv[1], sys.argv[2]
    label = sys.argv[3] if len(sys.argv) > 3 else os.path.basename(base.rstrip("/"))

    issues = []

    before, after = barchecks(f"{base}/build.log"), barchecks(f"{cand}/build.log")
    if after > before:
        issues.append(f"BARCHECK {before}->{after}")

    if not os.path.exists(f"{cand}/out.midi"):
        midi = "MISSING"
        issues.append("MIDI MISSING")
    elif subprocess.run(
        ["cmp", "-s", f"{base}/out.midi", f"{cand}/out.midi"]
    ).returncode:
        midi = "DIFFERS"
        issues.append("MIDI DIFFERS")
    else:
        midi = "SAME"

    books = identical = respaced = 0
    for basepdf in sorted(glob.glob(f"{base}/out-*.pdf")):
        book = os.path.basename(basepdf)[:-4]
        candpdf = f"{cand}/{book}.pdf"
        books += 1
        if not os.path.exists(candpdf):
            issues.append(f"{book} MISSING")
            continue

        if chars(pdftotext(basepdf)) != chars(pdftotext(candpdf)):
            issues.append(f"{book} TEXT-DIFF")

        with tempfile.TemporaryDirectory() as td:
            for tag, src in (("b", basepdf), ("n", candpdf)):
                subprocess.run(
                    ["pdftoppm", "-r", "100", "-png", src, f"{td}/{tag}"],
                    capture_output=True,
                )
            bpages = sorted(glob.glob(f"{td}/b-*.png"))
            npages = sorted(glob.glob(f"{td}/n-*.png"))
            if len(bpages) != len(npages):
                issues.append(f"{book} PAGECOUNT {len(bpages)}->{len(npages)}")
                continue
            changed = any(
                ImageChops.difference(
                    Image.open(x).convert("L"), Image.open(y).convert("L")
                ).getbbox()
                for x, y in zip(bpages, npages)
            )
            respaced += changed
            identical += not changed

    status = "REVIEW" if issues else "OK"
    detail = " | " + "; ".join(issues) if issues else ""
    print(
        f"{status} {label}: barchecks {before}->{after} | MIDI {midi} | "
        f"books {identical} identical, {respaced} respaced of {books}{detail}"
    )


if __name__ == "__main__":
    main()
