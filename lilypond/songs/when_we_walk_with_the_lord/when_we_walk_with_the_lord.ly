\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ily"

%% TUNE INFO
composer = \smallText "Music: Daniel B. Towner, 1887"
meter = \smallText "TRUST AND OBEY 6.6.9 D with refrain"
hymnKey = \key f \major
hymnTime = \time 3/4
quarternoteTempo = 120
\include "../../lib/global_parts.ily"

%% SONG INFO
title = \titleText "When we walk with the Lord"
poet = \smallText "Text: John H. Sammis, 1887, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part"
dateAdded = "2021-04-24"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    \partial 4 f8 g | a4 a g | f2 8[ a] | c4 c bf | a2 8 8 | bf4 d bf | a c a | g2 \bar "" \break
    f8 g | a4 a g | f2 8[ a] | c4 c bf | a2 8 8 | bf4 d bf | a f g | f2. \bar "||" \break
    c'4 g c | a2 8 8 | d4 a c | bf2 \bar "" \break
    8 8 | bf4 a g | a \m c2. c4\fermata f,8 g | a4 f g | \partial 2 f2 \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    c8 8 | f4 4 e | f2 8 8 | e4 4 4 | f2 8 8 | 4 4 4 | 4 4 4 | e2
    c8 8 | f4 4 e | f2 8 8 | e4 4 4 | f2 8 8 | 4 4 4 | 4 c c | c2.
    e4 4 4 | f2 8 8 | fs4 4 4 | g2
    g8 8 | g4 f e | f \m f2. f4 f8 8 | f4 c c | c2
  }
}
tenor = {
  \globalParts
  \relative a {
    a8 bf | c4 4 bf | a2 8 c | c4 g c | 2 8 8 | d4 bf d | c a c | c2
    a8 bf | c4 c bf | a2 8 c | c4 g c | 2 8 8 | d4 bf d | c a bf | a2.
    g4 c c | c2 8 8 | a4 d d | 2
    c8 c | c4 c c | c \m a2. a4 c8 d | c4 a bf | a2
  }
}
bass = {
  \globalParts
  \relative d {
    f8 8 | 4 4 c | f2 8 8 | c4 4 4 | f2 8 8 | bf,4 4 4 | f' f f | c2
    f8 8 | 4 4 c | f2 8 8 | c4 4 4 | f2 8 8 | bf,4 4 4 | c c c | f2.
    c4 c c | f2 8 ef | d4 4 4 | g2
    e8 d | c4 c c | f \m f2. f4 a,8 bf | c4 4 4 | f,2

  }
}
songChords = \chords {
  \globalChordSymbols
  f4 | f f c:7 f f f c c c f f f bf2. f c4 c
  f4 | f f c:7 f f f c c c f f f bf2. c f
  c2. f d:7 g:m c:7 f f2/c c4:7 f
}

%% LYRICS
verseA = \lyricmode {
  \l When we walk with the Lord in the light of his word,
  what a glo -- ry he sheds on our way!
  \l While we do his good will, he a -- bides with us still,
  and with all who will trust and o -- bey.
  %% CHORUS
  Trust and o -- bey, for there's no oth -- er way
  to be hap -- py in Je -- sus, but to trust and o -- bey.
}
verseB = \lyricmode {
  Ev -- 'ry bur -- den we bear, ev -- 'ry sor -- row we share,
  all our toil he doth rich -- ly re -- pay.
  E -- ven grief, pain, and loss as we car -- ry a cross
  will be blessed as we trust and o -- bey.
  \SB {
    %% CHORUS
    Trust and o -- bey, for there's no oth -- er way
    to be hap -- py in Je -- sus, but to trust and o -- bey.
  }

}
verseC = \lyricmode {
  But we nev -- er can prove the de -- lights of his love,
  un -- til all on the al -- tar we lay,
  for the fa -- vor he shows, and the joy he be -- stows,
  are for them who will trust and o -- bey.
  \SC {
    %% CHORUS
    Trust and o -- bey, for there's no oth -- er way
    to be hap -- py in Je -- sus, but to trust and o -- bey.
  }
}
verseD = \lyricmode {
  Then in fel -- low -- ship sweet we will sit at his feet,
  or we'll walk by his side in the way.
  What he says we will do, where he sends we will go,
  nev -- er fear, on -- ly trust and o -- bey.
  \SD {
    %% CHORUS
    Trust and o -- bey, for there's no oth -- er way
    to be hap -- py in Je -- sus, but to trust and o -- bey.
  }
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides_book_4verse.ily"
%% MIDI output
\include "../../lib/midi_output.ily"