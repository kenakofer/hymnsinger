\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\language "english"
\include "../../lib/clairnote.ly"
\include "../../lib/hymn_common.ly"
\include "../../shared_tunes/lasst_uns_erfreuen.ly"
%\include "color_by_pitch.ly"

%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 7verse musicbyother textbyother"
\header {
  title = \titleText "All creatures worship God most high"
  subtitle = \smallText "Alt. title: All creatures of our God and King"
  composer = \composer
  poet = \twoLineSmallText "Text: Saint Francis of Assisi, 1225;" "Translated William H. Draper, 1926; alt."
  meter = \meter
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
postscore_text = \postscoreText "*Or, ''All creatures of our God and King, / lift up your voice and with us sing''"

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
  Thou rush -- ish wind that art so strong, ye clouds that sail in heav'n a -- long,
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
  \new Lyrics  \lyricsto soprano  { \globalLyrics "6" "" \verseG }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book {
  \bookOutputSuffix "trad" \score {
  \layout {
    #(layout-set-staff-size 19)
  } \fillTradScore \soprano \alto \tenor \bass \songChords
} \postscore_text}

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \prescore_text \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book {
  \prescore_text
  \bookOutputSuffix "clairnote" \score {
  \layout {
    #(layout-set-staff-size 17)
  } \fillClairScore \soprano \alto \tenor \bass
} \postscore_text}

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
    \tempo  4 = 140
  }
}
