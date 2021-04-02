\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: John A. Stevenson, 1818"
meter = \smallText "87.87.86.87"
hymnKey = \key ef \major
hymnTime = \time 2/2
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "Now, on land and sea descending"
poet = \smallText "Text: Samuel Longfellow, 1859"
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english theist 4part"
dateAdded = "2021-04-02"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    g4 bf af bf | g bf f bf | g bf af f | ef d ef2 | \break
    g4 bf af bf | g bf f bf | g bf af f | ef d ef2 | \break
    ef'4 d ef bf | af f g bf | ef d ef bf | af( f) ef2 | \break
    ef4. 8 4 4 | f4. 8 4 4 | ef4. 8 4 g8( f) | ef4 d ef2 | \break
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    ef4 4 4 d | ef4 4 4 d | ef df c c | bf4 4 2 |
    ef4 4 4 d | ef4 4 4 d | ef df c c | bf4 4 2 |
    g'4 f ef ef | ef d ef d | ef f ef df | c( d) ef2 |
    bf4. 8 c4 8( ef) | 4. 8 4 d | bf4. 8 c4 c | bf4 4 2
  }
}
tenor = {
  \globalParts
  \relative a {
    bf4 4 c bf | 4 4 4 4 | 4 g af af | g f g2 |
    bf4 4 c bf | 4 4 4 4 | 4 g af af | g f g2 |
    bf4 af bf g | c bf bf af | bf4 4 4 g | af2 g |
    g4. 8 4 4 | c4. 8 bf4 4 | g4. 8 4 af | g f g2
  }
}
bass = {
  \globalParts
  \relative d {
    ef4 g f bf, | ef g bf bf, | ef ef af, af | bf bf ef2 |
    ef4 g f bf, | ef g bf bf, | ef ef af, af | bf bf ef2 |
    ef4 f g ef | af, bf ef f | g af g ef | af,( bf) ef2 |
    ef4 d c bf | af a bf bf | ef d c af | bf bf ef2 |
  }
}
songChords = \chords {
  \globalChordSymbols
  ef4 ef f:m bf ef ef bf bf ef ef f:m f:m ef bf ef
  ef4 ef f:m bf ef ef bf bf ef ef f:m f:m ef bf ef
  ef2 ef bf:7 ef ef ef bf:7 ef
  ef c:m f:m b:f ef c:m ef4 bf ef
}

%% LYRICS
verseA = \lyricmode {
  \l Now, on land and sea de -- scend -- ing, brings the night its peace pro -- found.
  \l Let our ves -- per hymn be blend -- ing with the ho -- ly calm a -- round.
  %% CHORUS
  Ju -- bi -- la -- te! Ju -- bi -- la -- te! Ju -- bi -- la -- te! A -- men!
  %% END CHORUS
  \l Let our ves -- per hymn be blend -- ing with the ho -- ly calm a -- round.
}
verseB = \lyricmode {
  Soon as dies the sun -- set glo -- ry, stars of heav'n shine out a -- bove,
  tell -- ing still the an -- cient sto -- ry– their Cre -- a -- tor's end -- less love.
  %% CHORUS
  \SB {
    Ju -- bi -- la -- te! Ju -- bi -- la -- te! Ju -- bi -- la -- te! A -- men!
  }
  \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  Tell -- ing still the an -- cient sto -- ry– their Cre -- a -- tor's end -- less love.
}
verseC = \lyricmode {
  Now, our wants and bur -- dens leav -- ing to our God who cares for all,
  cease we fear -- ing, cease we griev -- ing; touched by God our bur -- dens fall.
  %% CHORUS
  \SC {
    Ju -- bi -- la -- te! Ju -- bi -- la -- te! Ju -- bi -- la -- te! A -- men!
  }
  \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  Cease we fear -- ing, cease we griev -- ing; touched by God our bur -- dens fall.
}
verseD = \lyricmode {
  As the dark -- ness deep -- ens o'er us, lo! E -- ter -- nal stars a -- rise.
  Hope and faith and love rise glo -- rious, shin -- ing in the Spir -- it's skies.
  %% CHORUS
  \SD {
    Ju -- bi -- la -- te! Ju -- bi -- la -- te! Ju -- bi -- la -- te! A -- men!
  }
  \SO {
    _ _ _ _ _ _ _ _ _ _ _ _ _ _
  }
  %% END CHORUS
  Hope and faith and love rise glo -- rious, shin -- ing in the Spir -- it's skies.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ly"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output. Change to the correct number
\include "../../lib/slides_book_4verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
