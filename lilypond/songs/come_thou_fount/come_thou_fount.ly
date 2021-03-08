\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "christian 4part acapella 3verse musicbyother textbyother"
\header {
  title = \titleText "Come, thou fount"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: American folk melody, 1813"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: Robert Robinson, 1759"
  meter = \smallText "NETTLETON 87.87 D"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key d \major
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
  \relative g' { \partial 4 fs8 e | d4 d fs8 a | e4 e fs8 a | b4 a fs8 e | d2 \bar"" }
  \relative g' { \partial 4 fs8 e | d4 d fs8 a | e4 e fs8 a | b4 a fs8 e | d2 \bar"" }
  \relative g' { \partial 4 a8 b16( cs) | d4 cs b8 a | b( a) fs4 a8 b16( cs) | d4 cs b8 a | d2 \bar "" }
  \relative g' { \partial 4 fs8 e | d4 d fs8 a | e4 e fs8 a | b4 a fs8 e | \partial 2 d2 | }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d8 cs | d4 d d8 d | cs4 cs d8 d | d4 d d8 cs | d2 }
  \relative e' { d8 cs | d4 d d8 d | cs4 cs d8 d | d4 d d8 cs | d2 }
  \relative e' { d8 g | fs4 a g8 fs | d4 d d8 g | fs4 a g8 fs | fs2 }
  \relative e' { d8 cs | d4 d d8 d | cs4 cs d8 d | d4 d d8 cs | d2 }
}
tenor = {
  \globalParts
  \relative a { a8 g | fs4 fs a8 a | a4 a a8 a | g4 fs a8 g | fs2 \bar"" }
  \relative a { a8 g | fs4 fs a8 a | a4 a a8 a | g4 fs a8 g | fs2 \bar"" }
  \relative a { a8 g | a4 a d8 d | g,8 fs a4 a8 g | a4 a d8 d | a2 \bar"" }
  \relative a { a8 g | fs4 fs a8 a | a4 a a8 a | g4 fs a8 g | fs2 }
}
bass = {
  \globalParts
  \relative d { d8 a | d4 d d8 fs, | a4 a d8 fs | g4 d a8 a | d2 \bar"" }
  \relative d { d8 a | d4 d d8 fs, | a4 a d8 fs | g4 d a8 a | d2 \bar"" }
  \relative d { fs8 e | d4 fs g8 d | d4 d fs8 e | d4 fs g8 d | d2 \bar"" }
  \relative d { d8 a | d4 d d8 fs, | a4 a d8 fs | g4 d a8 a | d2 }
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Come, Thou Fount of ev -- 'ry bless -- ing, tune my heart to sing thy grace;
  Streams of mer -- cy, nev -- er ceas -- ing, call for songs of loud -- est praise.
  Teach me some mel -- o -- dious son -- net, sung by flam -- ing tongues a -- bove.
  Praise the mount! I’m fixed up -- on it, mount of God’s un -- chang -- ing love.
}
verseB = \lyricmode {
  Here I raise my Eb -- e -- ne -- zer; here by Thy great help I’ve come;
  And I hope, by thy good plea -- sure, safe -- ly to ar -- rive at home.
  Je -- sus sought me when a stran -- ger, wan -- d’ring from the fold of God;
  He, to res -- cue me from dan -- ger, in -- ter -- posed his pre -- cious blood; }
verseC = \lyricmode {
  O to grace how great a debt -- or dai -- ly I’m con -- strained to be!
  Let that grace now, like a fet -- ter, bind my wan -- d’ring heart to thee.
  Prone to wan -- der, Lord, I feel it, prone to leave the God I love;
  Here’s my heart, O take and seal it, seal it for thy courts a -- bove.
}
verseD = \lyricmode {
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
    \tempo  4 = 90
  }
}
