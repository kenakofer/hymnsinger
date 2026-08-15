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

%% \bar "" (empty) — 64 files, not yet converted
\relative g' { ... | b2. \bar "" } \break
```

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
   applied consistently.
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
- `\bar ""` — **not started**, 64 files.

See also `lilypond-upgrade-notes.md` for the 2.24.4 switch itself.
