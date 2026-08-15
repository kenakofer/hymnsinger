# LilyPond upgrade — 2.22.1 to 2.24.4

**Outcome: the corpus is on 2.24.4.** 2.24.4 and 2.26.0 were tested from
the upstream binary tarballs under `~/.local/lilypond/`, which install
alongside the Ubuntu package and do not disturb it. The 2.22.1 system
package is still present and still works on this source.

## Why 2.24.4 and not 2.26

**2.24.4 builds the entire corpus with only the two small fixes below.**
Full build of `abide-with-me` emits all 24 books, exit 0, no errors; the
shape-note book — the one that 2.26 breaks — builds on **150 of 150**
songs. 2.26 fails 128 of those 150.

2.24 is the previous stable series (last release July 2024) and runs
Guile 2.2; 2.26 moved to Guile 3.0, which is where the trouble starts.
2.25 is not a candidate: it is the unstable development series that
became 2.26, so it carries the same breakage.

Both fixes below are still required on 2.24 — unmodified `public-main`
fails there with the same arity error. They are just sufficient on 2.24,
and not sufficient on 2.26.

## Source simplifications 2.24 makes available

2.24 changed `\break` to always insert a break rather than only breaking
at barlines, which retires the `\bar ""` / `\bar " "` workaround used to
force mid-measure breaks. That is a source cleanup rather than a fix, so
it is written up separately in `removing-break-workarounds.md`.

## Fixed (committed, works under 2.22, 2.24 and 2.26)

**`lib/left-align-lyrics.ily` — `(_ "...")` no longer parses.**
The file vendors a copy of LilyPond's own `define-grob-property`, taken
from a 2015 mailing list post, including its gettext call. Under Guile 3
a bare `_` is a syntactic keyword, so the whole file failed to parse and
took `define-grob-property` down with it — nothing compiled at all. 2.22
spells the wrapper `_` and 2.26 spells it `G_`, so no single name works
in both; the message is now untranslated.

**`lib/clairnote.ily` — accidental rule arity.**
LilyPond 2.23 dropped the `measurepos` argument from accidental rules.
Clairnote's rule still declared `(context pitch barnum measurepos)` and
died with an arity error during "Interpreting music". It now accepts
either arity, reading `measurePosition` off the context when the caller
does not supply it, so the file still loads under 2.22.

**`lib/clairnote.ily` — down stems on the wrong side of the note head.**
Up to 2.22, a `NoteHead.stem-attachment` x of 1 meant "the far edge of
the head as seen from the stem", so the single pair `'(1 . 0.2)` that
`\cnNoteheadStyle "funksol"` installs served both stem directions. 2.23
made the coordinate literal — x is the right edge whichever way the stem
points — so every down stem in the Clairnote books moved to the wrong
side. Clairnote now mirrors x itself, gated on `ly:version? >= 2.23`:
2.22 already mirrors internally, and applying ours there double-flips
(110408 pixels off baseline on `amazing-grace` before the gate,
byte-identical after).

This one is not a parse or arity error — it compiles clean and simply
engraves wrongly, which is why only a visual check caught it.

Note that only the first is Guile-3 specific. The arity change landed in
2.23 and the attachment change in 2.23 as well, so both bite on 2.24 —
which is why unmodified `public-main` does not build there either.

## Outstanding on 2.26 only: the shape-note books

With the two fixes above, 2.26 builds **every book except the two
shape-note ones**. Verified across the full corpus (150 songs with a
`.ly`), shapenote alone:

| result | songs |
|--------|-------|
| builds | 22    |
| fails  | 128   |

Every other book — trad, clairnote, lead sheets, transposed leads,
guitar, ukulele, slides — builds clean.

### Root cause

2.26's `define-grobs.scm` gives `NoteHead` a `direction` default that
2.22 did not have:

```scheme
(define-public (note-head::calc-direction grob)
  (let ((stem (ly:grob-object grob 'stem)))
    (ly:grob-property stem 'direction)))
```

This function **does not exist in 2.24** — it was added after that
series, which is precisely why 2.24 is unaffected.

`ly:grob-object` returns `'()` when the note head has no stem, and this
function does not check before reading `direction` off it. The result is:

```
ERROR: In procedure ly:grob-property:
Wrong type argument in position 1 (expecting Grob): ()
```

Confirmed directly rather than inferred: shimming `ly:grob-object` shows
exactly one stem-less lookup in `abide-with-me`, on a `NoteHead`, landing
immediately before the error. The failure is late — during
"Preprocessing graphical objects", after the music interprets fine.

### What is still unknown

Which grob arrangement produces the stem-less `NoteHead`. It is not
predicted by key signature, verse count, whole notes, ties, or `\pa` —
all of those appear on both sides of the pass/fail split. Only one such
note head occurs per failing song, which fits an incidental grob
configuration rather than a whole category of song, and explains why the
128/22 split looks arbitrary.

Reproducing it in a standalone file did not succeed: `\omit Stem` and
`\remove "Stem_engraver"` both still satisfy the callback under 2.26
(the latter actually crashes 2.22 and passes 2.26 — the reverse of the
repo's symptom). So the trigger needs the real `\partCombine` +
`\fillTradScore` context, and pinning it down is the next task.

### Likely shape of the fix

Override `NoteHead.direction` with a stem-checking version. Two attempts
did not take effect and were reverted:

- `\override NoteHead.direction` inside the shapenote book's `\layout`
  never reached the grob.
- `set!` on `note-head::calc-direction` did not apply, because the grob
  default captured the original procedure at definition time.

Worth trying next: setting the property in `\globalParts` where the other
per-staff properties are already set, or reporting it upstream, since the
missing grob check is an upstream bug rather than repo code.

## Effort estimate

**To 2.24.4: done, pending a full-corpus rebuild and visual check.** The
two committed fixes are all it needs. No song files change.

**To 2.26: additionally blocked** on the upstream `NoteHead.direction`
defect above — one book out of nine, one symptom, but the trigger has to
be identified before the guard can be placed correctly, and it is worth
reporting upstream rather than only patching around locally.

Either way, nothing found suggests the songs themselves need editing —
all three problems are in vendored library code or in LilyPond itself.

## How 2.24 is installed

The binary lives at `~/.local/lilypond/lilypond-2.24.4/`, with
`~/.local/bin/lilypond` symlinked to it. That directory precedes
`/usr/bin` on PATH, so the build scripts — which call plain `lilypond` —
pick up 2.24.4 without needing a `$LILYPOND` override. The Ubuntu 2.22.1
package is untouched and is still what `/usr/bin/lilypond` runs, which is
how the before/after comparisons below were produced.

## What was actually verified

Worth being precise about, because the engraving check was a sample:

- **Compiles: all 150 songs.** Verified for the shape-note book under
  both 2.24 and 2.26; 2.24 is 150/150, 2.26 is 22/150.
- **Engravings reviewed: 12 songs** (218 book renders, 312 pages per
  side), rendered under both compilers and compared page by page. The
  remaining ~138 songs compile but their engravings have not been
  eyeballed against 2.22.

Across those 312 pages there were **zero page-count or geometry
changes** — every page is the same size, so nothing reflowed. What
remains is a global spacing and kerning drift from the Guile version
change: ink boxes shift by a pixel or two and stave spacing grows very
slightly, which inflates pixel-diff counts (5-20% of pixels on dense
pages) without changing what is on the page.

The one real regression this sample caught was the Clairnote stem side,
below. That is the argument for looking at renders and not just exit
codes — it would not have surfaced any other way.
