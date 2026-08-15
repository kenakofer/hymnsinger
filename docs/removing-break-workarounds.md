# Removing the `\bar ""` / `\bar " "` break workarounds

LilyPond 2.24 changed `\break` to **always** insert a break, bypassing the
default rule that breaks only happen at barlines. From the 2.24 changelog:

> The `\break` command now always inserts a break, bypassing all default
> decisions about break points. For example, it is no longer necessary to
> insert `\bar ""` to obtain a mid-measure break.

The corpus predates that change in habit, not in version: songs written
*after* the 2.24.4 switch still carry the workaround, because it was
copied forward from older songs. Everything below is about removing it
safely.

## What the workaround looks like

Two spellings, same purpose — give `\break` a barline to attach to so a
mid-measure break is not discarded:

```lilypond
%% \bar " " (a space) — 11 files, all converted
\relative g' { ... | \partial 2 d2 \bar " " | } \break

%% \bar "" (empty), at a block boundary — 25 files
\relative g' { ... | b2. \bar "" } \break

%% \bar "" (empty), inline mid-stream — 39 files, the easy majority
  ... | fs'4 d'4 \bar "" \break
```

There was also a `bb = { \bar "" \break }` shortcut in
`lib/hymn-common.ily`, used by three songs. Retiring the workaround there
is a one-line library edit rather than three file edits.

Both are now redundant. `\break` alone does the job.

## The recipe

1. **Remove the `\bar ""` / `\bar " "`.** Leave every other `\bar` alone —
   `\bar "|."` and `\bar "||"` are real barlines that must survive.
2. **Remove the trailing `|` bar check at each block boundary — in all four
   voices, plus the chord line if it has one.** Once the invisible barline
   is gone, the break point is no longer a measure boundary, so a bar check
   sitting there fails.
3. **Do not touch the `\relative` blocks at all.** Not merging, not
   splitting, not adjusting octave marks, not changing a reference pitch.
   The note content stays byte-for-byte as it was; the only edits are
   removing the invisible barline and the trailing bar checks. See the
   trap below for why this is a hard rule and not a preference.
4. **Leave `\partial` alone** unless it is provably redundant. A `\partial`
   that declares a real anacrusis is load-bearing; one that only existed to
   split a measure across a system break can go, but only if step 2 is
   applied consistently. See "Repeated `\partial`" below — "provably" means
   built and verified, not reasoned about.
5. **Keep `\bar "|."` on its own line** after the last block. Moving it
   inside the final `\relative` block shortens the last system so it no
   longer justifies to the right margin.

## Verification — all three, every song

Build to a scratch directory, never into `docs/local-lilypond-outputs`.

| Check | How | Pass condition |
| --- | --- | --- |
| Bar checks | `grep -ic barcheck build.log` | same count as baseline (some songs have pre-existing ones) |
| Pitches/rhythms | `cmp base/out.midi new/out.midi` | byte-identical |
| Engraving | pixel-diff the `-trad` PNG against baseline | see below |

**MIDI equality is necessary but not sufficient.** It proves no note or
duration changed; it says nothing about what is printed. The engraving
diff is what catches accidentals, beams, and justification.

Interpreting the engraving diff:

- `bbox: None` — pixel-identical, done.
- A tiny box near the page bottom (~4×7 px) — the footer date, ignore.
- Large bbox, ink volume within ~0.1% — horizontal respacing. The
  invisible barline was acting as a spacing anchor; expected, benign.
- **Ink volume up by hundreds of px** — a symbol was *added*. Usually an
  accidental that the removed barline used to cancel. Look at it.
- **Ink volume down by ~1000 px** — often the last system no longer
  reaching the right margin. Check step 5 above.

## Traps, all of which bit us

**Converting soprano only.** Barlines and breaks are Score-level and driven
from soprano, but bar checks are per-voice. Editing soprano alone changes
the measure structure that alto/tenor/bass are still checking against, and
they fail — in files you never touched. Symptom: dozens of
`barcheck failed` in voices you did not edit. Always do all four.

**Editing `\relative` blocks at all.** Each block resets its octave
reference. Concatenating two blocks re-anchors block 2's first note to
block 1's *last* note, silently transposing whole phrases by an octave.
Bar checks still pass — durations are unaffected — so only the MIDI
comparison catches it.

Hand-computing replacement octave marks to compensate does not work
either: it was attempted here across several rounds and produced wrong
pitches every time, each caught only by MIDI. The rule that survives is
simply to leave the blocks alone. Removing `\bar ""` needs no `\relative`
change, so there is never a reason to make one.

`help-us-to-help-each-other-lord.ly` is the one file in the corpus with
merged blocks, from before this rule existed. It was verified clean and
is deliberately kept that way — it is not a template to copy.

**Moving `\bar "|."` inside the final block.** Shortens the last system.
Keep it on its own line.

**Assuming bar-check failures mean `\break` is not working.** They do not.
`\break` works mid-measure under 2.24. Bar-check failures after removing a
`\partial` mean the measure is genuinely short and nothing declares it —
a different problem with a different fix.

**Stale comments.** Some songs carry comments asserting `\bar ""` is
required for a mid-measure break (e.g. `have-thine-own-way.ly`). These
describe pre-2.24 behaviour and should be deleted as the file is
converted. `dear-lord-and-father-of-mankind.ly` has the correct
post-2.24 note.

## Delegating this

The mechanical part is safe to hand to a cheaper model; the judgement is
not. A workable split:

- **Sonnet agent, per file:** apply the recipe, build to scratch, report
  the three checks as numbers. No keep/revert decisions.
- **Escalate to Opus when:** the engraving diff is anything other than
  `None` / footer-only / respacing-within-0.1%-ink, bar checks rise above
  baseline, or MIDI differs at all.

MIDI differing is always a bug, never a judgement call — the agent should
revert and report rather than escalate.

The prompt to hand an agent, with the thresholds written as a decision
table, is `agent-prompt-break-workaround.md`.

## Status

- `\bar " "` — **done**, 11 files (commit "Drop the \bar " " break
  workaround from the 11 files that used it"). One deliberate output
  change: `o-little-town` gains a natural sign that the removed barline
  used to cancel; judged correct to keep.
- `\bar ""` — **done**, 64 files, plus the `bb` macro in
  `lib/hymn-common.ily` (`bb = { \bar "" \break }` → `bb = { \break }`),
  which covers three more songs without editing them.

### What the `\bar ""` sweep actually needed

Far less than the `\bar " "` set. Two thirds of the files spell it
inline as `\bar "" \break` mid-stream, where deleting the `\bar ""` is
the *entire* edit — no block boundary, so no trailing bar checks to
remove and no `\relative` anywhere near it. The rest sit at a block
boundary and match the `\bar " "` shape. No file needed a `\partial`
removed, and none needed a `\relative` touched.

Results across all 64: **MIDI byte-identical everywhere**, bar-check
counts unchanged (including the six songs with pre-existing failures),
and lyric/marker content identical in every book. The visible change is
horizontal respacing, plus the two deliberate improvements below.

### Two output changes, both kept

**Stem directions flip on some pickup notes.** Removing the invisible
barline changes which measure an anacrusis belongs to, and LilyPond
chooses stem direction per measure context. Clearest in
`when-jesus-wept`, where the canon-entry pickups flip from down-stem to
up-stem. Approved and kept.

**`praise-god-old-hundredth`'s slide deck goes from 9 slides to 8.** The
two French-verse systems now share a slide, comfortably spaced. Character
content is identical (724 either way); nothing was dropped.

### Repeated `\partial` — the other half of the workaround

A `\partial` repeated at every system break was the companion trick: it
split a measure so the next phrase could open on its upbeat. Now that
`\break` breaks wherever it is written, those repeats are often dead
weight. **Often, not always** — and the split is not predictable from
reading the file.

Of 51 songs with a repeated `\partial` in soprano, **20 tolerate dropping
all but the first and 31 do not**. Where it fails it fails loudly: a
`\partial` declares a genuinely short measure, so removing it leaves the
next measure overfull and every later bar check in that voice fails —
141 of them in `a-mighty-fortress-is-our-god`, 132 in
`take-my-life-and-let-it-be`.

Two things that look like they should predict the split and don't:

- **Lower-voice `\partial` counts.** The intuition is that if alto,
  tenor and bass have no `\partial` at the block boundaries, soprano's
  repeats must be scaffolding. A classifier built on this labelled all 62
  candidate files removable, including ones already known to break.
  Useless as a gate.
- **Whether the song previously used `\bar ""`.** `we-gather-together`
  reflowed its lead sheet when its partials were dropped *while the
  invisible barline was still there*, and converts cleanly once it is
  gone. So a file's history says nothing about its current state.

The only reliable method is to drop them, build, and compare. Bar checks
alone separate the two groups cleanly here, which makes this cheap to
test even though it is impossible to predict.

`scripts/drop-repeated-partial.py` does the mechanical edit — soprano
only, since a `\partial` in a lower voice is that voice's own pickup.

### On the verification thresholds

The ink-percentage rule below is **not** a sufficient gate on its own.
The `when-jesus-wept` stem flip moved 18 px on a 30 000 px page — 0.06%,
well inside the "benign respacing" band — while being a real, visible
change. Ink volume tells you *how much* moved, never *what*. Compare
lyric/marker text separately, and look at a render when anything is
flagged.

Two pixel-forensics traps, both hit during this sweep:

- **Fixed y-band probes go stale.** Measuring "barlines in rows 215-244"
  reads garbage once the systems shift vertically; it once reported a
  system losing all four barlines when it had lost none. Find the staff
  rows per image first.
- **Full-height dark columns are not all barlines.** A note stem passes
  the same test, which turned a stem into a phantom "added barline".

`pdftotext` needs care too: word *order* and word *grouping* both shift
with spacing on pixel-identical pages, and LilyPond glyphs extract as
control bytes. Compare the multiset of alphanumeric characters, not the
word sequence.

See also `lilypond-upgrade-notes.md` for the 2.24.4 switch itself.
