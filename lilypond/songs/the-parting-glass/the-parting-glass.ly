\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: Traditional Irish"
arranger = \smallText "arr. Kenan Schaefkofer, based on arr. by Wailing Jennys"
%% Note: the meter variable requires a TUNE NAME, following by a meter, for page generation to work. See existing songs for examples
meter = \smallText "PARTING GLASS 8.8.8.8"
hymnKey = \key f \major
hymnTime = \time 4/4
quarternoteTempo = 75
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Parting Glass"
poet = \smallText "Text: Traditional Irish"
typesetter = "Kenan Schaefkofer"
verseCount = 2
tags = "english secular 3part"
dateAdded = "2026-01-28"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 a8( g) | f4. d8 d c4 d8 | f4 8( g) g4 \fermata  \m r8. {}
     f8( g) | a4. 8 8( g) f( g) | a8. f16 f4\( e\)\fermata \bar "" \break \m r8. {}
    a8( g) | f4. d8 \appoggiatura d16 c4. d8 | f4 8( g) g4 \fermata  \m r8. {}
     f8( g) | a4 d8( c8) c4 a8( g) | f4. d8 d4\fermata\bar "" \break \m r8. {}

     r8 c'8 | c8( a) d( c) c4. c8 | c8( a) d( c) c4 r8 \fermata 
     a8 | \appoggiatura a16 bf4. a8 g4 f8( g) | a4. e8 e4 \fermata \bar "" \break \m r8. {}
    \partial 4 a8( g) | f4. d8 d4 \appoggiatura c8 d4 | f4 8( g) g4 \fermata  \m r8. {}
     f8( g) | a8 r8 d( c) c4 a8( g) | \partial 2. f4. d8 d4\fermata \bar ":|." \break \m r8. {}

     \partial 4 f8( g) | a8 r8 d( c) c4 a8( g) | f4. d8 d4\fermata \m r8. {}
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    f8( e) | d4. d8 bf bf4 bf8 | c4 4 e4 \m r8. {}
    d8( e) | f4. f8 f8( c) a( c) | f8. 16 4 e4 \m r8. {}
    f8( e) | d4. bf8 bf4. bf8 | c4 4 e4\m r8. {}
    d8( e) | f4 bf8( a) a4 f4 | d4. d8 d4\m r8. {}

     r8 a'8 | a8( f) bf( a) a4. a8 | a8( f) bf( a) a4 r8 
     f8 | \appoggiatura f16 g4. f8 e4 d8( e) | f4. e8 e4 \m r8. {}
    \partial 4 f8( e) | d4. d8 d4 c4 | c c e4  \m r8. {}
     f4 | f8 r8 bf8( a) a4 f4 | d4. d8 d4 \m r8. {}

     f4 | f8 r8 bf8( a) a4 f4 | d4. a8 a4 \m r8. {}
  }
}
tenor = {
  \globalParts
  \relative a {
    f4 | f4. f8 f f4 f8 | f4 4 c4 _\fermata \m r8. {}
    c4 | f4. f8 f4 4 | f8. 16 f4( c4)_\fermata \m r8. {}
    f4 | f4. f8 f4. f8 | f4 4 c4_\fermata \m r8. {}
    c4 | f4 f f a, | a4. bf8 4_\fermata\m r8. {}

    r8 f'8 | f4 4 4. 8 | f4 4 4 _\fermata
    r8 f8 | d4. c8 c4 c | c4. c8 c4 _\fermata \bar "" \break\m r8. {}
    c4 | a4. 8 bf4 4 | c c4 c4 _\fermata \m r8. {}
    c4 | f8 r8 4 4 a,4 | a4. bf8 4 _\fermata\m r8. {}

    c4 | f8 r8 4 4 4 | f4. <f d>8 4 _\fermata \m r8. {}
  }
}
bass = {
  \globalParts
  \relative d {
    
  }
}
songChords = \chords {
  \globalChordSymbols
  f4 | d2:m bf | f c | f f | f c |
     | d2:m bf | f c | f f | d:m bf4 |
  f4 | f2 f | f f | g:m c | f c |
     | d2:m bf | f c | f f | d:m bf4 |

  f4 | f2 f | d2.:m |
}

%% LYRICS
verseA = \lyricmode {
  \l Oh, all the mo -- ney that 'ere I spent,
  \l I spent it in good com -- pa -- ny. "__" 
  \l And all the harm __ that 'ere I done,
  \l a -- las, it was to none but me.

  \l And all I've done for want of wit,
  \l To mem -- 'ry now I can't re -- call.
  \l So raise to me the part -- ing glass.
  \l Good -- night! And joy be with you all. 
}
verseB = \lyricmode {
  Oh, all the com -- rades that 'ere I had,
  are sor -- ry for my go -- ing a -- way.
  And all the sweethearts that 'ere I had,
  would wish me one more day to stay.

  But since it falls un -- to my lot
  that I should rise and you should not,
  I'll gen -- tly rise, "and I'll" soft -- ly call:
  Good -- night! And joy be with you all.
  Good -- night! And joy be with you all.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/2verse.ily"

%% Use this, or the tradStaffZoom and shapeStaffZoom equivalents, if space is tight.
%clairStaffZoom = #.9

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-2verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"