\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
%% If you have a shared tune file, use this form:
\include "../../shared-tunes/royal-oak.ily"

%% SONG INFO
title = \titleText "All things kind and beautiful"
poet = \smallText "Text: Kenan Schaefkofer, 2023"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "english secular 4part"
dateAdded = "2023-12-10"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \hideVerseNumberAtLineStart
  %% CHORUS
  All things kind and beau -- ti -- ful, all be -- ings far and near,
  all words wise and won -- der -- ful, are trea -- sures we hold dear.
  \SO { \mark \markup { \fontsize #-2 "Fine" } }
  %% END CHORUS
  \showVerseNumberAtLineStart "1" #3.5
  \SA { \showVerseNumberAtLineStart "1" #2.0 }
  \l Each lit -- tle flow -- er bloom -- ing, each fea -- ther on a wing,
  \hideVerseNumberAtLineStart
  \l and bits of soul -- filled star -- dust who hurt and heal and sing;
}
verseB = \lyricmode {
  \hideVerseNumberAtLineStart
  \SB {
    All things kind and beau -- ti -- ful, all be -- ings far and near,
    all words wise and won -- der -- ful, are trea -- sures we hold dear.
  } \SO { _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ }

  \showVerseNumberAtLineStart "2" #3.5
  \SB { \showVerseNumberAtLineStart "2" #2.0 }
  Each tin -- y seed that o -- pens, each leaf -- ing tow'r of wood,

  \hideVerseNumberAtLineStart
  each plan that leads to act -- ion, and yields a har -- vest good;
}

verseC = \lyricmode {
  \hideVerseNumberAtLineStart
  \SC {
    All things kind and beau -- ti -- ful, all be -- ings far and near,
    all words wise and won -- der -- ful, are trea -- sures we hold dear.
  } \SO { _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ }

  \showVerseNumberAtLineStart "3" #3.5
  \SC { \showVerseNumberAtLineStart "3" #2.0 }
  Each pla -- net in its wan -- d'ring, that meets a child's _ gaze,
  \hideVerseNumberAtLineStart
  Each love thrown past all boun -- d'ries, a light -- cone tipped with praise;
}

% Set up music-aligned verses. Change to the correct number
%\include "../../lib/4verse.ily"
% For "all things kind", we don't want to show the verse numbers at the start,
% because it starts on the refrain. This is an alteration of 3verse.ily
all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "1" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "2" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "" "3" \verseC } }
>>

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"