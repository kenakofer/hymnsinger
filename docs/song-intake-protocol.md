---
published: false
---

<!--
Internal workflow documentation, not a page on the site.

`published: false` keeps Jekyll from rendering it, and docs/_config.yml
on public-main also lists it under `exclude`. Both are deliberate: this
file lives on public-main so that intake branches - which fork from that
branch - can hand it to the agent in Stage 2, but it describes the
private repo's layout and vetting process and has no business being
served from hymnsinger.com.
-->

# Song intake protocol

How a song goes from photos of a physical hymnal page to a published song.

The work happens on a side branch and lands as **one commit per song**,
which is what `publish` merges.

Stage 4 is not the end. It publishes *source*; Stage 5 is what makes the
song appear on the site.

| Stage | Who | Produces |
|---|---|---|
| 1. Convert | you (scripted) | branch off `public-main`; commit: machine-generated notes |
| 2. Transcribe | agent | folds metadata and hand fixes into that commit |
| 3. Inspect | you | approval, correction, or reset |
| 4. Publish | you (scripted) | merge to `public-main` if eligible, then `main` |
| 5. Generate | you (scripted) | commit: `docs/` assets, listing and index pages |

The agent edits the `.ly` directly and commits. It does not decide what
gets published and never touches `main` or `public-main`.

The five stages move one song at a time. Changes to the *tooling* the
stages run on are a separate matter with its own hazards - see
[Keeping `main` and `public-main` in sync](#keeping-main-and-public-main-in-sync).

---

## Why one commit per song

A song lands as a single commit. `start` commits the raw conversion so
there is something to diff against while transcribing, and `transcribe`
**amends** that commit rather than stacking a second one.

Intake used to keep the two apart, and `transcribe` refused a metadata
commit that touched notes or lyrics. The theory was that machine output
and human transcription have different failure modes - the converter is
weakest in divisi passages, transcription fails on a misread date - and
so deserve separate review.

In practice the split cost more than it returned. Hand fixes to the
generated music are a normal part of transcribing a song, not a sign
something went wrong: the converter drops slurs the source never
encoded, system breaks have to be placed by eye, and hymnal pages
contain outright misspellings. All of that surfaces in the same sitting
as the metadata, so the gate mostly produced amend-and-restage busywork.
It also misfired on layout fields like `clairStaffZoom`, which are
neither notes nor lyrics but matched no metadata pattern either.

What actually protects the public remote is the **copyright validation**,
and that never depended on the split. It still runs on every
`transcribe`: `Copyright-Status` must be one of four values, and
`public-domain` must cite a four-digit date and may not argue from a
missing notice. `publish` searches the whole branch for that line rather
than assuming which commit carries it, so it works unchanged.

    git show HEAD                 # the whole song
    git show HEAD --stat          # what it touched

To redo a song's metadata, edit the `.ly` and run `transcribe` again - it
amends in place, so re-running is safe and does not stack commits.

---

## Stage 1 - Convert

    scripts/song-intake.sh start <song-name>

Creates the branch `intake/<song-name>`, runs the conversion, and commits
the result with the converter's own warnings recorded in the message.

Only the `.ly` is committed; PDFs, MIDI and MP3s are git-ignored.

**The branch forks from `public-main`, not `main`.** That looks backwards
for a song that may turn out copyrighted, so it is worth being explicit
about why:

A branch forked from `public-main` differs from it by exactly this song,
so Stage 4 can merge it into `public-main` honestly. A branch forked from
`main` cannot be merged there at all - `main` carries 19 songs
`public-main` lacks, 12 of them copyrighted, and the merge would take all
of them along. That is why publish used to copy the song's files across
one path at a time instead of merging.

Forking from the public branch does not make the work public. The branch
lives in the private repo, has no upstream, and `git push` on it refuses
and suggests `origin` (private). Exposure follows merges, not ancestry: a
song that turns out copyrighted is simply never merged into `public-main`,
and its commits exist only on `main`.

---

## Stage 2 - Agent transcribes the hymnal page

### Input

Photos of the hymnal page for one song:

- the full page (title, tune name, meter, attributions)
- a close-up of the fine print under or beside the score, which is where
  the copyright and administrator usually live
- the hymnal's title and copyright pages, **once per hymnal**

### What the agent does

Edit `lilypond/songs/<song>/<song>.ly` directly, filling in `composer`,
`poet`, `meter`, `tags`, and a `\header { copyright = "..." }` block when
a notice is present. Then commit with `scripts/song-intake.sh transcribe`,
which enforces the message format below.

Rules:

1. **Transcribe, do not recall.** Every value must be visible in a photo.
   Outside knowledge goes in the commit message, never in a field.
2. **Null over guess.** Leave a field alone rather than filling it with a
   plausible value. A gap costs a minute of review; a wrong value can
   survive for years.
3. **Quote the copyright notice verbatim**, symbol, years, holder, and any
   "admin." clause.
4. **Say what you changed to the music.** Hand fixes to the generated
   notes and lyrics belong in this commit alongside the metadata, but the
   message has to name them and say why the page justifies each one. The
   script no longer refuses a diff that touches the music, so the commit
   message is the only record that a change was deliberate.

### Structural fixes the agent can make

The converter reads notes and syllables, not musical intent. It gets the
*shape* of a song wrong in ways an agent can often recognise from the
photo and fix, because `docs/how-to-new-song.md` has a worked example of
each. Read its appendix table before deciding something is broken.

Common cases, and the song that demonstrates the fix:

| The converter did this | Actually | Example |
|---|---|---|
| Emitted N verses | Verses span two staff systems (call-and-response, leader/all) | `all-creatures-worship-god-most-high`, `when-israel-was-in-egypts-land` |
| Repeated a chorus in every verse | One chorus, tagged so the extractor sees it once | `when-israel-was-in-egypts-land` (`\SB`, `\SC`) |
| Split one staff into four parts | Song is unison or single-staff | `wakantanka-many-and-great` |
| Gave both staves the same lyrics | Parts have different words | `warm-summer-sun`, `when-peace-like-a-river` |
| Kept every verse in the score | Later verses belong in `extra_verses` below it | `religion-fit-to-last`, `we-shall-overcome` |
| Fragmented a beam where the parts meet | Each part beams straight through | `blessed-assurance` (`\pa`, `\pt`) |

**These land in the song's commit**, along with the metadata. A
structural fix is still a different kind of claim from a transcription,
so it needs its own reasoning — but that reasoning goes in the commit
message rather than in a commit of its own. Say what the page shows and
which example you followed, one bullet per fix.

The converter also flags **syllabic mismatches** in the `.warn` file: a
note where one verse sings a syllable and another holds through it (a lone
gap in an otherwise-parallel verse). That is the signature of a per-verse
melisma — verse 1 subdivides a beat that verses 2-3 hold. The fix is a
phrasing slur `X\( X\)` (auto-dashed here) plus a `_` skip in each holding
verse, following the `we-gather-together` m15 example and the how-to's
"Dotted slur (lyrics ignore)" row. A regular slur `( )` is wrong here: it
forces *every* verse to skip the note and shoves their syllables right.

#### Beams broken by part-combining

`\partCombine` puts two parts on one staff and decides, note by note,
whether to merge them into one voice. It merges where they sing the same
pitch and splits where they do not.

**Neither state is a problem on its own.** A run that stays split gets
one beam per part; a run that stays merged gets one beam over the chord
columns, which is what a hymnal prints where the parts move together.
Most beamed runs are fine and want no annotation.

The break happens when a run contains *both*. A merged note cannot share
a beam with the split notes beside it, so the run fragments into flags
and stubs. `blessed-assurance` opens with the case — soprano `fs' e' d'`
against alto `d' d' d'`, split for two notes and merged on the third:

    %% before - flag, then a two-note beam
    \partial 4. fs'8 e'8 d'8 |

    %% after - one beam per part
    \partial 4. \pa fs'8 e'8 d'8 \pt |

`\pa` (`\partCombineApart`) and `\pt` (`\partCombineAutomatic`) are
defined in `hymn-common.ily`. Two things make this cheaper than it looks:

- **Mark one voice, not both.** Annotating soprano alone is enough; alto
  needs no matching marks.
- **`\pt` matters as much as `\pa`.** It hands the following notes back
  to automatic, so the dotted halves after the run still merge into
  chords. Applying `\partCombineApart` to a whole part instead — or to
  the `\partCombine` call in `hymn-common.ily` — fixes the beams and
  breaks every chord in the song. It was tried; do not retry it.

To find them:

    scripts/find-broken-beams.py lilypond/songs/<song>/*.ly

It reports only the mixed runs, skipping both the uniform ones and any
already wrapped in `\pa`. As of 2026-07-26 that is 118 runs across 44 of
133 songs, out of 510 beamed runs in total — so roughly one beamed run
in four needs the annotation, and about a third of songs have at least
one. Check the render against the photo before wrapping: the script
finds what LilyPond will fragment, not what the hymnal disagrees with.

This is engraving only — `\pa`/`\pt` emit no notes, and
`verify-xml-notes.py` strips them, so the error rate should not move.
Fold it into the same formatting commit as `\break` placement.

**Where to stop.** Fix structure the photo settles: verse boundaries,
unison vs. harmony markings, which staff carries which words. Do *not*
"fix" notes that merely look odd — that is the audio pass's job, and the
converter's divisi bugs produce parts that are wrong in ways no amount of
staring at the page reveals. If barcheck warnings appear, report the
count rather than editing rhythms to silence them; check whether the raw
conversion already produced them.

### The commit message carries the confidence notes

This is where uncertainty lives - not in a sidecar file, because it
belongs with the change it describes and survives in the history:

    Add metadata for <song> from <hymnal>, p.<n>

    Copyright-Status: copyrighted | public-domain | unknown | mixed
    Copyright-Notice: <verbatim, or "none visible">
    Copyright-Covers: <text | music | arrangement | translation>
    Copyright-Reasoning: <dates and why>

    Confidence: composer=low, meter=high
    Uncertain: the composer's death year is illegible; read as 1­923 but
      could be 1928. Meter is not printed; inferred from the syllable
      count and marked low.
    Source: photos IMG_4471-4473

`Copyright-Status` is machine-read by the publish gate. The prose lines
are for you.

### Copyright determination

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
sends a song public, so an unsure agent costs you nothing.

---

## Stage 3 - Your inspection

    scripts/song-intake.sh review <song-name>

Shows the song's commit message, the confidence notes, the header fields
it set, and any converter warnings. The commit carries the whole song, so
`review` prints the metadata fields rather than the full diff — use the
visual pass below to check the music.

### Visual pass

    scripts/convert-queue.sh review <song-name>

- [ ] Title, key signature, time signature
- [ ] Note accuracy, **especially alto and tenor** - the converter is
      weakest in inner voices
- [ ] Verse count, and verse text under the right notes
- [ ] Repeats, endings, fermatas, chord symbols
- [ ] Attribution lines read as the hymnal prints them
- [ ] Line breaks fall where the hymnal's do, and beams run one per part
      (a lone flag next to a short beam means the parts merged
      mid-run — see "Beams broken by part-combining")

### Auditory pass

    scripts/song-intake.sh listen <song-name>

- [ ] Melody sounds like the hymn you know
- [ ] No part leaps oddly (usually a dropped or misassigned note)
- [ ] Cadences are clean, phrase lengths feel right

The converter's known weak spot is divisi passages, which produce parts
that look plausible but sound wrong. **The listen step is what catches
this**, so do not skip it.

### If something is wrong

    git commit --amend                     # fix the message in place
    scripts/song-intake.sh transcribe <song>  # re-transcribe; amends, does not stack
    git branch -D intake/<song>            # abandon entirely

There is one commit now, so `git reset --hard HEAD~1` drops the **whole
song**, conversion included, not just the metadata. To redo the metadata,
edit the `.ly` and run `transcribe` again.

---

## Stage 4 - Publish

    scripts/song-intake.sh publish <song-name> [--public]

Refuses unless:

1. The branch is `intake/<song>` and carries the song's commit
2. The `.ly` compiles
3. No placeholder metadata remains
4. `Copyright-Status` is present and is not `unknown`

**Public first, then `main`.** With `--public` on an eligible song the
branch is merged into `public-main`, checked, and then the song's files
are taken into `main`. Without it, only `main` is touched and
`public-main` never sees the song. Either way `main` ends up a superset of
`public-main`.

Promotion to `public-main` needs **both** `Copyright-Status: public-domain`
**and** an explicit `--public`. Every precondition is checked before
anything is merged, so a refusal never leaves a half-finished publish
behind, and after the public merge the script re-greps the whole tree for
a copyright field - rolling the merge back if one appears, which catches a
mislabelled song that cleared the earlier gates.

### Why one side merges and the other copies

Only the branch you forked from can receive a real merge.

`intake/<song>` forks from `public-main`, so relative to `public-main` it
differs by exactly this song and `git merge --no-ff` carries nothing else.
Relative to `main` it is a different story: the branch's merge base with
`main` is `public-main`'s own ancient base, `db622afa`, so a merge would
replay every file the two branches disagree about - around 1700, including
the 1400+ generated assets each keeps in a different directory for a
different host. That is the wholesale cross-branch merge forbidden below,
arrived at from the happy path. Publishing `when-jesus-wept` hit it as a
rename conflict across the whole of `docs/local-lilypond-outputs/`.

So `main` takes the song by file copy:

    git checkout "$branch" -- "lilypond/songs/$song"

This is inherent, not a wart. The two branches cannot share a recent
ancestor while their `docs/` layouts are dictated by different hosts, and
the fork point decides which side gets the honest merge. It used to be
`main`; it is now `public-main`. The copy always guards the other side,
and the stray-song check above is what keeps it honest either way.

The invariant to protect, which the branches satisfy today: `main` has 146
songs, `public-main` has 127, and **all 12 songs carrying a copyright
field are absent from `public-main`**.

To re-check it at any time:

    for f in $(git ls-tree -r --name-only public-main -- lilypond/songs/ \
                 | grep '\.ly$'); do
      git show "public-main:$f" \
        | grep -qE '^[^%]*copyright[[:space:]]*=' && echo "$f"
    done

That must print nothing; run against `main` it prints 12.

Two things the pattern has to get right, both of which have caught me:

- The field is indented inside `\header { }`, so anchoring to the start of
  the line finds zero matches on *both* branches and looks like a pass.
- `hymn-of-breaking-strain` discusses copyright in a `%%` comment, so the
  pattern must exclude comment lines or it reports a leak that is not one.

Nothing is pushed. Both merges are left for you to review and push.

Private-only is also the resting state for songs that are probably public
domain but unconfirmed - nine such songs sit on `main` today. Not being
public is not a judgement; it is the default.

---

## Stage 5 - Generate the site assets

**`publish` ships source, not a song on the site.** It commits the `.ly`
and nothing else. Until you run this stage the song is invisible on
hymnsinger.com - not broken-looking, simply absent.

    scripts/republish-all.sh

This regenerates outputs, rebuilds the listing and index pages, and
commits `docs/`. It does not push - review, then push the branch you are
on.

**Run it once per branch the song landed on.** A `--public` song is now on
both, and the two branches build their assets into different directories
for different hosts, so generating on one does nothing for the other:

    git checkout public-main && scripts/republish-all.sh
    git push public-origin public-main:main

    git checkout main && scripts/republish-all.sh
    git push origin main

A private song is only on `main`, so only the second pair applies.

The script is incremental, so the second run normally builds only the new
song. `generate-all-outputs.sh` decides "up to date" by **content, not
mtime**: it fingerprints each `.ly` together with the files it
`\include`s and compares that against a stored `.inputhash`. The older
mtime test (`.mp3` newer than `.ly`) is what produced the ~200-file diffs
of identical-but-for-the-date PDFs, because `git checkout` rewrites the
mtime of every file that differs between the branches.

The exception is a change to a shared `lilypond/lib/*.ily`, which
legitimately invalidates every song that includes it - usually all of
them. That is a 20-30 minute rebuild and a reason to batch lib edits; see
[Batch changes to `lilypond/lib/`](#batch-changes-to-lilypondlib---each-one-costs-a-full-rebuild).

### Why publish does not do this

The `lilypond` call in Stage 4 is a **gate, not a build** - it compiles to
`/dev/null` to prove the file is valid, and discards the result.

And the intake branch only ever contains the `.ly`: Stage 1 commits the
source and Stage 2 folds the metadata into that commit, and neither
generates anything under `docs/`. So there is nothing for the merge to
carry.

The generated assets could not ride along even in principle, because the
two branches keep them in different places - `docs/local-lilypond-outputs/`
on `public-main`, `docs/_site/local-lilypond-outputs/` on `main`. A single
intake branch cannot satisfy both. See
[Keeping `main` and `public-main` in sync](#keeping-main-and-public-main-in-sync)
for why those layouts are load-bearing rather than accidental.

### What a published-but-not-generated song is missing

`we-gather-together` was published 2026-07 and is the worked example -
it reached `public-main` with only:

    lilypond/songs/we-gather-together/we-gather-together.ly

and none of:

    docs/local-lilypond-outputs/we-gather-together-*.{pdf,png,mp3,odp}
    docs/listing/we-gather-together.md
    docs/_data/songs/we-gather-together.json

The listing and `_data` files are the ones that matter most. Jekyll builds
the song's page from them, so without them there is no page to link to -
the missing PDFs and MP3s are a second-order problem.

`docs/` assets are load-bearing, not build clutter: hymnsinger.com is a
GitHub Pages site served from this repo, and Pages does not run LilyPond.
An asset that is not committed does not exist to a visitor. The
`.gitignore` rules for `*.pdf`/`*.png`/`*.mp3`/`*.midi` are scoped to
`/lilypond/**`, the source scratch tree; `docs/**` outputs are tracked on
purpose.

### Checking

`publish` warns you at the end when a song has no `docs/listing/<song>.md`
and `docs/_data/songs/<song>.json`, so the gap announces itself rather
than waiting to be noticed on the site.

It keys on those two files only, deliberately not on
`docs/local-lilypond-outputs/`: that directory exists on `public-main`
but not on `main`, so checking it from `main` would warn on every song
and train you to ignore the warning.

Running it after a batch of publishes is cheap and safe, for the
incremental reason noted above.

To find songs that have source but no page:

    comm -13 \
      <(ls docs/listing/*.md | xargs -n1 basename | sed 's/\.md$//' | sort) \
      <(ls -d lilypond/songs/*/ | xargs -n1 basename | sort)

Note `scripts/publish-song.sh` is the **older, pre-protocol** path. It
built `docs/` first and refused to commit without
`docs/listing/<song>.md` and `docs/_data/songs/<song>.json` - the check
that has no equivalent in the intake flow. It also pushes directly and
knows nothing about copyright status, so do not use it for intake songs.

---

## Keeping `main` and `public-main` in sync

The stages above move *songs* one at a time. Nothing in them moves a fix
to a **script**, a layout, or this document - and the two branches share
those files while carrying different content. This section is about that
second kind of change.

### The branches are not forks of each other

Their merge base is `db622afa`, and they have never been reconciled
wholesale. Treat them as two long-lived siblings that happen to share some
files:

|  | `main` | `public-main` |
|---|---|---|
| Remote | `origin` (private) | `public-origin` (public) |
| Songs | 146, incl. 12 copyrighted | 127, all public domain |
| Served by | a private host with no build step | GitHub Pages, `build_type: legacy` |
| Therefore commits | the **built** site, `docs/_site/` | **source**; Pages runs Jekyll |
| Outputs live in | `docs/_site/local-lilypond-outputs/` | `docs/local-lilypond-outputs/` |
| Listing page front matter | written whole by the parser | `cp docs/_data/song-template.md` first, parser appends |

### The differing layouts are required, not drift

This is the row that looks like a mess and is not. **Do not "consolidate"
these.** Each branch's layout is what its host demands:

- The private host serves `main` with no build step of its own, so `main`
  has to commit the pre-built `docs/_site/`. Its `_config.yml` carries
  `keep_files: [local-lilypond-outputs]` precisely so a local Jekyll run
  does not wipe the assets sitting inside `_site`.
- GitHub Pages builds `public-main` itself (`source: main /docs`,
  `build_type: legacy`). Jekyll treats `_site` as *its own output* and
  rebuilds it, so anything committed there is discarded. The assets have
  to live outside it, at `docs/local-lilypond-outputs/`, which Pages copies
  through and serves at `/local-lilypond-outputs/`.

Moving `public-main` to `main`'s layout would 404 every asset on
hymnsinger.com. Moving `main` to `public-main`'s would take the private
site down. There is no shared layout that satisfies both hosts.

What this does cost: a script written against one branch's `docs/` path
runs happily on the other and silently stages nothing. That is a real
hazard - `republish-all.sh` sat broken on `main` for exactly this reason -
so scripts that touch `docs/` should detect the directory rather than
hardcode it.

### Never merge `main` into `public-main`

This is the prohibition the whole protocol exists to enforce, and it was
previously only implied. A wholesale merge in that direction carries every
copyrighted song across in one commit, to a public remote.

There is no flag for it and no reviewed version of it. Songs reach
`public-main` only through Stage 4, from a branch forked from
`public-main` that differs from it by one song.

The other direction, `public-main` into `main`, carries no copyright risk,
but it would drag `docs/local-lilypond-outputs/` (1536 files) onto `main`,
where it is git-ignored and serves nothing. It is also how a
`public-main`-shaped script arrived on `main` and sat broken. Port
individual files instead.

### Moving a shared fix across

Cherry-pick when the file is genuinely identical on both sides:

    git checkout public-main
    git cherry-pick <sha>

When it is not - and for the six scripts below it is not - **port the
change by hand and test it on the target branch**. Copying `main`'s file
wholesale is the tempting mistake: `main`'s
`generate-all-hymn-indexes.py` takes two CLI arguments and writes the
whole listing page, while `public-main`'s takes one and appends to a
template, so the copy would break every page on the public site.

These shared files have diverged and need the by-hand treatment:

    scripts/build-odp-presentation-from-images.sh
    scripts/generate-all-hymn-indexes.py
    scripts/generate-all-hymn-pages.sh
    scripts/generate-all-outputs.sh
    scripts/odp-skeleton
    scripts/publish-song.sh
    scripts/republish-all.sh

Some of those differ for a good reason and should stay different -
`republish-all.sh` prints the push command for the branch it is on, and
the parsers write listing pages differently. Divergence is not itself a
bug to be closed; the question is only whether a given fix is missing.

The intake toolchain is the opposite case. `song-intake.sh`,
`convert-queue.sh`, `from-xml.py`, `from-muse.py`, `lyrics_extractor.py`
and `verify-xml-notes.py` now live on **both** branches and have no
host-specific paths, so they should stay byte-identical. Stage 1 runs
whichever copy the intake branch inherited from `public-main`; if the two
drift, an intake branch runs a different tool than the one you last
edited on `main`. Change them on one branch, then copy across verbatim.

Stage 4 checks this for you. `song-intake.sh publish` compares those six
files across both branches and warns if any differ, because publish is the
moment the gap is easiest to create and hardest to notice - it merges the
intake branch into `public-main` but copies only the song across to `main`,
so a tooling fix made on the intake branch lands on one branch and not the
other. The warning does not block the publish; it tells you a port is
owed. It deliberately ignores the six host-specific scripts above, which
are supposed to differ.

To see the current state of the split:

    for f in $(comm -12 \
        <(git ls-tree --name-only main -- scripts/ | sort) \
        <(git ls-tree --name-only public-main -- scripts/ | sort)); do
      a=$(git rev-parse "main:$f"); b=$(git rev-parse "public-main:$f")
      [ "$a" != "$b" ] && echo "DIFF $f"
    done

Compare blob hashes, not `git diff main public-main -- <path>`, which
reports paths as differing when they are byte-identical.

### Batch changes to `lilypond/lib/` - each one costs a full rebuild

**A one-line edit to a shared `.ily` rebuilds every song on the branch.**
Not because anything is broken - because `generate-all-outputs.sh` decides
"up to date" by hashing each `.ly` *together with the files it
`\include`s*, so that editing a lib still invalidates the songs that use
it. Four lib files are included by essentially every song:

    hymn-common.ily   all-notation-outputs.ily
    header.ily        midi-output.ily

Touch any of them and 149 of `main`'s 152 songs (130 of 130 on
`public-main`) get new fingerprints and re-render. That is ~7.4s per song
for the PDF and 400dpi PNG passes alone, before the ODP build and the
MIDI→MP3, so budget **20-30 minutes per branch**.

The cost is per branch, not per change, and it does not compound: two lib
edits in one republish cost the same as one. So:

- **Collect lib changes and apply them together.** Adding `\SH` on Monday
  and a beam tweak on Tuesday is two full rebuilds; the same two edits in
  one sitting is one.
- **Do the song work first.** A lib change plus a new song is one rebuild
  if the lib commit lands before you republish, two if after.
- **Remember the second branch.** Porting a lib fix across leaves the
  other branch needing its own full republish. Batch that with whatever
  else is pending there rather than paying it immediately - the branches
  do not have to be regenerated at the same time, only before each is
  pushed.

Do not try to dodge this by narrowing the fingerprint to the `.ly` alone.
The script's own comment explains why: it would serve stale output after
a lib change, which is worse than rebuilding too often. The mtime-based
test it replaced is what produced the ~200-file diffs of
identical-but-for-the-date PDFs.

LilyPond's `-ddump-signatures` looks like a way out - it dumps grob
positions and genuinely ignores unused definitions - but it fails both
tests that matter. It missed a real change (`tradStaffZoom` 1 → 1.05
altered the PDFs while every signature file stayed byte-identical,
because signatures do not capture staff magnification), and it costs
2765ms per song against 2472ms to just render the PDF. It is a
regression-testing tool, not a build cache.

### The public branch also drifts from its own remote

`public-main` tracks `public-origin/main`. It has diverged before - the
now-deleted `../hymn-singer` working copy published to that remote
independently, leaving `public-main` 1 ahead and 9 behind. Before
publishing:

    git fetch public-origin
    git log --oneline --left-right public-main...public-origin/main

Merge and push if it has drifted. `../hymn-singer` is gone, so the usual
cause is fixed, but a second clone would recreate it.

### A worked example

`we-gather-together` reached `public-main` in 2026-07 and still had no
page, for a reason that had nothing to do with Stage 5. Its header uses

    poet = \twoLineSmallText \markup { "Text:" ... }

and `public-main`'s parser matched only the non-`\markup` spellings, so
`get_poet_info` raised and `generate-all-hymn-pages.sh` stopped. `main`'s
parser had learned that form; `public-main`'s never did, because no stage
carries a parser fix across. Fixed in `683d740b`.

The lesson is the shape, not the bug: a song can clear every gate in
Stages 1-5 and still be invisible because the *tooling* on the two
branches is not the same.

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

Forking intake from `public-main` serves the same end, though it reads
backwards at first. The branch that a song is built on now contains
*only* public-domain material, so the question at publish time is whether
to merge it - not whether the merge would smuggle something along. The
default is still private: no `--public`, no public merge, and a
copyrighted song's commits never enter `public-main`'s history at all.

---

## Resuming the photo indexing

Four agents indexed `~/Downloads/hymnal_a_worship_book` in batches
(file lists were in `/tmp/hymnal-batches/batch{1..4}.txt`, 81 photos each,
in sorted filename order).

If `.hymnal-index.json` is missing, restore the committed snapshot:

    cp docs/hymnal-index/hymnal-index.json .hymnal-index.json

Then:

    python3 scripts/index-hymnal-photos.py verify        # resolve conflicts
    python3 scripts/index-hymnal-photos.py list --unindexed   # what is left
    python3 scripts/index-hymnal-photos.py plan          # review renames
    python3 scripts/index-hymnal-photos.py apply         # rename in place

`apply` refuses to run while `verify` fails, never overwrites, and is
idempotent, so it is safe to re-run.

**Conflicts are usually bleed-through.** These pages are thin enough that
the next leaf's hymn number shows faintly at the top corner. IMG_3022 was
recorded as 221-222 for that reason when it shows only 221. When two
photos claim one hymn, open both and keep the one where the number sits
beside a title.

The prompt for indexing agents is `docs/agent-prompt-song-intake.md`
(Prompt A).
