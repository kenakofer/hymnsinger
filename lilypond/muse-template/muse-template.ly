\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% MANUAL INFO
composer = \smallText \markup { "Music: Composer," \italic "Book," "year" }
poet = \smallText \markup { "Text: Author," \italic "Book," "year" }
meter = \smallText "TUNE NAME meter"

%arranger = \smallText "arr. Name, year"
%% Note: the meter variable requires a TUNE NAME, following by a meter, for page generation to work. See existing songs for examples
%subtitle = \smallText "Optional"
%prescore_text = \prescoreText "Uncomment to add text up and left of the score"
%postscore_text = \postscoreText "Uncomment to add text down and left of the score"

verseCount = VERSE_COUNT
tags = "english christian 4part"
dateAdded = %YYYY-MM-DD%
typesetter = "Kenan Schaefkofer"

%NOTES

%CHORDS
songChords = \chords {
  \globalChordSymbols
}

%LYRICS


% Set up music-aligned verses. Change to the correct number
\include "../../lib/VERSE_COUNTverse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-VERSE_COUNTverse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
