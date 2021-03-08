\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/sanctus_schubert.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 2verse musicbyother textbyother"
\header {
  title = \titleText "Heilig, Heilig, Heilig (Holy, Holy, Holy)"
  %subtitle = \smallText "Optional"
  composer = \composer
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: German; Johann P. Neumann, 1826; trans. Kenan Schaefkofer, 2021"
  meter = \meter
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% LYRICS
verseA = \lyricmode {
  %% CHORUS
  Hei -- lig, hei -- lig, hei -- lig, hei -- lig ist der Herr!
  Hei -- lig, hei -- lig, hei -- lig, hei -- lig ist nur er!
  %% END CHORUS
  \showVerseNumberAtLineStart "1" #4.5
  Er, der nie be -- gon -- nen, or, der im -- mer war,
  \hideVerseNumberAtLineStart
  e -- wig ist und wal -- tet, sein wird im -- mer -- dar.
}
verseB = \lyricmode {
  _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _
  \showVerseNumberAtLineStart "2" #4.5
  All -- macht, Wun -- der, Lie -- be, al -- les rings -- um -- her!
  \hideVerseNumberAtLineStart
  Hei -- lig, hei -- lig, hei -- lig, hei -- lig ist der Herr!
}
verseC = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  %% CHORUS
  Ho -- ly, ho -- ly, ho -- ly, ho -- ly is the Lord!
  Ho -- ly, ho -- ly, ho -- ly, ho -- ly God a -- lone!
  %% END CHORUS
  \showVerseNumberAtLineStart "1" #4.5
  God, with -- out be -- gin -- ning, God, who al -- ways was,
  \hideVerseNumberAtLineStart
  ev -- er be ex -- alt -- ed, reign for -- ev -- er -- more.

}
verseD = \lyricmode {
  \override Lyrics.LyricText.font-shape = #'italic
  _ _ _ _ _ _ _ _ _ _ _
  _ _ _ _ _ _ _ _ _ _ _
  \showVerseNumberAtLineStart "2" #4.5
  Might -- y, won -- drous, lov -- ing, om -- ni -- pre -- sent God,
  \hideVerseNumberAtLineStart
  ho -- ly, ho -- ly, ho -- ly, ho -- ly is the Lord!
}
verseE = \lyricmode { }
verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1-2" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseB }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "1-2" "" \verseC }
  \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "" "" \verseD }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book { \prescore_text \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \prescore_text \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \prescore_text \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
    \new Staff \with { midiMaximumVolume = #0.7  } \alto
    \new Staff \with { midiMaximumVolume = #0.8  } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 120
  }
}
