\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

composer = \smallText "Music: William H. Monk, 1861"
meter = \smallText "EVENTIDE 10 10.10 10"
hymnKey = \key ef \major
hymnTime = \time 2/2
quarternoteTempo = 110
\include "../../lib/global_parts.ly"

title = \titleText "Abide with me"
poet = \smallText "Text: Henry F. Lyte, 1847"
verseCount = 4
tags = "english theist 4part evening death"
typesetter = "Kenan Schaefkofer"
dateAdded = "2021-01-16"
\include "../../lib/header.ly"

%% NOTES
soprano = {
  \globalParts
  \relative g' { g2 g4 f | ef2 bf' | c4 bf bf af | g1 | } \break
  \relative g' { g2 af4 bf | c2 bf | af4 f g a | bf1 | } \break
  \relative g' { g2 g4 f | ef2 bf' | bf4 af af g | f1 | } \break
  \relative g' { f2 g4 af | g f ef af | g2 f | ef1 }
  \bar "|."
}
alto = {
  \globalParts
  \relative e' { ef2 d4 d | ef2 ef | ef4 d ef f | ef1 | }
  \relative e' { ef2 ef4 ef | ef2 ef | ef4 f ef ef | d1 | }
  \relative e' { ef2 d4 d | ef2 ef | ef4 ef e e | f1 | }
  \relative e' { d2 ef4 d | ef d ef f | ef2 d | ef1 }
}
tenor = {
  \globalParts
  \relative a { bf2 bf4 af4 g2 ef | ef4 bf' bf bf | bf1 | }
  \relative a { bf2 af4 g | af2 g | c4 bf bf ef, | f1 | }
  \relative a { g4( af) bf af | g2 ef'4( d) | c4 c c bf | af1 | }
  \relative a { bf2 bf4 bf | bf af g c | bf2. af4 | g1 }
}
bass = {
  \globalParts
  \relative d { ef2 bf4 bf | c2 g | af4 bf c d | ef1 | }
  \relative d { ef4( d) c bf | af2 ef' | f4 d ef c | bf1 | }
  \relative d { ef2 bf4 bf | c2 g | af4. bf8 c4 c | f1 | }
  \relative d { af'2 g4 f | ef bf c af | bf2 bf | ef1 }
}


%% LYRICS
verseA = \tag #'verseA \lyricmode {
	\l A -- bide with me; Fast falls the e -- ven -- tide,
  \l The dark -- ness deep -- ens; Lord, with me a -- bide!
  \l When o -- ther help -- ers fail, and com -- forts flee,
  \l Help of the help -- less, oh, a -- bide with me.
}
verseB = \tag #'verseB \lyricmode {
  Swift to its close ebbs out life’s lit -- tle day;
  Earth’s joys grow dim, its glo -- ries pass a -- way;
  Change and de -- cay in all a -- round I see;
  O Thou who chan -- gest not, a -- bide with me.
}
verseC = \tag #'verseC \lyricmode {
  Thou on my head in ear -- ly youth didst smile,
  And though re -- bel -- lious and per -- verse mean -- while,
  Thou hast not left me, oft as I left Thee.
  On to the close, O Lord, a -- bide with me.
}
verseD = \tag #'verseD \lyricmode {
  I fear no foe, with Thee at hand to bless;
  Ills have no weight, and tears no bit -- ter -- ness.
  Where is death’s sting? Where, grave, thy vic -- to -- ry?
  I tri -- umph still, if Thou a -- bide with me.
}
verseE = \tag #'verseE \lyricmode { }
verseF = \tag #'verseF \lyricmode { }

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

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
