# LilyPond upgrade — findings

Scoping spike on branch `lilypond-2.26`. Current production compiler is
2.22.1 (Ubuntu jammy package). 2.24.4 and 2.26.0 were tested from the
upstream binary tarballs under `~/.local/lilypond/`, which install
alongside the system package and do not disturb it.

## Recommendation: go to 2.24.4, not 2.26

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

Note that only the first is Guile-3 specific. The arity change landed in
2.23, so it bites on 2.24 too — which is why unmodified `public-main`
does not build there either.

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

## Still to do before switching

The spike only checked that pages *compile*. Before adopting 2.24:

- Rebuild the full corpus and diff the engravings against 2.22 output.
  Spacing and line-breaking changed between the series, so pages will
  shift even where nothing errors; the footer date already makes every
  rebuild differ, so compare deliberately rather than by file hash.
- Decide how the 2.24 binary is installed for real (the tarball under
  `~/.local` is fine for testing, but the build scripts call plain
  `lilypond` and will pick up the system 2.22).
