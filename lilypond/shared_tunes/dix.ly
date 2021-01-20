\version "2.20.0"
\include "../lib/hymn_common.ly"
\language "english"

%% SETTINGS
hymnKey = \key a \major
hymnTime = \time 2/2
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
  \numericTimeSignature
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { a4 gs8( a) b4 a | d d cs2 | fs,4 gs a fs | e e e2 | } \break
  \relative g' { a4 gs8( a) b4 a | d d cs2 | fs,4 gs a fs | e e e2 | } \break
  \relative g' { cs4 b a cs | e4. d8 cs2 | fs,4 gs a d | cs b a2 |} \break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { e4 e e e | d e e2 | fs4 e e d cs b cs2 | }
  \relative e' { e4 e e e | d e e2 | fs4 e e d cs b cs2 | }
  \relative e' { e4 e e e | e e e2 | d4 e e d | e4. d8 cs2 | }
}
tenor = {
  \globalParts
  \relative a { cs4 d8( cs) b4 cs | a b a2 | a4 b a a | a gs a2 | }
  \relative a { cs4 d8( cs) b4 cs | a b a2 | a4 b a a | a gs a2 | }
  \relative a { a4 e'8( d) cs4 a | b gs a2 | a4 b a a | a gs a2 | }
}
bass = {
  \globalParts
  \relative d { a'4 b8( a) gs4 a | fs gs a2 | d,4 d cs d | e e a,2 | }
  \relative d { a'4 b8( a) gs4 a | fs gs a2 | d,4 d cs d | e e a,2 | }
  \relative d { a'4 gs a a | gs e a2 | d,4 d cs fs | e e a,2 | }
}
songChords = \chords {
  \set chordChanges = ##t
    a4 a a a | d e a a | d d d d | a e a a |
    a4 a a a | d e a a | d d d d | a e a a |
    a4 e a a | e e a a | d d a d | a e a a |
}

all_verses = { }

%% UNCOMMENT to VERIFY, then RECOMMENT
%\book { \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }
%\score { << \soprano \alto \tenor \bass >> \midi { \tempo  4 = 120 } }
