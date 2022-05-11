\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/lasst-uns-erfreuen.ily"

%% SONG INFO
title = \titleText "All creatures worship God most high"
subtitle = \smallText "Alt. title: All creatures of our God and King"
poet = \twoLineSmallText "Text: Saint Francis of Assisi, 1225;" "tr. William H. Draper, 1926; alt."
typesetter = "Kenan Schaefkofer"
verseCount = 7
tags = "english christian 4part"
postscore_text = \postscoreText "*Or, ''All creatures of our God and King, / lift up your voice and with us sing''"
dateAdded = "2021-03-05"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l "*All" crea -- tures, wor -- ship God most high, lift up your voice in earth and sky,
  %% CHORUS
  \hideVerseNumberAtLineStart
  al -- le -- lu -- ia, al -- le -- lu -- ia!
  \showVerseNumberAtLineStart "1" #2.5
  %% END CHORUS
  \l Thou burn -- ing sun with gold -- en beam, thou sil -- ver moon with soft -- er gleam,
  %% CHORUS
  \hideVerseNumberAtLineStart
  O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  %% END CHORUS
}
verseB = \lyricmode {
  Thou rush -- ing wind that art so strong, ye clouds that sail in heav'n a -- long,
  %% CHORUS
  \SB {
    al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  Thou ris -- ing morn in praise re -- joice, ye lights of eve -- ning find a voice,
  %% CHORUS
  \SB {
    O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
}
verseC = \lyricmode {
  Thou flow -- ing wa -- ter, pure and clear, make mu -- sic for thy God to hear,
  %% CHORUS
  \SC {
    al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  Thou fire so mas -- ter -- ful and bright, that giv -- est all both warmth and light,
  %% CHORUS
  \SC {
    O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
}
verseD = \lyricmode {
  Dear moth -- er earth, who day by day, un -- fold -- est bless -- ings on our way,
  %% CHORUS
  \SD {
    al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  The flow'rs and fruits that in thee grow, let them God's glo -- ry al -- so show,
  %% CHORUS
  \SD {
    O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
}
verseE = \lyricmode {
  And ev -- 'ry -- one, with ten -- der heart, for -- giv -- ing oth -- ers, take your part,
  %% CHORUS
  \SE {
    al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  Ye who long pain and sor -- row bear, sing praise and cast on God your care,
  %% CHORUS
  \SE {
    O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
}
verseF = \lyricmode {
  And thou, most kind and gen -- tle death, wait -- ing to hush our fi -- nal breath,
  %% CHORUS
  \SF {
    al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  Thou lead -- est home the child of God, as Christ be -- fore that way hath trod,
  %% CHORUS
  \SF {
    O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
}
verseG = \lyricmode {
  Let all things their Cre -- a -- tor bless, and wor -- ship God in hum -- ble -- ness,
  %% CHORUS
  \SG {
    al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  To God all thanks and praise be -- long! Join in the ev -- er -- last -- ing song:
  %% CHORUS
  \SG {
    O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  } \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/7verse.ily"

%% All sheet music outputs
clairStaffZoom = #.9
tradStaffZoom = #.98
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-7verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
