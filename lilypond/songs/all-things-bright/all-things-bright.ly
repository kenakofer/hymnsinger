\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/royal-oak.ily"

%% SONG INFO
title = \titleText "All things bright and beautiful"
poet = \smallText "Text: Cecil F. Alexander, Hymns for Little Children, 1848, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2023-12-08"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \hideVerseNumberAtLineStart
  %% CHORUS
  \l All things bright and beau -- ti -- ful, all crea -- tures great and small,
  all things wise and won -- der -- ful, the Lord God made them all.
  \SO { \mark \markup { \fontsize #-2 "Fine" } }
  %% END CHORUS
  \showVerseNumberAtLineStart "1" #3.5
  \SA { \showVerseNumberAtLineStart "1" #2.0 }
  \l Each lit -- tle flow'r that o -- pens, each lit -- tle bird that sings,
  \hideVerseNumberAtLineStart
  \l God made their glow -- ing col -- ors, God made their ti -- ny wings.
}
verseB = \lyricmode {
  \hideVerseNumberAtLineStart
  \SB {
    All things bright and beau -- ti -- ful, all crea -- tures great and small,
    all things wise and won -- der -- ful, the Lord God made them all.
  } \SO { _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ }

  \showVerseNumberAtLineStart "2" #3.5
  \SB { \showVerseNumberAtLineStart "2" #2.0 }
  The pur -- ple -- head -- ed moun -- tain, the riv -- er run -- ning by,
  \hideVerseNumberAtLineStart
  the sun -- set, and the morn -- ing that bright -- ens up the sky;
}
verseC = \lyricmode {
  \hideVerseNumberAtLineStart
  \SC {
    All things bright and beau -- ti -- ful, all crea -- tures great and small,
    all things wise and won -- der -- ful, the Lord God made them all.
  } \SO { _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ }

  \showVerseNumberAtLineStart "3" #3.5
  \SC { \showVerseNumberAtLineStart "3" #2.0 }
  The cold wind in the win -- ter, the pleas -- ant sum -- mer sun,
  \hideVerseNumberAtLineStart
  the ripe fruits in the gar -- den, God made them ev -- 'ry one.
}
verseD = \lyricmode {
  \hideVerseNumberAtLineStart
  \SD {
    All things bright and beau -- ti -- ful, all crea -- tures great and small,
    all things wise and won -- der -- ful, the Lord God made them all.
  } \SO { _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ }

  \showVerseNumberAtLineStart "4" #3.5
  \SD { \showVerseNumberAtLineStart "4" #2.0 }
  God gave us eyes to see them, and lips that we might tell
  \hideVerseNumberAtLineStart
  how great is God Al -- might -- y, who has made all things well.
}

% Set up music-aligned verses. Change to the correct number
%\include "../../lib/4verse.ily"
% For "all things bright", we don't want to show the verse numbers at the start,
% because it starts on the refrain. This is an alteration of 4verse.ily
all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "1" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "2" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "3" \verseC } }
  \tag #'verseD { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "4" \verseD } }
>>

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"