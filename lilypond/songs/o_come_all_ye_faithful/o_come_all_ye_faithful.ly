\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
composer = \smallText "Music: John F. Wade, 1782"
meter = \smallText "ADESTE FIDELES irregular"
hymnKey = \key a \major
hymnTime = \time 4/4
quarternoteTempo = 120
\include "../../lib/global_parts.ly"

%% SONG INFO
title = \titleText "O come, all ye faithful"
poet = \smallText "Text: John F. Wade, 1743, tr. Frederick Oakeley, 1841, William Mercer 1854, and others"
copyright = \public_domain_notice "Kenan Schaefkofer"
verseCount = 4
tags = "english christian 4part winter"
dateAdded = "2021-01-19"
\include "../../lib/header.ly"

%% NOTES
soprano = \relative g' {
  \globalParts
  \stemUp
 %1
    \partial 4 a4 | a2 e4 a |
    b2 e, |
    cs'4 b cs d |
    cs2 b4 \bar "" \break
 %5
    a4 a2 gs4 fs |
    gs4( a) b cs |
    gs2 fs4. e8 |
    e1 |
    \break
 %9
    e'2 d4 cs |
    d2 cs |
    b4 cs a b |
    gs4.( fs8) e4
    \bar "||" \break
 %13
    a | a gs a b |
    a2 e4 cs' |
    cs b cs d |
    cs2 b4
    \bar "" \break
 %17
    cs4 |
    d4 cs b a |
    gs2 a4( d) |
    cs2( b4.) a8 |
    a2. s4
  \bar "|."
}
alto = \relative e'{
  \globalParts
  \stemUp
%1
    \partial 4 e4 | e2 e4 cs |
    e2 e |
    e4 e e fs |
    e2 e4 cs |
 %5
    cs4( ds) e ds |
    e4( e) e e |
    e2 ds4. e8 |
    e1 |
 %9
    e2 fs8 gs a4 |
    fs4( gs) a2 |
    e4 e fs fs |
    e2 e4
 %13
    a | a gs a b |
    a2 e4 e |
    e4 e e gs |
    a2 gs4
 %17
    a4 |
    fs8 gs a4 e ds |
    e2 e4( fs) |
    e2( e4.) cs8 |
    cs2.  \skip 4
}
tenor = \relative a {
  \globalParts
  \stemDown
   cs4 | cs2 a4 a |
    gs2 b |
    a4 b a a |
    a2 gs4 a |
 %5
    a2 b4 b |
    e,4( cs) gs' fs |
    b2 a4. gs8 |
    gs1 |
 %9
    cs2 d4 e |
    d2 e |
    e4 a, cs d |
    b4.( a8) gs4
 %13
    r4 R1 |
    r2 r4 a4 |
    a4 gs a b |
    a2 gs4
 %17
    e'4 |
    d4 e b b |
    b2 a2 |
    a2( gs4.) a8 |
    a2. \skip 4
}
bass = \relative d {
  \globalParts
  \stemDown
  a4 | a2 cs4 a|
    e'2 gs |
    a4 gs a d, |
    e2 e4 fs |
 %5
    fs2 e4 b |
    b( a) gs a |
    b2 b4. e8 |
    e1 |
 %9
    cs'2 b4 a |
    b2 a |
    gs4 a fs d |
    e2 e4
 %13
    r4 |
    r1 |
    r2 r4 \pa r4 |
    r1 |
    r2. \pt
 %17
    a4 |
    b4 a gs fs |
    e4( d) cs4( d) |
    e2( e4.) a,8 |
    a2. \skip 4
}


%% LYRICS
verseA = \lyricmode {
  O come, all ye faith -- ful, joy -- ful and tri -- um -- phant,
  O come ye, O come ye to Beth -- _ le -- hem.
  \l Come and be -- hold him,
  born the King of an -- gels.
  %% CHORUS
  O come, let us a -- dore him,
  O come, let us a -- dore him,
  O come, let us a -- dore him,
  Christ the Lord.
}
verseB = \lyricmode {
 _ True God of true God, Light of light e -- ter -- nal,
 _ our low -- ly na -- ture he hath not ab -- horred;
 Son of the Fa -- ther, be-got -- ten, not cre -- at -- ed.
}
verseC = \lyricmode {
  _ Sing, choirs of an -- gels, sing in ex -- ul -- ta -- tion,
  _ sing, all ye cit -- i -- zens of heav'n a -- bove;
  glo -- ry to God, all glo -- ry in the high -- est.
}
verseD = \lyricmode {
  _ Yea, Lord, we greet thee, born this hap -- py morn -- ing,
  _ Je -- sus, to thee be all glo -- _ ry giv'n;
  Word of the Fa -- ther, now in flesh ap -- pear -- ing.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "4" "" \verseD }
>>

%% All sheet music outputs
clairStaffZoom = #.9
\include "../../lib/all_notation_outputs.ly"
%% midi output
\include "../../lib/midi_output.ly"
