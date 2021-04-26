\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/invitation-new.ily"

%% SONG INFO
title = \titleText "Hark, I hear the harps eternal"
poet = \smallText "Text: F. R. Warren"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english christian 4part"
dateAdded = "2021-04-26"
\include "../../lib/header.ily"


%% LYRICS
verseA = \lyricmode {
  \l Hark, I hear the harps e -- ter -- nal
  ring -- ing on the far -- ther shore
  as I near those swol -- len wa -- ters
  with their deep and sol -- emn roar.
  %% CHORUS
  Hal -- le lu -- jah, hal -- le -- lu -- jah,
  Hal -- le lu -- jah, praise the lamb!
  Hal -- le lu -- jah, hal -- le -- lu -- jah,
  Glo -- ry to the great I Am!
}
verseB = \lyricmode {
  And my soul, though stain'd with sor -- row
  fad -- ing as the light of day
  pas -- ses swift -- ly o'er those wa -- ters
  to the ci -- ty far a -- way.
  \SB {
    %% CHORUS
    Hal -- le lu -- jah, hal -- le -- lu -- jah,
    Hal -- le lu -- jah, praise the lamb!
    Hal -- le lu -- jah, hal -- le -- lu -- jah,
    Glo -- ry to the great I Am!
  }
}
verseC = \lyricmode {
  Souls have cross'd be -- fore me, saint -- ly,
  to that land of per -- fect rest,
  and I hear them sing -- ing faint -- ly
  in the man -- sions of the blest.
  \SC {
    %% CHORUS
    Hal -- le lu -- jah, hal -- le -- lu -- jah,
    Hal -- le lu -- jah, praise the lamb!
    Hal -- le lu -- jah, hal -- le -- lu -- jah,
    Glo -- ry to the great I Am!
  }
}

spacingVerse = \lyricmode {
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
  "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t" "\t"
}

% Set up music-aligned verses. Change to the correct number
all_verses = <<
  \new NullVoice = "soprano" \soprano
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \verseC } }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "" "" \spacingVerse }
>>

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"