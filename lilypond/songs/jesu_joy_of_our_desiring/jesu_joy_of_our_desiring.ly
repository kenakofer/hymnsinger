\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 2verse musicbyother textbyother"
\header {
  title = \titleText "Jesu, joy of our desiring"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Johann Schopp, 1642, harm. J. S. Bach, 1716"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: Martin Janus, 1665, trans. Robert Bridges, 1927"
  meter = \smallText "WERDE MUNTER 87.87.88.77"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

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
  \numericTimeSignature
}

%% NOTES
soprano = {
  \globalParts
  \relative g' { b2 c4 | d2 4 | c2 b4 | a a r | b2 c4 | d2 b4 | a8( b16 c) b4( a) | g2 r4 | } \break
  \relative g' { b2 c4 | d2 4 | c2 b4 | a a r | b2 c4 | d2 b4 | a8( b16 c) b4( a) | g2 r4 | } \break
  \relative g' { a2 b4 | c2 4 | b4.( c16 d) b4 | a a r | c2 d4 e2 4 | d4.( e16 fs) d4 | c c r | } \break
  \relative g' { b2 c4 | d2 4 | c b2 | a2 r4 | b2 c4 d2 b4 | a8( b16 c) a2 | g2. | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { g2 4 | a( g) fs | g d2 | d4 4 r | g2 g4 | g( d) e | e fs8( e fs4) | d2 r4 | }
  \relative e' { g2 4 | a( g) fs | g d2 | d4 4 r | g2 g4 | g( d) e | e fs8( e fs4) | d2 r4 | }
  \relative e' { fs2 gs4 | a2 4 | 2 gs4 | a a r | a2 g4 | g( c) g | f( a) g | g g r | }
  \relative e' { g2 4 | g2 4 | g8( fs) g2 | fs2 r4 | g2 g4 | g( d) e | e fs8( e fs4) | d2. | }
}
tenor = {
  \globalParts
  \relative a { d2 e4 | a,2 b4 | b( a) g | fs a r | d2 e4 | d( b) b | c8( a) d( b c4) | b2 r4 | }
  \relative a { d2 e4 | a,2 b4 | b( a) g | fs a r | d2 e4 | d( b) b | c8( a) d( b c4) | b2 r4 | }
  \relative a { d2 4 | e2 f4 | f( d) e | c c r | e2 d4 c2 4 | a2 b4 e e r | }
  \relative a { d2 e4 | d4( b) b | c( d) e | a,2 r4 | d2 e4 | d( b) b | c8( a) d( b c4) | b2. |}
}
bass = {
  \globalParts
  \relative d { g4( fs) e | fs( e) d | e( fs) g | d d r | g4( fs) e | b'( b,) e | c( d) d | g,2 r4 | }
  \relative d { g4( fs) e | fs( e) d | e( fs) g | d d r | g4( fs) e | b'( b,) e | c( d) d | g,2 r4 | }
  \relative d { d4( c) b | a( a'8 g) f( e) | d4( b) e4 | a, a r | a'2 b4 | c4( a) e | f( d) g | c, c r | }
  \relative d { g2 e4 | b'( e,) e | a,( b) c | d2 r4 | g4( fs) e | b'( b,) e | c( d) d | g,2. | }
}

songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Je -- su, joy of our de -- sir -- ing, ho -- ly wis -- dom, love most bright,
  drawn by thee, our souls as -- pir -- ing soar to un -- cre -- at -- ed light.
  Word of God, our flesh that fash -- ioned, with the fire of life im -- pas -- sioned,
  striv -- ing still to truth un -- known, soar -- ing, dy -- ing round thy throne.
}
verseB = \lyricmode {
  Through the way, where hope is guid -- ing, hark, what peace -- ful mu -- sic rings,
  where the flock, in thee con -- fid -- ing, drink of joy from death -- less springs.
  Theirs is beau -- ty's fair -- est pleas -- ure. Theirs is wis -- dom's ho -- liest treas -- ure.
  Thou dost ev -- er lead thine own in the love of joys un -- known.
}
verseC = \lyricmode { }
verseD = \lyricmode { }
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
    \tempo  4 = 100
  }
}
