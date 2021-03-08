\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 4verse musicbyother textbyother"
\header {
  title = \titleText "All hail the power of Jesus' name"
  composer = \smallText "Music: Oliver Holden, 1792"
  poet = \smallText "Text: Edward Perronet, 1780, revised by John Rippon, 1787"
  meter = \smallText "CORONATION CM extended"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key g \major
hymnTime = \time 2/2
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
  \relative g' { \partial 4 d4 | g4 g b b | a g a  b | a g b a | g2. \bar"" } \break
  \relative g' { a4 | b a g b | d8( c) b( a) b4 \bar"" }
  \relative g' { d'4 | d2 d | e d4( cs) | d2. \bar"" } \break
  \relative g' { b4 | d b g b | a8( g) a( b) a4 \bar"" }
  \relative g' { g4 | d'2 c | b4.( c8 a4) a | g2 \bar"|." }
}
alto = {
  \globalParts
  \relative e' { b4 | d4 d g g | fs e fs g | fs g d c | b2. }
  \relative e' { d4 | g d b g' | b8[ a] g[ fs] g4 fs4 | g2 a | g fs4( e) | fs2. }
  \relative e' { g4 | g g g d | d d fs g | g2 e | d2. c4 | b2 }
}
tenor = {
  \globalParts
  \relative a { g4 | b4 b d d | c b c d | c b g fs | g2. }
  \relative a { a4 | b a g b | d8[ c] b[ a] b4 a | b2 a | b a | a2. }
  \relative a { g4 | b d d d | c8[ b] c[ d] c4 b4 | g2 g | g2. fs4 | g2 }
}
bass = {
  \globalParts
  \relative d { g,4 | g4 g g' g | d e d g | d e d d | g,2. }
  \relative d { d4 | g d b g' | b8[ a] g[ fs] g4 d | g2 fs | e a | d,2. }
  \relative d { g4 | g g b g | d d d e | b2 c | d2. d4 | g,2 }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  All hail the pow’r of Je -- sus’ name! Let an -- gels pros -- trate fall.
  Bring forth the roy -- al di -- a -- dem, and crown him Lord of all.
  Bring forth the roy -- al di -- a -- dem, and crown him Lord of all!
}
verseB = \lyricmode {
  O seed of Is -- rael’s cho -- sen race now ran -- somed from the fall,
  hail him who saves you by his grace, and crown him Lord of all.
  Hail him who saves you by his grace, and crown him Lord of all!
}
verseC = \lyricmode {
  Let ev -- ’ry tongue and ev -- ’ry tribe re -- spon -- sive to his call,
  to him all maj -- es -- ty a -- scribe, and crown him Lord of all.
  To him all maj -- es -- ty a -- scribe, and crown him Lord of all!
}
verseD = \lyricmode {
  Oh, that with all the sa -- cred throng we at his feet may fall!
  We’ll join the ev -- er -- last -- ing song and crown him Lord of all.
  We’ll join the ev -- er -- last -- ing song and crown him Lord of all!
}
verseE = \lyricmode { }
verseF = \lyricmode { }

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "5" "5" \verseE }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "6" "6" \verseF }
>>

%% If fillScore needs to be modified (usually for non-SATB standard songs), copy it here from hymn_common
%% The default fillscore combines the first two arguments into an upper staff and the last two arguments into
%% a lower staff.

%% Traditional notation
\book { \bookOutputSuffix "trad" \score { \fillTradScore \soprano \alto \tenor \bass \songChords } }

%% Traditional with shaped noteheads (broken on non-combined chords)
\book { \bookOutputSuffix "shapenote" \score { \fillTradScore {\aikenHeads \soprano} {\aikenHeads \alto} {\aikenHeads \tenor} {\aikenHeads \bass} \songChords } }

%% Clairnotes Notation
\book { \bookOutputSuffix "clairnote" \score { \fillClairScore \soprano \alto \tenor \bass } }

%% MIDI output
\score {
  <<
    \new Staff \with { midiMaximumVolume = #0.9 } \soprano
    \new Staff \with { midiMaximumVolume = #0.7  } \alto
    \new Staff \with { midiMaximumVolume = #0.8  } \tenor
    \new Staff \with { midiMaximumVolume = #0.9 } \bass
  >>
  \midi {
    \context { \Staff \remove "Staff_performer" }
    \context { \Voice \consists "Staff_performer" }
    \tempo  4 = 120
  }
}
