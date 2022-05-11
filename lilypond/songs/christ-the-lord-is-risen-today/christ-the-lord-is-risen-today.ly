\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
composer = \smallText "Music: anon, Lyra Davidica, 1708"
meter = \smallText "EASTER HYMN 77.77 with alleluias"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global-parts.ily"

%% SONG INFO
title = \titleText "Christ the Lord is risen today"
poet = \smallText "Text: Charles Wesley, 1739, alt."
typesetter = "Kenan Schaefkofer"
verseCount = 4
tags = "english christian easter 4part"
dateAdded = "2021-04-04"
\include "../../lib/header.ily"

%% NOTES
soprano = {
  \globalParts
  \relative g' {
    c,4 e g c, | f a a( g) |
    e8( f g c, f4) e8( f) | e4( d) c2 | \break
    f4 g a g | f e e( d) |
    e8( f g c, f4) e8( f) | e4( d) c2 | \break

    b'4 c d g, | c d e2 |
    b8( c d g, c4) b8( c) | b4( a) g2 | \break
    g8( a) b( g) c4 e, | f a a( g) |
    c8( b c g a b) c( d) | c4( b) c2
    \bar "|."
  }
}
alto = {
  \globalParts
  \relative e' {
    c4 c d c | c f f( e) |
    c2~( 8 b) c4 | c( b) c2 |
    c4 c c c | 8( b) c4 c( b) |
    c2~( 8 b) c4 | c( b) c2 |

    g'4. fs8 g4 g | g f g2 |
    g2~( 8 fs) g4 | g( fs) g2
    b,8( c) d( b) c4 4 | c f f( e) |
    e8( f e4 f) g8( f) | e4( g8 f) e2
  }
}
tenor = {
  \globalParts
  \relative a {
    e4 g g e | f c' c2 |
    g2. g8( f) | g4.( f8) e2 |
    f4 e f g | a8(f) g4 2 |
    g2. g8( f) | g4.( f8) e2 |

    d'4 c b b | b4. b8 c2 |
    d2. d8( c) | d4.( c8) b2 |
    g4 g g g | f c' c2 |
    g4( c~ 8 d) c( a) | g2 g
  }
}
bass = {
  \globalParts
  \relative d {
    c4 c b c | a f c'2 |
    c8( d e4 d) c8( a) | g2 c |
    a4 c f e | d e8( f) g4( g,) |
    c8( d e4 d) c8( a) | g2 c |

    g4 a b g'8( f) | e4 d c2 |
    g'8( a b4 a) g8( e) | d2 g, |
    g'4 f e c8( b) | a4 f c'2 |
    c8( d e c f d) e( f) | g4( g,) c2

  }
}
songChords = \chords {
  \globalChordSymbols
  c1 f2 c
  c2 f2 c4/g g:7 c2
  f2 f d:m7 g
  c2 f2 c4/g g:7 c2

  g2 g c c g g g4 d:7 g2
  g2 c f c c f c4/g g:7 c2

}

%% LYRICS
verseA = \lyricmode {
  \l Christ the Lord is ris'n to -- day!
  \SA {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  \l All crea -- a -- tion join to say:
  \SA {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  \l Raise your joys and tri -- umphs high:
  \SA {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  \l Sing, O heav'n, and earth re -- ply:
  \SA {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
}
verseB = \lyricmode {
  Love's re -- deem -- ing work is done,
  Al -- le -- lu -- ia
  fought the fight, the bat -- tle won.
  Al -- le -- lu -- ia
  Death in vain for -- bids him rise,
  Al -- le -- lu -- ia
  Christ has o -- pened par -- a -- dise.
  Al -- le -- lu -- ia
}
verseC = \lyricmode {
  Lives a -- gain our glo -- rious King,
  \SC {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  where, O death, is now thy sting?
  \SC {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  Dy -- ing once, he all doth save,
  \SC {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  where thy vic -- to -- ry, O grave?
  \SC {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
}
verseD = \lyricmode {
  Soar we now where Je -- sus led,
  \SD {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  fol -- l'wing our ex -- alt -- ed Head.
  \SD {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  Made like Christ, with Christ we rise,
  \SD {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
  ours the cross, the grave, the skies.
  \SD {
    Al -- le -- lu -- ia
  } \SO { _ _ _ _ }
}
verseE = \lyricmode { }
verseF = \lyricmode { }

% Set up music-aligned verses. Change to the correct number
\include "../../lib/4verse.ily"

clairStaffZoom = #.95
%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output. Change to the correct number
\include "../../lib/slides-book-4verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"