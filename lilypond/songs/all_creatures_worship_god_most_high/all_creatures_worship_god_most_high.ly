\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/lasst_uns_erfreuen.ly"

%% SONG INFO
title = \titleText "All creatures worship God most high"
subtitle = \smallText "Alt. title: All creatures of our God and King"
poet = \twoLineSmallText "Text: Saint Francis of Assisi, 1225;" "Translated William H. Draper, 1926; alt."
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 7
tags = "christian 4part musicbyother textbyother"
postscore_text = \postscoreText "*Or, ''All creatures of our God and King, / lift up your voice and with us sing''"
dateAdded = "2021-03-05"
\include "../../lib/header.ly"

%% LYRICS
verseA = \lyricmode {
  "*All" crea -- tures, wor -- ship God most high, lift up your voice in earth and sky,
  %% CHORUS
  al -- le -- lu -- ia, al -- le -- lu -- ia!
  %% END CHORUS
  Thou burn -- ing sun with gold -- en beam, thou sil -- ver moon with soft -- er gleam,
  %% CHORUS
  O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  %% END CHORUS
}
verseB = \lyricmode {
  Thou rush -- ing wind that art so strong, ye clouds that sail in heav'n a -- long,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  Thou ris -- ing morn in praise re -- joice, ye lights of eve -- ning find a voice,
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}
verseC = \lyricmode {
  Thou flow -- ing wa -- ter, pure and clear, make mu -- sic for thy God to hear,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  Thou fire so mas -- ter -- ful and bright, that giv -- est all both warmth and light,
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}
verseD = \lyricmode {
  Dear moth -- er earth, who day by day, un -- fold -- est bless -- ings on our way,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  The flow'rs and fruits that in thee grow, let them God's glo -- ry al -- so show,
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}
verseE = \lyricmode {
  And ev -- 'ry -- one, with ten -- der heart, for -- giv -- ing oth -- ers, take your part,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  Ye who long pain and sor -- row bear, sing praise and cast on God your care,
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}
verseF = \lyricmode {
  And thou, most kind and gen -- tle death, wait -- ing to hush our fi -- nal breath,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  Thou lead -- est home the child of God, as Christ be -- fore that way hath trod,
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}
verseG = \lyricmode {
  Let all things their Cre -- a -- tor bless, and wor -- ship God in hum -- ble -- ness,
  %% CHORUS
  %% al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _
  %% END CHORUS
  To God all thanks and praise be -- long! Join in the ev -- er -- last -- ing song:
  %% CHORUS
  %% O sing ye, O sing ye, al -- le -- lu -- ia, al -- le -- lu -- ia, al -- le -- lu -- ia!
  _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
  %% END CHORUS
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "2" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "4" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "" \verseE }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "6" "6" \verseF }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "7" "" \verseG }
>>

%% All sheet music outputs
clairStaffZoom = #.9
tradStaffZoom = #.98
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
