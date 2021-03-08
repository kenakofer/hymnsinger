\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"


%% See docs/all_tags.txt for the full list available
tags = "secular 4part acapella 4verse musicbyother textadaptedbykenan evening"
\header {
  title = \titleText "Now all the woods are sleeping"
  %subtitle = \smallText "Optional"
  composer = \smallText "Music: Heinrich Isaac, 1539"
  %arranger = \smallText "Arranged by (optional), year"
  poet = \smallText "Text: Paul Gerhardt, 1648, tr. and alt. Kenan Schaefkofer, 2021"
  meter = \smallText "O WELT, ICH MUSS DICH LASSEN 776.778"
  copyright = \public_domain_notice "Kenan Schaefkofer"
  tagline = \tagline
}

%% SETTINGS
hymnKey = \key g \major
hymnTime = \time 6/2
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
  \relative g' { g2 4 a b2 d c b | r4 b4 d c a2 b g fs | } \break
  \relative g' { r4 g4 a g fs g \partial 2 a2 | }
  \relative g' { r4 a4 g a b2 d c b | } \break
  \relative g' { r4 b d c a2 b g fs |}
  \relative g' { r4 d4 g a b2 c b \partial 1. a2 g1 | }\break
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { d2 e4 fs g2 g g g | r4 d4 g e d2 d d4( cs) d2 | }
  \relative e' { r4 b4 e d d b d2 | }
  \relative e' { r4 fs4 e fs g2 d e4( fs) g2 | r4 g4 g g fs2 d d4( cs) d2 | }
  \relative e' { r4 d4 e e fs2 a g2. fs4 d1 }
}
tenor = {
  \globalParts
  \relative a { b2 4 d d2 d e d | r4 g,4 b c d2 b b4( g) a2 |}
  \relative a { r4 g4 e g a g fs2 | }
  \relative a { r4 d4 b c d2 b c d | r4 e4 d e d2 fs,2 g a | }
  \relative a { r4 a4 b c d2 e d d b1 | }
}
bass = {
  \globalParts
  \relative d { g2 e4 d g2 b c g | r4 g4 g a fs2 g e d |}
  \relative d { r4 e4 c b d e d2 | }
  \relative d { r4 d4 e a g2 b a g | r4 e4 b c d2 b e d |}
  \relative d { r4 fs4 e c b2 a b4( c) d2 g1 |}
}
songChords = \chords {
  \set chordChanges = ##t
}

%% LYRICS
verseA = \lyricmode {
  Now all the woods are sleep -- ing,
  the night and still -- ness creep -- ing
  o'er ci -- ty, field, and beast;
  but thou, my heart, a -- wake be,
  with pray'r -- ful thanks, at -- tend thee,
  to dear -- est Trea -- sures ere thou rest.
}
verseB = \lyricmode {
  Why Sun, are you re -- treat -- ing?
  The Moon, in dance, now lead -- ing
  the anc -- ient bal -- lad, Night.
  Like -- wise, a bright -- er glo -- ry
  does Truth in -- fuse our sto -- ry,
  when off -- ered soft as yon -- der light.
}
verseC = \lyricmode {
  Now ob -- li -- ga -- tion ceas -- es,
  this Night the tired re -- leas -- es
  and bids you sleep be -- gin:
  My love, there comes a mor -- row
  shall set thee free from sor -- row,
  and all the anx -- ious toil with -- in.
}
verseD = \lyricmode {
  My loved ones, rest se -- cure -- ly,
  from ev -- 'ry per -- il sure -- ly
  pro -- tect -- ed be your heads;
  and hap -- py slum -- bers send you,
  and ev -- 'ry care at -- tend you,
  as trus -- ted souls watch o'er your beds.
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
    \tempo  4 = 140
  }
}
