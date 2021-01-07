\version "2.20.0"
\include "../lib/hymn_common.ly"
\language "english"

%% SETTINGS
hymnKey = \key g \major
hymnTime = \time 3/4
%% Adjust these to fix beaming
%hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/4)
%hymnBeatStructure = \set Timing.beatStructure = 1,1,1,1
%hymnBeatExceptions = \set Timing.beamExceptions = #'()
globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { \partial 4 d4 | g2 b8( g) | b2 a4 | g2 e4 | d2 d4 | g2 b8( g) | b2 a4 | d2.~ | \partial 2 d2 \bar " " } \break
  \relative g' { \partial 4 b4 | d4.( b8) d( b) | g2 d4 | e4.( g8) g( e) | d2 d4 | g2 b8( g) | b2 a4 | g2.~ | 2 }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { b4 | b2 d4 | d2 c4 | b2 c4 | b2 b4 | b2 d4 | d2 4 | fs2( g4 | a2) }
  \relative e' { fs4 | d2 4 | 2 4 | c4.( d8) c4 | b2 d4 | b2 d4 | g2 fs4 | d2.~ | 2 }
}
tenor = {
  \globalParts
  \relative a { g4 | d2 g4 | g2 fs4 | g2 4 | 2 4 | d2 g4 | g2 fs4 | a2( b4 | c2) }
  \relative a { d4 | b4.( g8) b( g) | g2 4 | g2 e8( g) | g2 g4 | g2 g8( b) | d2 c4 | b2.~ | 2 }
}
bass = {
  \globalParts
  \relative d { g,4 | g2 8( b) | d2 4 | e2 c4 | g2 4 | 2 8( b) | d2 d4 | d2.~ | 2 }
  \relative d { d4 | g2 g4 | b,2 4 | c4.( b8) c4 | g2 b4 | e2 d4 | d2 4 | g2.~ | 2 }
}
songChords = \chords {
  \set chordChanges = ##t
  s4 g g g g g d e2.:m g2. g g d2.:7 d2:7
  s4 g2. g:7 c g e:m g2:/d d4:7 g g g g g
}

all_verses = { }

%% UNCOMMENT to VERIFY, then RECOMMENT
\book { \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }
%\score { << \soprano \alto \tenor \bass >> \midi { \tempo  4 = 120 } }
