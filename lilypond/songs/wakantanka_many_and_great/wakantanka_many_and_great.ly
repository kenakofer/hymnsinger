\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/lacquiparle_melody.ly"


%% See docs/all_tags.txt for the full list available
tags = "theist 1part acapella 2verse musicbyother textbyother"
\header {
  title = \titleText "Wakantanka (Many and Great)"
  %subtitle = \smallText "Optional"
  composer = \composer
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: Dakota; Joseph R. Renville, 1846; paraphr. Philip Frazier, 1929, alt."
  meter = \meter
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"

%% LYRICS
verseA = \lyricmode {
  Wa -- kan -- tan -- ka ta -- ku ni -- ta -- wa tan -- ka -- ya qa o -- ta;
  ma -- hpi -- ya kin e -- ya -- hna -- ke ça, ma -- ka kin he du -- o -- wan -- _ ca;
  mni -- o -- wan -- ca śbe -- ya wan -- ke cin, he -- na o -- ya -- ki -- hi.
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
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "1" "" \verseC }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "2" "" \verseD }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book { \prescore_text \bookOutputSuffix "trad" \score { \fillTradScoreSingleStaff \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \prescore_text \bookOutputSuffix "shapenote" \score { \fillTradScoreSingleStaff {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \prescore_text \bookOutputSuffix "clairnote" \score { \fillClairScoreSingleStaff \soprano \alto \tenor \bass } }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 165
  }
}
