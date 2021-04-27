\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% I have obtained permission from Leslie Fish and her publisher to use her
%% tune.  I'm still waiting to hear back from the National Trust in the UK
%% regarding the US copyright on Hymn of Breaking Strain, but I will proceed
%% in spite of their silence.  Worst case scenario, I'll sit on this until
%% 2030 when it will be PD

%% Exclude from the main listing and Google while I'm getting it ready
exclude_from_index = "true"

%% TUNE INFO
composer = \smallText "Music: Leslie Fish, 1983"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "BREAKING STRAIN 76.76.76.76.6"
hymnKey = \key e \minor
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Hymn of Breaking Strain"
subtitle = \markup{
        \override #'(baseline-skip . 2)
        \fontsize #-2
        \italic
        \medium
        \center-column {
          "He went over it in his head, plate by plate, span by span, brick by brick, pier by pier,"
          "remembering, comparing, estimating, and recalculating, lest there should be any mistake;"
          "and through the long hours and through the flights of formulae that danced"
          "and wheeled before him, a cold fear would come to pinch his heart..."
          " "
        }
      }
poet = \smallText "Text: Rudyard Kipling, 1935, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english secular 4part"
dateAdded = "2021-04-26"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4
    r8 e8 | e8 4. 4 fs | g8 e4. r4 r8 fs8 | e4 fs8 e4 fs4 g8~ | 2. \bar "" \break
    r8 e8 | e4. 8 4 fs | g8 e4. r4 r8 fs8 | e4 fs8 e4 fs4 g8~ | 2. \bar "" \break
    r8 a8 | b4 b4 a4 g | b8 e,4. r4 r8 g8 | g4 g a a | b2. \bar "" \break
    r8 b8 | b8( e,8) e4 e fs | g8 e4. r4 r8 fs8 | g4. g8 fs4 d8 e8~ | 4 r4 \bar "" \break
    r2 | e2~ 4. e8 | fs4 4 g fs8 e~ | e1 | \partial 2. r2 r4 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    r8 b8 | b8 4. 4 4 | b8 4. r4 r8 d8 | e4 d8 e4 d4 e8~ | 2.
    r8 b8 | b4. 8 4 4 | b8 4. r4 r8 d8 | e4 d8 e4 d4 c8~ | 2.
    r8 fs8 | g4 g4 fs4 e | e8 e4. r4 r8 d8 | e4 c d4. fs8 | e2.
    r8 b8 | b4 b b b | b8 4. r4 r8 d8 | e4. e8 d4 d8 b8~ | 4 r4
    r2 | c2~ 4. c8 | d4 8( a) a4 8 b~ | 1
  }
}
tenor = {
  \globalParts
  \relative a {
    r8 b8 | b8 4. g4 b | b8 b4. r4 r8 b8 | b4 b8 g4 fs4 g8~ | 2.
    r8 b8 | b4. 8 g4 b | b8 b4. r4 r8 b8 | b4 b8 g4 fs4 g8~ | 2.
    r8 a8 | g4 b4 d4 b | b8 b4. r4 r8 g8 | c4. b8 a4 fs | g2.
    r8 b8 | b4 g g b | b8 b4. r4 r8 b8 | g4. b8 a4 a8 g~ | 4 r4
    r2 | g2~ 4. g8 | a4 4 a4 a8 b~ | 1 | r2 r4
  }
}
bass = {
  \globalParts
  \relative d {
    r8 e8 | e8 4. 4 4 | 8 4. r4 r8 b8 | b4 8 e4 d4 c8~ | 2.
    r8 b8 | e4. 8 4 4 | 8 4. r4 r8 b8 | b4 8 e4 d4 e8~ | 2.
    r8 fs8 | e4 e4 d4 e4 | e8 e4. r4 r8 b8 | c4 e d c | b2.
    r8 b8 | e4 e4 4 4 | 8 4. r4 r8 b8 | c4. 8 d4 d8 e8~ | 4 r4
    e4( d c2~ 4.) c8 | a4 4 4 8 e'8~ | 1 | r2
  }
}
songChords = \chords {
  \globalChordSymbols
  e4:m | 1 | 1 | 2. d4 | c2.
  e4:m | 1 | 1 | 2. d4 | c2.
  e4:m | 1 | 1 | c2 d2 | e2.:m
  e4:m | 1 | 1 | c2 d2 | e2.:m
  d4 | c1 | d/a | e:m
}

%% LYRICS
verseA = \lyricmode {
  \l The care -- ful text -- books mea -- sure
  (Let all who build be -- ware!)
  \l the load, the shock, the pres -- sure
  ma -- ter -- i -- al can bear.
  \l So when a buck -- led gir -- der
  lets down a steel cas -- cade,
  \l the blame for loss, or mur -- der
  \hideVerseNumberAtLineStart
  is on the ma -- ker laid.
  \SA { Oh __ } \SO { _ }
  \l the ma -- ker, not the made!
}
verseB = \lyricmode {
  But in our dai -- ly deal -- ing
  with stone and steel, we find
  the gods have no such feel -- ing
  of guilt for hu -- man -- kind.
  To no set gauge they make us,
  for no laid course pre -- pare,
  and pres -- ent -- ly o'er -- take us
  \hideVerseNumberAtLineStart
  with loads we can -- not bear:
  Oh __ too mer -- ci -- less to bear.
}
verseC = \lyricmode {
  The pru -- dent text -- books give it
  in ta -- bles at the end:
  the stress that shears a riv -- et,
  or makes a tie -- bar bend,
  what traf -- fic wrecks mac -- a -- dam,
  what con -- crete should en -- dure.
  But we, of Eve and A -- dam
  \hideVerseNumberAtLineStart
  have no such lit' -- ra -- ture,
  \SC { Oh __ } \SO { _ }
  to warn us or make sure!
}
verseD = \lyricmode {
  We on -- ly of Cre -- a -- tion
  (Oh, luck -- ier bridge and rail)
  a -- bide the twin dam -- na -- tion:
  To fail and know we fail.
  Yet we— by which sole to -- ken
  we know we once were gods—
  take shame in be -- ing bro -- ken,
  \hideVerseNumberAtLineStart
  how -- ev -- er great the odds.
  Oh __ the bur -- den of the Odds.
}
verseE = \lyricmode {
  Oh, veil -- ed, se -- cret Pow -- er,
  whose paths we seek in vain,
  be with us in our hour __ _
  of ov -- er -- throw and pain;
  that we— by which sure to -- ken
  we know Thy ways are true—
  be -- cause of be -- ing bro -- ken,
  \hideVerseNumberAtLineStart
  may rise and build a -- new.
  \SE { Oh __ } \SO { _ }
  stand up and build a -- new.
}

all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \new NullVoice = "bass" {\removeWithTag #'midionly \bass}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "1" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "2" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "3" \verseC } }
  \tag #'verseD { \new Lyrics  \lyricsto bass  { \globalLyrics "4" "4" \verseD } }
  \tag #'verseE { \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "5" \verseE } }
>>

%% MIDI output
\include "../../lib/midi-output.ily"
%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-5verse.ily"