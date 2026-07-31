#!/usr/bin/env python3
"""Find ties that will eat a syllable in every verse.

A tie fuses two same-pitch notes into one sustained note, so lyrics place
exactly one syllable across the pair - in *every* verse. When the source
also puts <lyric> text on the tie-stop note, the two encodings contradict
each other and the tie wins silently. The verses that meant to sing a new
syllable there come out a syllable short.

What the hymnal prints in that spot is a dashed curve: "applies to some
verses only." The fix is a phrasing slur, which lyrics ignore, plus a _
skip in the verse that holds:

    fs'4 fs'8~ fs'8 g'4        wrong - one syllable in all verses
    fs'4 fs'8\\( fs'8\\) g'4     right - the holding verse takes the _

This reads the source MusicXML, not the .ly, so it works on unconverted
songs - and it keeps firing after the .ly is fixed. It cannot confirm a
fix landed; check the engraving.

verify-xml-notes.py reports 0.0% straight through this, because the notes
are right. Only the singing is wrong.

Usage:
    find-tied-lyrics.py <file.xml>...     # named songs
    find-tied-lyrics.py                   # whole unconverted queue
"""

import sys
import glob
import os
import xml.etree.ElementTree as ET

QUEUE_XML = ".convert-queue/xml"
SONGS_DIR = "lilypond/songs"


def note_is_tie_stop(note):
    """True if this note ends a tie.

    <tie> is the sounded tie and <tied> (under <notations>) is the printed
    one. Sources are inconsistent about which they emit, so accept either.
    """
    for tie in note.findall("tie"):
        if tie.get("type") == "stop":
            return True
    for tied in note.iter("tied"):
        if tied.get("type") == "stop":
            return True
    return False


def lyric_texts(note):
    """Syllables on this note, keyed by verse number."""
    out = {}
    for lyric in note.findall("lyric"):
        text = lyric.find("text")
        if text is not None and (text.text or "").strip():
            # 'number' is the verse; absent means a single-verse song.
            out[lyric.get("number") or "1"] = text.text.strip()
    return out


def scan(path):
    """Report tie-stop notes that still carry lyric text.

    Returns a list of (measure, verse->syllable) - one entry per offending
    note.
    """
    try:
        root = ET.parse(path).getroot()
    except ET.ParseError as exc:
        print(f"  ! {os.path.basename(path)}: unparseable ({exc})")
        return []

    hits = []
    for measure in root.iter("measure"):
        for note in measure.findall("note"):
            if not note_is_tie_stop(note):
                continue
            texts = lyric_texts(note)
            if texts:
                hits.append((measure.get("number"), texts))
    return hits


def song_name(path):
    return os.path.splitext(os.path.basename(path))[0]


def main(argv):
    paths = argv[1:]
    scanning_queue = not paths
    if scanning_queue:
        paths = sorted(glob.glob(os.path.join(QUEUE_XML, "*.xml")))
        if not paths:
            print(f"no XML under {QUEUE_XML}/ - run this from the repo root")
            return 2

    total_songs = 0
    total_hits = 0
    for path in paths:
        name = song_name(path)
        # In queue-wide mode, an already-converted song is not the target
        # audience: the .ly may well be fixed, and this script reads the XML,
        # so it would report a contradiction that no longer exists.
        if scanning_queue and os.path.isdir(os.path.join(SONGS_DIR, name)):
            continue

        hits = scan(path)
        total_songs += 1
        if not hits:
            continue

        total_hits += len(hits)
        print(f"\n{name}  ({len(hits)} tie{'s' if len(hits) != 1 else ''})")
        for measure, texts in hits:
            verses = ", ".join(
                f"v{num}={text!r}" for num, text in sorted(texts.items())
            )
            print(f"  m{measure}: tie-stop note carries {verses}")

    print()
    if total_hits:
        print(
            f"{total_hits} tie(s) across {total_songs} song(s) scanned - "
            "each will cost every verse a syllable."
        )
        print("Fix: two notes under a phrasing slur \\( \\), _ in the holding verse.")
    else:
        print(f"no tie/lyric contradictions in {total_songs} song(s) scanned")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
