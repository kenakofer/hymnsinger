\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Leslie Fish, 1983"
arranger = \smallText "arr. Kenan Schaefkofer, 2021"
meter = \smallText "BREAKING STRAIN"
hymnKey = \key e \minor
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "The Hymn of Breaking Strain"
%subtitle = \smallText "Optional"
poet = \smallText "Text: Rudyard Kipling, 1935"
typesetter = "Kenan Schaefkofer"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"
verseCount = 4
tags = "english secular 4part"
dateAdded = "2021-04-26"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 2
    e2 | e4 e e fs | g8 e4. r4 r8 fs8 | e4 fs8 e8~ 4 fs8 g8~ | 2 r4 \bar "" \break
    r8 e8 | e4 e e fs | g8 e4. r4 r8 fs8 | e4 fs8 e8~ 4 fs8 g8~ | 2 r4 \bar "" \break
    r8 a8 | b4 b a g | b8 e,4. r4 r8 g8 | g4 g a a | b2 r4 \bar "" \break
    r8 b8 | b4 e, e fs | g8 e4. r4 r8 fs8 | g4. g8 fs4 d8 e8~ | 2 \bar "" \break
    r2 | e2~ 4. e8 | fs4 4 g fs8 e~ | e1 | \partial 2 r2 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
       b2 | b4 b b b | b8 4. r4 r8 d8 | e4 d8[ e8]~ 4 d8 c8~ | 2 r4
    r8 b8 | b4 b b b | b8 4. r4 r8 d8 | e4 d8[ e8]~ 4 d8 c8~ | 2 r4
    r8 fs8 | g4 g4 fs e | e8 e4. r4 r8 d8 | e4 c d4. fs8 | e2 r4
    r8 b8 | b4 b b b | b8 4. r4 r8 d8 | e4. e8 d4 d8 b8~ | 2
    r2 | c2~ 4. c8 | d4 8( a) a4 8 b~ | 1
  }
}
tenor = {
  \globalParts
  \relative a {
       b2 | b4 b g b | b8 b4. r4 r8 b8 | b4 b8 g8~ 4 fs8 g~ | 2 r4
    r8 b8 | b4 b g b | b8 b4. r4 r8 b8 | b4 b8 g8~ 4 fs8 g~ | 2 r4
    r8 a8 | g4 b d4 b | b8 b4. r4 r8 g8 | c4. b8 a4 a | g2 r4
    r8 b8 | b4 g g b | b8 b4. r4 r8 b8 | g4. b8 a4 a8 g~ | 2
    r2 | g2~ 4. g8 | a4 4 a4 a8 g~ | 1
  }
}
bass = {
  \globalParts
  \relative d {
       e2 | e4 4 4 4 | 8 4. r4 r8 b8 | b4 8 e8~ 4 d8 c8~ | 2 r4
    r8 b8 | e4 4 4 4 | 8 4. r4 r8 b8 | b4 8 e8~ 4 d8 e8~ | 2 r4
    r8 fs8 | e4 e4 d4 e4 | e8 e4. r4 r8 b8 | c4 e d c | b2 r4
    r8 b8 | e4 e4 4 4 | 8 4. r4 r8 b8 | c4. 8 d4 d8 e8~ | 2
    e4( d c2~ 4.) c8 | a4 4 d4 d8 e8~ | 1 | r2
  }
}
songChords = \chords {
  \globalChordSymbols
  e2:m | 1 | 1 | 2. d4 | c2.
  e4:m | 1 | 1 | 2. d4 | c2.
  e4:m | 1 | 1 | c2 d2 | e2.:m
  e4:m | 1 | 1 | c2 d2 | e2.:m
  d4 | c1 | d | e:m
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
  Oh, veil'd and se -- cret Pow -- er,
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