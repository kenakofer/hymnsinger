# Agent prompt — removing a `\bar ""` break workaround

Hand one song per agent. The agent does the mechanical pass and reports
numbers; it does not decide whether an output change is acceptable.

Read `removing-break-workarounds.md` first — it has the reasoning behind
every step below.

---

## Task

You are converting **one** song file to drop the obsolete `\bar ""`
break workaround. LilyPond 2.24 made `\break` work mid-measure on its
own, so the invisible barline is redundant.

**File:** `<path>`
**Baseline build:** `<scratch>/baseline64/<song>/`
(`out.midi`, `build.log`, `out-trad.pdf` — already built, do not rebuild it)

### Steps

1. Remove every `\bar ""` (and `\bar " "`) in the file.
   **Leave `\bar "|."` and `\bar "||"` untouched** — those are real
   barlines. Do not move `\bar "|."` inside a `\relative` block; if it is
   already on its own line, keep it there.
2. Remove the trailing `|` bar check at each block boundary you just
   changed — **in all four voices** (soprano, alto, tenor, bass) and in
   the chord line if it has one. Missing a voice is the single most
   common failure.
3. **Do not touch the `\relative` blocks at all** — do not merge them, do
   not split them, do not add or remove octave marks (`'` / `,`), do not
   change a block's reference pitch. Leave the note content exactly as it
   is. Your edits are limited to removing `\bar ""` and the trailing bar
   checks. Any `\relative` edit risks silently transposing a phrase by an
   octave, and bar checks will still pass when it happens — only the MIDI
   comparison catches it.
4. Do **not** remove `\partial` unless it is provably redundant. When in
   doubt, leave it.
5. Delete any comment in the file that claims `\bar ""` is required for a
   mid-measure break — that is pre-2.24 advice.

### Build

Build to a scratch directory. **Never** write into
`docs/local-lilypond-outputs/`.

```bash
lilypond -o <scratch>/conv/<song>/out lilypond/songs/<song>/<song>.ly \
  > <scratch>/conv/<song>/build.log 2>&1
```

### Report exactly these four numbers

```bash
# 1. bar checks, baseline vs yours
grep -icE 'barcheck' <baseline>/build.log
grep -icE 'barcheck' <conv>/build.log

# 2. MIDI equality
cmp -s <baseline>/out.midi <conv>/out.midi && echo SAME || echo DIFFERS

# 3+4. engraving bbox and ink delta
pdftoppm -r 100 -png <baseline>/out-trad.pdf <scratch>/b
pdftoppm -r 100 -png <conv>/out-trad.pdf     <scratch>/n
python3 -c "
from PIL import Image, ImageChops
import numpy as np, glob
a=Image.open(sorted(glob.glob('<scratch>/b-*.png'))[0]).convert('L')
b=Image.open(sorted(glob.glob('<scratch>/n-*.png'))[0]).convert('L')
A=np.array(a).astype(int); B=np.array(b).astype(int)
print('bbox:', ImageChops.difference(a,b).getbbox())
print('ink_delta:', int((B<128).sum()-(A<128).sum()))
print('ink_total:', int((A<128).sum()))"
```

Report as:

```
<song>: barchecks <base> -> <new> | MIDI <SAME|DIFFERS> | bbox <...> | ink <+N> of <total>
```

### Decision rules — follow these exactly

| Condition | Action |
| --- | --- |
| MIDI DIFFERS | **Revert the file.** Report it. This is always a bug, never a judgement call. |
| bar checks higher than baseline | **Revert.** Report which lines fail (`grep -iE barcheck`). Usually a voice you missed in step 2. |
| bbox `None` | Keep. Clean conversion. |
| bbox only a ~4x7 px box near the page bottom | Keep. That is the footer date. |
| bbox large, `abs(ink_delta) / ink_total < 0.001` | Keep. Horizontal respacing, expected. |
| `ink_delta` positive by more than ~0.1% | **Stop and escalate.** A symbol was added — usually an accidental the removed barline used to cancel. |
| `ink_delta` negative by more than ~0.1% | **Stop and escalate.** Often the last system no longer justifying to the right margin. Check whether `\bar "|."` moved. |

Do not "fix" an escalation case yourself. Report the numbers and stop.

### Do not

- Do not rebuild the baseline; it already exists.
- Do not touch `lilypond/lib/`.
- Do not commit.
- Do not run the full site build.
- Do not report success without all four numbers.
