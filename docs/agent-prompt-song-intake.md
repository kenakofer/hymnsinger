---
---

# Example agent prompts

Two prompts: a one-time pass to index the hymnal photos, then the
per-song metadata prompt that is the heart of
`song-intake-protocol.md` stage 2.

---

## Prompt A — index the photos (run once)

The photos in `~/Downloads/hymnal_a_worship_book` are named by timestamp
(`IMG_20190209_110245.jpg`), so finding the page for a given hymn means
opening files until one matches. This pass renames them to
`h0332-0333__IMG_20190209_110245.jpg`, after which every later lookup is a
single command.

There are 325 photos, each a two-page spread showing about two hymns.
Batch it — this is boring, mechanical work.

```
The JPGs in ~/Downloads/hymnal_a_worship_book are photos of Hymnal: A
Worship Book, taken in page order. Each is a two-page spread. I want them
renamed by the hymn numbers they contain.

For each photo, read the hymn number(s) printed in the top outer corner of
each page — the large numeral beside the title, e.g. "332 Blessed
assurance" on the left page and "Christ, who is in the form of God 333" on
the right. Then record it:

    scripts/index-hymnal-photos.py record <filename> <first> [last]

Use one number if the spread shows only one hymn (some pages are worship
resources, indexes, or front matter — skip those entirely rather than
inventing a number for them).

Work in batches of about 20 photos in filename order, which is page order.
After each batch run:

    scripts/index-hymnal-photos.py verify

It flags overlapping claims and numbers that go backwards. Both usually
mean a misread digit, so fix them as you go rather than at the end.

Rules:
- Read the number off the page. Do not infer it from position in the
  sequence — that is exactly the error verify cannot catch, because an
  interpolated guess looks perfectly consistent.
- If a number is unreadable, skip the photo and tell me which ones.
- Do not run `apply`. I will review the plan and do the renames.

When done, run `scripts/index-hymnal-photos.py plan` and show me the
summary plus any photos you skipped.
```

Then you run:

    scripts/index-hymnal-photos.py plan     # review
    scripts/index-hymnal-photos.py apply    # rename (verify must pass first)

`apply` refuses to run if `verify` fails, never overwrites, and is
idempotent. The original filename is kept inside the new one, so the
capture order stays recoverable and the rename is reversible.

---

## Prompt B — transcribe one song's metadata

Fill in the bracketed values. You have already run
`scripts/song-intake.sh start <song>`.

Find the photo with:

    scripts/index-hymnal-photos.py find 332

```
I'm converting hymns from a physical hymnal into LilyPond. Your job is
stage 2 of docs/song-intake-protocol.md: read the hymnal photo and record
that song's metadata. Read the protocol first.

Song:   <song-name>
File:   lilypond/songs/<song-name>/<song-name>.ly
Photo:  <path from index-hymnal-photos.py find>
Hymnal: Hymnal: A Worship Book (1992), hymn #<n>

Each photo is a two-page spread with two hymns. Make sure you are reading
the one numbered <n> — mixing up the halves is the easiest mistake here,
and it produces attributions that look completely plausible.

The notes and lyrics are already converted and committed. The commit
script rejects a diff that changes the music, so the metadata commit is
header-only.

If the photo shows the converter got the song's STRUCTURE wrong - most
often verse count, when a verse spans two staff systems as
call-and-response - that is fixable, but as a SEPARATE commit. Read the
appendix table in docs/how-to-new-song.md first; it lists a worked
example for each special case, and the protocol's "Structural fixes"
section maps converter mistakes onto those examples. Fix what the page
settles; leave suspicious notes to my audio pass.

## What to fill in

Edit these fields in the .ly, matching the existing corpus style:

  composer = \smallText "Music: William H. Monk, 1861"
  poet     = \smallText "Text: Henry F. Lyte, 1847"
  meter    = \smallText "EVENTIDE 10 10.10 10"

Style notes:
- composer/poet always start with "Music: " / "Text: ".
- meter is TUNE NAME in caps then the metre, both parts, because the page
  generator needs them: "BLESSED ASSURANCE 9 10. 99 with refrain",
  "SONG 34 LM", "87.87 D", "CM". The hymnal prints this in small caps
  under the title. If it gives a tune name but no metre, say so rather
  than inventing one.
- Book titles and second attributions follow existing songs:
    \smallText \markup { "Music: Louis Bourgeois," \italic "Genevan Psalter," "1551" }
    \twoLineSmallText "Text: Saint Francis of Assisi, 1225;" "tr. William H. Draper, 1926; alt."
- A copyright notice goes in verbatim:
    \header { copyright = "© 1985 David T. Koyzis" }
- tags is a space-separated string. The vocabulary in use is:
    languages: english german spanish latin french greek chinese swahili
               dakota ojibwe
    belief:    christian theist secular
    voices:    1part 3part 4part 5part accompanied
    season:    christmas easter winter spring summer autumn
    occasion:  morning evening death nationalist
  Add only tags you can justify from the page.

## Rules

1. Transcribe, don't recall. Every value must be visible in the photo. If
   you know this tune from elsewhere, that goes in the commit message
   under Uncertain:, never in a field.
2. Null over guess. If something isn't legible or isn't printed, leave the
   field alone and say so. A blank costs me a minute; a plausible wrong
   value can survive for years. "Not printed" is a good answer.
3. Quote copyright notices verbatim — symbol, all years, holder, and any
   "admin." clause.
4. Metadata only. Nothing below the header.

## Copyright determination

Pick one status, in this order:

- Any copyright notice on the page → `copyrighted`, or `mixed` if it
  covers only part. This is common: hymn 333 in this hymnal prints
  "Copyright ©1985 David T. Koyzis" for the text while the music is
  Orlando Gibbons, 1623. That is `mixed`, not `copyrighted` and
  definitely not `public-domain`.
- Otherwise judge by dates: text and music BOTH published before 1930 is
  a reliable US public-domain signal → `public-domain`.
- A modern translation, arrangement, or harmonisation carries a fresh
  copyright of its own.
- The hymnal's own collection copyright does not by itself make an
  individual old hymn copyrighted.
- If none of that settles it → `unknown`.

`copyrighted`, `unknown` and `mixed` all route to the private repo, which
is safe. Only `public-domain` can reach the public one, so it needs
positive dated evidence. "No notice visible" is NOT evidence of public
domain — the commit script rejects that reasoning. There is no cost to
`unknown` and a real cost to a wrong `public-domain`.

## Committing

Write the commit message to a file, then:

    MSG_FILE=<path> scripts/song-intake.sh transcribe <song-name>

    Add metadata for <song> from Hymnal: A Worship Book, #<n>

    Copyright-Status: public-domain
    Copyright-Notice: none visible
    Copyright-Covers: text and music
    Copyright-Reasoning: Text Fanny J. Crosby, Gems of Praise, 1873;
      music Phoebe Palmer Knapp, same collection, 1873. Both well before
      the 1930 cutoff.

    Confidence: composer=high, poet=high, meter=low
    Uncertain: the metre reads "9 10. 99 with refrain" but the period
      placement is hard to make out at this resolution.
    Source: h0332-0333__IMG_20190209_110245.jpg

Continuation lines must be indented to be read as part of a field.

## What I want back

Which fields you filled, which you left blank and why, the copyright
status with its reasoning, and anything you want me to look at closely.
I'm going to compare the score against the photo and listen to the MIDI,
so flag whatever you're unsure of — that's what directs my attention.
```

---

## Notes on using these

**One song per conversation for prompt B.** The photo is the context;
mixing songs invites attributions from one page landing on another.

**Give the agent the protocol file, not just the prompt.** The prompt is
the task; `song-intake-protocol.md` is the reasoning behind the rules.

**Expect blanks.** An agent returning two nulls and an `unknown` on a hard
page is working correctly. One that never leaves a field blank is a
warning sign, not a good result.

**The scripts are the backstop.** `transcribe` rejects a bad
`Copyright-Status`, public-domain reasoning without dates, reasoning that
argues from a missing notice, and any diff touching notes or lyrics.
`index-hymnal-photos.py verify` catches overlapping or backwards hymn
numbers. The prompts ask for good behaviour; the scripts enforce it.

**The agent cannot publish.** `transcribe` only commits to the intake
branch. Merging to `main`, and to `public-main`, is yours alone.
