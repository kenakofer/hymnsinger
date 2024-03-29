\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/lacquiparle-melody.ily"

%% SONG INFO
title = \titleText "Wakantanka (Many and Great)"
poet = \smallText "Text: Dakota; Joseph R. Renville, 1846; paraphr. Philip Frazier, 1929, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "dakota english theist 1part"
dateAdded = "2021-03-07"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Wa -- kan -- tan -- ka ta -- ku ni -- ta -- wa tan -- ka -- ya qa o -- ta;
  \l ma -- hpi -- ya kin e -- ya -- hna -- ke ça, ma -- ka kin he du -- o -- wan -- _ ca;
  \l mni -- o -- wan -- ca śbe -- ya wan -- ke cin, he -- na o -- ya -- ki -- hi.
}
verseB = \lyricmode {
  Wo -- eh -- da -- ku ni -- ta -- wa kin he mi -- na -- ġi kin qu wo;
  ma -- hpi -- ya kin i -- wan -- kam ya -- ti, wi -- co -- wa -- śte yu -- ha nan -- _ ka,
  wi -- co -- ni kin he ma -- ya -- qu nun, o -- wi -- han -- ke wa -- nin.
}
verseC = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  Man -- y and great, O God, are your works, mak -- er of earth and sky.
  Your hands have set the heav -- ens with stars; your fin -- gers spread the moun -- tains and plains
  Lo, at your word the wa -- ters were formed; deep seas o -- bey your voice.
}
verseD = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  Grant un -- to us com -- mun -- ion with you, O star -- a -- bid -- ing One.
  Come un -- to us and dwell with _ us; with you are found the gifts of _ life.
  Bless us with life that has no _ end, e -- ter -- nal life with you.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
  \tag #'verseC { \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "1" "" \verseC } }
  \tag #'verseD { \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "2" "" \verseD } }
>>

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"