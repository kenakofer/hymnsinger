#!/usr/bin/env python3
import xml.etree.ElementTree as ET
import re
import sys

class Syllable:

    def __init__(self, verse, pos, text):
        self.pos = pos
        self.verse = verse
        self.text = text

tree = ET.parse(sys.argv[1])
root = tree.getroot()

lyrics=[]

BEG='begin'
MID='middle'
END='end'
ONE='single'

lyric_index=-1
for n in root.iter('note'):
    lyric_tags = n.findall('lyric')
    if lyric_tags:
        lyric_index+=1
        for t in lyric_tags:
            # <syllabic> is optional in MusicXML and <text> can be absent on
            # extend-only lyrics; treat both as a standalone syllable.
            syllabic = t.find('syllabic')
            text_elem = t.find('text')
            if text_elem is None or text_elem.text is None:
                continue
            try:
                number = int(t.get('number') or 1)
            except ValueError:
                number = 1
            s = Syllable(number,
                         syllabic.text if syllabic is not None else ONE,
                         text_elem.text)
            while len(lyrics) < s.verse:
                lyrics.append([None]*(lyric_index+1))
            for verse in lyrics:
                while len(verse)<lyric_index+1:
                    verse.append(None)
            lyrics[s.verse-1][lyric_index]=s

def warn_syllabic_mismatch(lyrics):
    """Flag notes where verses disagree on whether a syllable lands.

    When one verse sings a note and another treats it as a held/melisma
    note, the extractor sees a syllable in one verse's column and a gap
    (None) in another's at the same note-index. That divergence is the
    signature of the dotted-slur / phrasing-slur case: the sung verse
    needs the note, the holding verse needs a ``_`` skip. The converter
    cannot tell which is intended, so it surfaces the spot for review
    rather than guessing.

    Only interior gaps count. A verse that is simply shorter trails off in
    trailing Nones, which is not a mismatch, so each verse is considered
    only across the span from its first to its last real syllable.
    """
    if len(lyrics) < 2:
        return
    width = max((len(v) for v in lyrics), default=0)

    def sung(verse, col):
        return col < len(verse) and verse[col] is not None

    # Interior span of each verse: [first sung column, last sung column].
    spans = {}
    for vi, verse in enumerate(lyrics):
        cols = [i for i, s in enumerate(verse) if s is not None]
        if cols:
            spans[vi] = (cols[0], cols[-1])
    for col in range(width):
        sings, holds = [], []
        for vi, verse in enumerate(lyrics):
            if vi not in spans:
                continue
            lo, hi = spans[vi]
            if not (lo <= col <= hi):
                continue          # outside this verse's sung range
            if sung(verse, col):
                sings.append(vi + 1)
            else:
                # A melisma is a LONE gap: the verse sings the notes on
                # either side of it. A run of gaps is a shared refrain or
                # a length mismatch, not a per-verse melisma, so skip it.
                if sung(verse, col - 1) and sung(verse, col + 1):
                    holds.append(vi + 1)
        if sings and holds:
            words = []
            for vi in sings:
                s = lyrics[vi - 1][col]
                words.append('v%d=%r' % (vi, s.text.strip()))
            for vi in holds:
                words.append('v%d=(hold)' % vi)
            sys.stderr.write(
                'lyric note %d: verses disagree on a syllable here '
                '(%s). One verse sings it, another holds through it -- '
                'likely a melisma needing a phrasing slur X\\( X\\) and a '
                '_ skip in the holding verse; see how-to-new-song.md '
                '"Dotted slur (lyrics ignore)".\n'
                % (col + 1, ', '.join(words)))


warn_syllabic_mismatch(lyrics)

#Print the verses, in order
for verse, letter in zip(lyrics, ['A', 'B', 'C', 'D', 'E', 'F', 'G']):
    sys.stdout.write('verse' + letter + ' = \\lyricmode {\n')
    if letter == 'A':
        sys.stdout.write('\\l ')
    first = True
    for s in verse:
        if s:
            text = s.text
            # MuseScore packs the verse label into the first syllable
            # ("3   Be", ",6   Will"); strip it so \lyricmode does not read
            # the bare number as a duration. Labels appear as plain numbers,
            # comma-joined lists ("2,6"), and occasionally with a trailing
            # dot or paren.
            text = re.sub(r'^[\s,]*\d+(\s*[,&]\s*\d+)*\s*[.)]?\s+', '', text)
            text = re.sub(r'^[\s,]*\d+(\s*[,&]\s*\d+)*\s*[.)]?\s*$', '', text)
            text = text.strip()
            text = text.replace('"', "''")
            if not text:
                continue
            # \lyricmode is far more permissive than a letters-only rule
            # suggests: ordinary punctuation (. , ; : ! ? * ' ’ ( ) [ ] - =
            # % &) all set unquoted, and quoting it only makes the source
            # noisier ("cem." instead of cem.). Quote only what LilyPond
            # would actually reinterpret, verified by rendering each case:
            #
            #   { }   block delimiters - silently dropped ({y} sets as "y")
            #   # $   start Scheme     - truncate the word (a#b sets as "a")
            #   _     lyric space      - f_g sets as "f g"
            #   ~     lyric tie        - h~i sets as a ligature
            #   \     escape           - parse error
            #   "     already handled above (turned into '')
            #
            # Some characters are safe inside a word but not at the front,
            # where LilyPond reads them as syntax rather than text: a digit
            # is a duration ("3c"), "%" opens a comment, and ". * =" are
            # each a parse error. Note "cem,*" is fine because it starts
            # with a letter - only the leading position matters.
            #
            # Internal whitespace has to stay quoted too: a two-word
            # syllable like "If this" splits across two notes unquoted,
            # shifting every syllable after it.
            if re.search(r'[{}#$_~\\\s]', text) or re.match(r'[\d.*=%]', text):
                text = '"' + text + '"'
            first = False
            sys.stdout.write(text)
            if s.pos == END or s.pos == ONE:
                sys.stdout.write(' ')
            else:
                sys.stdout.write(' -- ')
        else:
            #print(None)
            pass
    sys.stdout.write('\n}\n')
