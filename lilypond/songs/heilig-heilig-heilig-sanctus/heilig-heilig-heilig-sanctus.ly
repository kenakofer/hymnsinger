\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/sanctus-schubert.ily"

%% SONG INFO
title = \titleText "Heilig, Heilig, Heilig (Holy, Holy, Holy)"
poet = \smallText "Text: German; Johann P. Neumann, 1826; trans. Kenan Schaefkofer, 2021"
verseCount = 2
tags = "german english christian 4part"
typesetter = "Kenan Schaefkofer"
dateAdded = "2021-03-08"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  %% CHORUS
  \l Hei -- lig, hei -- lig, hei -- lig, hei -- lig ist der Herr!
  \l Hei -- lig, hei -- lig, hei -- lig, hei -- lig ist nur er!
  %% END CHORUS
  \showVerseNumberAtLineStart "1" #4.5
  \l Er, der nie be -- gon -- nen, or, der im -- mer war,
  \hideVerseNumberAtLineStart
  \l e -- wig ist und wal -- tet, sein wird im -- mer -- dar.
}
verseB = \lyricmode {
  %% CHORUS
  \SB {
    Hei -- lig, hei -- lig, hei -- lig, hei -- lig ist der Herr!
    Hei -- lig, hei -- lig, hei -- lig, hei -- lig ist nur er!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
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
  %% CHORUS
  \SD {
    Ho -- ly, ho -- ly, ho -- ly, ho -- ly is the Lord!
    Ho -- ly, ho -- ly, ho -- ly, ho -- ly God a -- lone!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _
    _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  \showVerseNumberAtLineStart "2" #4.5
  Might -- y, won -- drous, lov -- ing, om -- ni -- pre -- sent God,
  \hideVerseNumberAtLineStart
  ho -- ly, ho -- ly, ho -- ly, ho -- ly is the Lord!
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1-2" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseB } }
  \tag #'verseC { \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "1-2" "" \verseC } }
  \tag #'verseD { \new Lyrics \with \dropLyricsSmall \lyricsto soprano  { \globalLyrics "" "" \verseD } }
>>

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
