\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: Edwin Hatch, 1878"
meter = \smallText "TRENTHAM SM"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Breath on me, breath of God"
poet = \smallText "Text: Robert Jackson, 1888"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-01-09"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { a4 a a | bf2 f4 | a2. | c4 bf a | g2 a4 | g2. } \break
  \relative g' { a4 bf d | c2 a4 | a2 g4 | bf2 g4 | f4( e) f | a2 g4 | f2. | } \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { f4 f f | 2 4 | 2. | 4 4 4 | 2 4 | e2. }
  \relative e' { f4 4 e | f2 8 e | d2 4 | 2 4 | c2 4 | f2 e4 | f2. | }
}
tenor = {
  \globalParts
  \relative a { c4 f e | d2 df4 | c2. | 4 4 4 | d2 4 | e2. | }
  \relative a { c4 d bf | a2 c4 | c2 bf4 | 2 4 | a( g) a | c2 bf4 | a2. }
}
bass = {
  \globalParts
  \relative d { f4 4 4 | 2 4 | 2. | a4 g f | bf,2 b4 | c2. | }
  \relative d { f4 4 g | a2 f4 | bf,2 4 | g2 bf4 | c2 4 | 2 4 | f2. | }
}


%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l Breathe on me, breath of God. Fill me with life a -- new
  \l that I may love what thou dost love, and do what thou wouldst do.
}
verseB = \tag #'verseB \lyricmode {
  Breath on me, breath of God, un-til my heart is pure,
  un -- til with thee I will one will, to do and to en -- dure.
}
verseC = \tag #'verseC \lyricmode {
  Breathe on me, breath of God, till I am whol -- ly thine,
  till all this earth -- ly part of me glows with thy fire di -- vine.
}
verseD = \tag #'verseD \lyricmode {
  Breath on me, breath of God, so shall I nev -- er die,
  but live with thee the per -- fect life of thine e -- ter -- ni -- ty.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_4verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
