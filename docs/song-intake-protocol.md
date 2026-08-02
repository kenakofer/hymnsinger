---
published: false
---

<!--
Internal workflow documentation, not a page on the site.

`published: false` keeps Jekyll from rendering it, and docs/_config.yml
on public-main also lists it under `exclude`. Both are deliberate: this
file lives on public-main so that intake branches - which fork from that
branch - can hand it to the agent, but it describes the private repo's
layout and vetting process and has no business being served from
hymnsinger.com.
-->

# Song intake protocol

How a song goes from photos of a physical hymnal page to a published song.

    scripts/song-intake.sh start <song>      # branch off public-main, convert
    ... the agent edits the .ly ...
    scripts/song-intake.sh finish <song>     # transcribe, publish, build both branches
    ... you look at the render ...
    scripts/song-intake.sh finish <song> --go   # push both branches

The song lands as **one commit** on `intake/<song>`. The agent edits the
`.ly` and never merges, pushes, or touches `main` or `public-main`.

`finish` wraps `transcribe`, `publish`, and a `republish-all.sh` and push
per branch. Those stages stay callable individually when a song needs
picking apart; the normal path does not use them.

Changes to the *tooling* are a separate matter with its own hazards - see
[Keeping the branches in sync](#keeping-the-branches-in-sync).

---

## The branch forks from `public-main`

Not from `main`, which reads backwards for a song that may turn out
copyrighted.

A branch forked from `public-main` differs from it by exactly this song,
so it can be merged there honestly. A branch forked from `main` cannot be
merged there at all - `main` carries copyrighted songs `public-main`
lacks, and the merge would take all of them along.

Forking from the public branch does not make the work public. The branch
lives in the private repo, has no upstream, and `git push` on it refuses.
**Exposure follows merges, not ancestry:** a song that turns out
copyrighted is simply never merged into `public-main`.

---

## What the agent does

Input: photos of the page (title, tune name, meter, attributions), a
close-up of the fine print where the copyright lives, and the hymnal's
title and copyright pages once per hymnal.

Edit `lilypond/songs/<song>/<song>.ly`: `composer`, `poet`, `meter`,
`tags`, and a `\header { copyright = "..." }` block when a notice is
present.

1. **Transcribe, do not recall.** Every value must come from the photo or
   the source file. Outside knowledge - what you know the hymn to say -
   goes in the commit message, never in a field.
2. **Never read notes from the image.** Pitches, rhythms, ties and beaming
   come from the MuseScore/MusicXML source, never from the photo - the
   notes printed on the page may themselves be wrong, and the XML is what
   the corpus is verified against. When a passage looks wrong or unclear,
   dump the XML for those measures rather than zooming into the photo.
   Words carry no such restriction: take lyrics, title, attributions and
   meter from whichever of the two is clearer. The copyright notice is the
   exception - read that from the photo, since it is what the hymnal
   actually asserts.
3. **Null over guess.** A gap costs a minute of review; a wrong value can
   survive for years.
4. **Quote the copyright notice verbatim** - symbol, years, holder, and
   any "admin." clause.
5. **Say what you changed to the music.** Hand fixes belong in the commit
   alongside the metadata, but the message must name them and say why the
   page justifies each one. Nothing refuses a diff that touches the music,
   so the message is the only record that a change was deliberate.

### Run the checkers

    scripts/find-tied-lyrics.py .convert-queue/xml/<song>.xml
    scripts/find-broken-beams.py lilypond/songs/<song>/*.ly

Both report line numbers and skip what is already correct; fix what they
flag. Two things neither script knows:

- **`find-tied-lyrics.py` reads the XML, not the `.ly`**, so it keeps
  firing after you fix the `.ly`. It cannot confirm the fix landed - check
  the engraving.
- **A beam report spanning many notes across several measures is the known
  positional desync**, not a real finding. Verify against the engraving
  before adding `\pa`/`\pt`.

The fixes themselves: a tie whose stop-note carries lyric text becomes
`X\( X\)` (phrasing slur, which lyrics ignore) plus a `_` in each holding
verse. A regular slur `( )` is wrong - it makes *every* verse skip. For
beams, mark one voice only, and always close with `\pt` so the following
notes go back to merging into chords. Worked examples are in
`docs/how-to-new-song.md`; read its appendix table before deciding
something is broken.

### Structural fixes

The converter reads notes and syllables, not musical intent.

| The converter did this | Actually | Example |
|---|---|---|
| Emitted N verses | Verses span two staff systems | `all-creatures-worship-god-most-high` |
| Repeated a chorus in every verse | One chorus, tagged (`\SB`, `\SC`) | `when-israel-was-in-egypts-land` |
| Split one staff into four parts | Song is unison or single-staff | `wakantanka-many-and-great` |
| Gave both staves the same lyrics | Parts have different words | `when-peace-like-a-river` |
| Kept every verse in the score | Later verses belong in `extra_verses` | `we-shall-overcome` |
| Fragmented a beam where parts meet | Each part beams through | `blessed-assurance` |

**Where to stop.** The photo settles *structure* the XML cannot express:
verse boundaries, unison vs. harmony, which staff carries which words,
where a system breaks, whether a second text line exists. It does not
settle notes. Do *not* "fix" a pitch or rhythm that merely looks odd on
the page - check it against the XML, and if the two disagree the XML wins.
The converter's divisi bugs produce parts that are wrong in ways no amount
of staring at the page reveals.

### Barcheck warnings are two different animals

**Leave alone** a measure that is short or long because you disagree with
the converter's *reading* of a rhythm. Editing durations to silence it is
how a wrong note becomes a permanent wrong note.

**Do investigate** a warning from the converter dropping something
outright - dropped rests (non-uniformly across voices), a dropped measure
where the source had a tie, an over-long chord duration. The photo settles
these.

Check whether the raw conversion already produced the warning before
assuming your edit caused it:

    git show <the start commit> -- <the .ly>

`verify-xml-notes.py` reports 0.0% straight through every one of these, so
a clean error rate is not evidence the measure is intact.

### The commit message carries the confidence notes

    Add song "<song>" from <hymnal>, p.<n>

    Copyright-Status: copyrighted | public-domain | unknown | mixed
    Copyright-Notice: <verbatim, or "none visible">
    Copyright-Covers: <text | music | arrangement | translation>
    Copyright-Reasoning: <dates and why>

    Confidence: composer=low, meter=high
    Uncertain: composer's death year illegible; read as 1923, could be 1928
    Source: photos IMG_4471-4473

`Copyright-Status` is machine-read by the publish gate. Two traps:

- **`Copyright-Notice` has a magic value.** `--public` refuses when that
  line holds anything other than literally `none visible`. `(none)`, `n/a`
  and `-` all block the publish, and the refusal reads *"a copyright
  notice is recorded (none)"*, which sounds like the opposite of what
  happened.
- **`Copyright-Reasoning` may not argue from a missing notice.** The gate
  greps the field for no/without/absent/missing near "notice" and rejects
  it, including in a subordinate clause. Say "prints attribution only" and
  cite dates.

---

## Copyright determination

| Status | Meaning | Consequence |
|---|---|---|
| `copyrighted` | A notice covers text, music, or arrangement | private only |
| `public-domain` | Positive dated evidence | eligible for public |
| `unknown` | Cannot tell from the photos | private only |
| `mixed` | e.g. tune is PD, translation is not | private only |

Applied in order:

1. Any copyright notice on the page means `copyrighted` (or `mixed`), and
   the notice is quoted verbatim.
2. Otherwise judge by dates: text and music **both** published before 1930
   is a reliable US public-domain signal.
3. A modern translation, arrangement, or harmonisation carries its own
   fresh copyright. A 1400s tune in a 1985 harmonisation is `mixed`.
4. A hymnal's collection copyright does not by itself make an individual
   old hymn copyrighted; note it and keep judging per song.
5. If 1-4 do not settle it, the answer is `unknown`.

**The bias is one-directional.** `copyrighted`, `unknown` and `mixed` all
route to private, which is the safe outcome. Only positive dated evidence
sends a song public, so an unsure agent costs nothing.

A copyrighted song is a **normal outcome, not a decision point** - it
publishes to `main` only and reaches the private host without ever
touching `public-main`. Findings already worked out are recorded in
`scripts/queue-copyright-notes.txt` so they are not re-derived; a song's
absence from that file means nobody has checked it, not that it is clear.

---

## Your inspection

`finish` stops with the render on disk. Check it before `--go`.

    scripts/song-intake.sh listen <song>     # the audio pass

- [ ] Title, key signature, time signature
- [ ] Note accuracy, **especially alto and tenor** - the converter is
      weakest in inner voices
- [ ] Verse count, and verse text under the right notes
- [ ] Every verse has a syllable under each note the page gives one
- [ ] Repeats, endings, fermatas, chord symbols
- [ ] Attribution lines read as the hymnal prints them
- [ ] Line breaks fall where the hymnal's do
- [ ] Melody sounds like the hymn you know; no part leaps oddly

The converter's known weak spot is divisi passages, which produce parts
that look plausible but sound wrong. **The listen step is what catches
this.**

If something is wrong:

    scripts/song-intake.sh transcribe <song>   # re-run; squashes, does not stack
    git branch -D intake/<song>                # abandon entirely

There is one commit, so `git reset --hard HEAD~1` drops the **whole
song**, conversion included.

---

## What `finish` does

1. `transcribe` - folds the metadata into the song's commit, squashing the
   branch to one commit. Validates `Copyright-Status`, and for
   `public-domain` requires a four-digit date and no missing-notice
   argument.
2. `publish` - refuses unless the `.ly` compiles, no placeholder metadata
   remains, `Copyright-Status` is present and not `unknown`, and the
   branch carries no other song's files. `public-domain` merges into
   `public-main` first, then the song's files are copied into `main`;
   anything else touches `main` only.
3. `republish-all.sh` on each branch the song landed on.

Then it stops. `--go` re-checks the copyright invariant against the live
tree and pushes both branches.

**Only the branch you forked from can receive a real merge.**
`intake/<song>` forks from `public-main`, so `git merge --no-ff` there
carries nothing else. Relative to `main` the merge base is `public-main`'s
own ancient base, so a merge would replay ~1700 files including the 1400+
generated assets each branch keeps in a different directory. `main` takes
the song by file copy instead.

**The invariant: no `.ly` on `public-main` carries a copyright field.**
`main` is a superset and does carry them.

    scripts/song-intake.sh check

Prints both song counts, how many on `main` carry a copyright field,
whether the shared toolchain has drifted, and the invariant itself. Exits
non-zero on a leak. Deliberately no counts are quoted in this document:
they rotted before, and a reader could not tell a real leak from a stale
sentence.

Two things the grep has to get right, both handled by `check`: the field
is indented inside `\header { }`, so anchoring to the line start finds
zero matches on both branches and looks like a pass; and
`hymn-of-breaking-strain` discusses copyright in a `%%` comment, so
comment lines must be excluded.

### Publishing source is not publishing a song

`publish` commits the `.ly` and nothing else. Until `republish-all.sh`
runs, the song is invisible on hymnsinger.com - not broken-looking, simply
absent. `finish` runs it for you; the warning exists for when the stages
are run by hand.

The assets cannot ride along on the intake branch: the two branches keep
them in different places, so one branch cannot satisfy both. `docs/`
assets are load-bearing, not build clutter - Pages does not run LilyPond,
so an asset that is not committed does not exist to a visitor.

`generate-all-outputs.sh` **takes no song argument** - it globs the whole
tree and ignores a name passed to it silently. Use it bare. It decides
"up to date" by content, not mtime: it fingerprints each `.ly` together
with the files it `\include`s. The older mtime test is what produced
~200-file diffs of identical-but-for-the-date PDFs, because `git checkout`
rewrites the mtime of every file that differs between branches.

`scripts/publish-song.sh` was the **older, pre-protocol** path: it pushed
directly and knew nothing about copyright status. It is deleted. The note
survives because the name still turns up in old commits and transcripts -
it is not a script to go looking for. On `main` it had additionally rotted
into running the page generator inside an 18-month-old container image,
whose baked-in `generate-all-hymn-indexes.py` predated the CHORUS/REFRAIN
and comment-stripping fixes and rewrote a dozen songs' lyrics with raw
`% CHORUS` markers before dying on an unrelated song.

---

## Keeping the branches in sync

The intake path moves *songs*. Nothing in it moves a fix to a script, a
layout, or this document.

|  | `main` | `public-main` |
|---|---|---|
| Remote | `origin` (private) | `public-origin` (public) |
| Songs | superset, incl. every copyrighted one | public domain only |
| Served by | private host, no build step | GitHub Pages, `build_type: legacy` |
| Commits | the **built** site, `docs/_site/` | **source**; Pages runs Jekyll |
| Outputs in | `docs/_site/local-lilypond-outputs/` | `docs/local-lilypond-outputs/` |

**The differing layouts are required, not drift. Do not "consolidate"
them.** The private host serves `main` with no build step, so `main` must
commit the pre-built `docs/_site/`; its `_config.yml` carries
`keep_files: [local-lilypond-outputs]` so a local Jekyll run does not wipe
the assets sitting inside `_site`. Pages builds `public-main` itself and
treats `_site` as its own output, rebuilding it - so anything committed
there is discarded, and the assets must live outside it. Moving either
branch to the other's layout takes that site down.

A script written against one branch's `docs/` path runs happily on the
other and silently stages nothing - `republish-all.sh` sat broken on
`main` for exactly this reason. Scripts touching `docs/` should detect the
directory rather than hardcode it.

### Never merge `main` into `public-main`

This is the prohibition the whole protocol exists to enforce. A wholesale
merge in that direction carries every copyrighted song across in one
commit, to a public remote. There is no flag for it and no reviewed
version of it.

The other direction carries no copyright risk but drags 1536 ignored files
onto `main`, and is how a `public-main`-shaped script once arrived on
`main` and sat broken. Port individual files instead.

### Moving a shared fix across

Cherry-pick when the file is genuinely identical on both sides; otherwise
port by hand and test on the target branch. The test is not "did it run"
but "did it reproduce the pages already committed" - run the generator and
check that `git status` shows only what you meant to change.

The **intake toolchain must stay byte-identical**; the authoritative list
is `TOOLCHAIN_SHARED` in `scripts/song-intake.sh`, which is what the drift
check reads. `start` runs whichever copy the intake branch inherited from
`public-main`, so a fix made only on `main` is not the tool the next song
runs. Both `finish` and `check` warn on drift without blocking.

Host-specific scripts are *supposed* to differ - they encode a branch's
`docs/` path or push target. `scripts/build.sh` exists on `main` only and
deliberately: it ends in `jekyll build`, which writes the directory Pages
discards.

To see the full split:

    for f in $(comm -12 \
        <(git ls-tree --name-only main -- scripts/ | sort) \
        <(git ls-tree --name-only public-main -- scripts/ | sort)); do
      a=$(git rev-parse "main:$f"); b=$(git rev-parse "public-main:$f")
      [ "$a" != "$b" ] && echo "DIFF $f"
    done

Compare blob hashes, not `git diff main public-main -- <path>`, which
reports byte-identical paths as differing.

### Batch changes to `lilypond/lib/`

**A one-line edit to a shared `.ily` rebuilds every song on the branch**,
because the fingerprint hashes each `.ly` together with its includes.
`hymn-common.ily`, `header.ily`, `all-notation-outputs.ily` and
`midi-output.ily` are included by essentially every song. Budget **20-30
minutes per branch**.

The cost is per branch, not per change, and does not compound - two lib
edits in one republish cost the same as one. So collect lib changes and
apply them together, do the song work first, and batch the second branch's
republish with whatever else is pending there.

Do not narrow the fingerprint to the `.ly` alone; it would serve stale
output after a lib change. LilyPond's `-ddump-signatures` is not a way out
either: it missed a real change (`tradStaffZoom` 1 → 1.05 altered the PDFs
while every signature stayed identical) and costs more than just rendering
the PDF.

### The public branch drifts from its own remote

`public-main` tracks `public-origin/main` and has diverged before. Before
publishing:

    git fetch public-origin
    git log --oneline --left-right public-main...public-origin/main

---

## Why this shape

The expensive failure is not a wrong composer date - you would catch that.
It is publishing something copyrighted to a public repository, which is
hard to undo.

So the agent works where it is strong: reading fine print off photos and
filling many small fields consistently, on an isolated branch, in commits
you can read one at a time. Every path where it is uncertain leads to
private, and going public needs a positive determination plus an explicit
flag from you.

A song can clear every gate and still be invisible because the *tooling*
on the two branches is not the same. `we-gather-together` reached
`public-main` with no page because `public-main`'s parser had never
learned the `\twoLineSmallText \markup` spelling its header used, and the
page generator stopped. Fixed in `683d740b`; the lesson is the shape, not
the bug.

---

## Resuming the photo indexing

Four agents indexed `~/Downloads/hymnal_a_worship_book` in batches. If
`.hymnal-index.json` is missing, restore the committed snapshot:

    cp docs/hymnal-index/hymnal-index.json .hymnal-index.json

    python3 scripts/index-hymnal-photos.py verify        # resolve conflicts
    python3 scripts/index-hymnal-photos.py list --unindexed
    python3 scripts/index-hymnal-photos.py plan          # review renames
    python3 scripts/index-hymnal-photos.py apply

`apply` refuses to run while `verify` fails, never overwrites, and is
idempotent.

**Conflicts are usually bleed-through.** These pages are thin enough that
the next leaf's hymn number shows faintly at the top corner. When two
photos claim one hymn, open both and keep the one where the number sits
beside a title.

The photos are stored renamed as `h<page>__IMG_*`, so grep the directory
by zero-padded page number rather than trusting the older index entries.
The prompt for indexing agents is `docs/agent-prompt-song-intake.md`.
