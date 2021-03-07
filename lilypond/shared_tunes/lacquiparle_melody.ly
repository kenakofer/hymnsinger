\version "2.20.0"
\include "../lib/hymn_common.ly"
\language "english"

composer = \smallText "Music: Plains Indian traditional, 1879"
meter = \smallText "LACQUIPARLE Irregular"

%% SETTINGS
hymnKey = \key c \minor
hymnTime = \time 2/2
globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeamExceptions
  \numericTimeSignature
  \phrasingSlurDashed
}

%% NOTES
soprano = {
  \globalParts
  \relative f' { c2 4 4 | g'2. af4 | g2 4 f | ef1 | f2 4 d | c2 d | c1~ | c2 r | } \break
  \relative f' { c2 4 4 | c'2. d4 | c2 c4\( bf\) | g1 | c2 4 bf | g2. ef4 | f2 4\( d\) | c1 | } \break
  \relative f' { c2 4 4 | g'2. af4 | g2 4\( f\) | ef1 | f2 4 d | c2 d | c1~ | c2 r | } \break
  \bar "|."
}
alto = {
}
tenor = {
}
bass = {
}
songChords = \chords {
  \set chordChanges = ##t
  c1:m c:m  c:m c:m
  f:m f:m c:m c:m
  c:m c:m c:m c:m
  c:m c:m f:m c:m
  c:m c:m c:m c:m
  f:m f:m c:m
}

all_verses = { }

%% UNCOMMENT to VERIFY, then RECOMMENT
%\book { \score { \fillTradScoreSingleStaff \soprano {} {} {} \songChords } }
%\score { << \soprano >> \midi { \tempo  4 = 100 } }
