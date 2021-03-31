\version "2.20.0"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn_common.ly"

%% TUNE INFO
\include "../../shared_tunes/wunderbarer_konig.ly"

%% SONG INFO
title = \titleText "Gott ist gegenwärtig"
subtitle = \smallText "See also in English: God is here among us"
poet = \smallText "Text: Gerhard Tersteegen, 1729"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "german christian 4part"
dateAdded = "2021-03-04"
\include "../../lib/header.ly"

%% LYRICS
verseA = \tag #'verseA \lyricmode {
  \l Gott ist ge -- gen -- wär -- tig. Las -- set uns an -- be -- ten und in Ehr -- furcht vor ihn tre -- ten.
  \l Gott ist in der Mit -- te. Al -- les in uns schwei -- ge und sich in -- nigst vor ihm beu -- ge.
  \l Wer ihn kennt, wer ihn nennt, schlag die Au -- gen nie -- der; kommt, er -- gebt euch wie -- der.
}
verseB = \tag #'verseB \lyricmode {
  Gott ist ge -- gen -- wär -- tig, dem die Che -- ru -- bi -- nen Tag und Nacht ge -- bü -- cket die -- nen.
  ''Hei -- lig, hei -- lig, hei -- lig!'' sin -- gen ihm zur Eh -- re al -- ler En -- gel ho -- he Chö -- re.
  Herr, ver -- nimm uns -- re Stimm, da auch wir Ge -- rin -- gen uns -- re Op -- fer brin -- gen.
}
verseC = \tag #'verseC \lyricmode {
  Herr, komm in mir woh -- nen; lass mein Herz auf Er -- den dir ein Hei -- lig -- tum noch wer -- den.
  Komm, du na -- hes Wes -- en; dich in mir ver -- klä -- re, dass ich dich stets lieb und eh -- re.
  Wo ich geh, sitz und steh, lass mich dich er -- blick -- en und vor dir mich bü -- cken.
}

all_verses = <<
  \new NullVoice = "soprano" \soprano
  % Add what you need. If more than 4, fill in the second argument as shown in 5 and 6
  \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB }
  \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC }
>>

%% All sheet music outputs
\include "../../lib/all_notation_outputs.ly"
% Slides output
\include "../../lib/slides_book_3verse.ly"
%% MIDI output
\include "../../lib/midi_output.ly"
