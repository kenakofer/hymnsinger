\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/lasst_uns_erfreuen.ly"

%% SONG INFO
title = \titleText "All creatures of the earth and sky"
subtitle = \smallText "See also: All creatures worship God most high"
poet = \smallText "Text: Saint Francis of Assisi, 1225; alt."
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 5
tags = "english theist 4part"
dateAdded = "2021-03-05"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  \l All crea -- tures of the earth and sky, come, kin -- dred, lift your voic -- es high,
  %% CHORUS
  al -- le -- lu -- ia, al -- le -- lu -- ia!
  %% END CHORUS
  \l Bright burn -- ing sun with gold -- en beam, soft shin -- ing moon with sil -- ver gleam,
  %% CHORUS
  O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  %% END CHORUS
}
verseB = \lyricmode {
  Swift rush -- ing wind so wild and strong, white clouds that sail in heav'n a -- long,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  Fair ris -- ing morn in praise re -- joice, high stars of eve -- ning find a voice,
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}
verseC = \lyricmode {
  Cool flow -- ing wa -- ter pure and clear, make mu -- sic for all life to hear,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  Dance, flame of fire, so strong and bright, and bless us with your warmth and light,
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}

all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

extra_verses = \markup {
  \fontsize #-1.5

  \fill-line {
    %\hspace #-25.0 % moves the column off the left margin;
     % can be removed if space on the page is tight
     \vspace #1

     \column {
      \line { \bold "3."
        \column { % LYRICS-START
"Embracing earth, you, day by day,"
"bring forth your blessings on our way,"
%% CHORUS
"alleluia, alleluia!"
%% END CHORUS
"All herbs and fruits that richly grow,"
"let them the glory also show,"
%% CHORUS
"O sing ye, O sing ye, alleluia, alleluia, alleluia!"
%% END CHORUS
        }
      }
    }
    \hspace #0.1 % adds horizontal spacing between columns;
    \column {
      \line { \bold "4."
        \column { % LYRICS-START
"All you of understanding heart,"
"forgiving others, take your part"
%% CHORUS
"alleluia, alleluia!"
%% END CHORUS
"Let all things now the good possess,"
"and search out truth in humbleness"
%% CHORUS
"O sing ye, O sing ye, alleluia, alleluia, alleluia!"
%% END CHORUS
        }
      }
    }
  \hspace #0.1 % gives some extra space on the right margin;
  % can be removed if page space is tight
  }
}

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
