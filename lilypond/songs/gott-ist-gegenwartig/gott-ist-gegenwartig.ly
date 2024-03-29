\version "2.22.1"
#(ly:set-option 'relative-includes #t)
\include "../../lib/hymn-common.ily"

%% TUNE INFO
\include "../../shared-tunes/wunderbarer-konig.ily"

%% SONG INFO
title = \titleText "Gott ist gegenwärtig"
subtitle = \smallText "See also in English: God is here among us"
poet = \smallText "Text: Gerhard Tersteegen, 1729"
typesetter = "Kenan Schaefkofer"
verseCount = 3
tags = "german christian 4part"
dateAdded = "2021-03-04"
\include "../../lib/header.ily"

%% LYRICS
verseA = \lyricmode {
  \l Gott ist ge -- gen -- wär -- tig. Las -- set uns an -- be -- ten und in Ehr -- furcht vor ihn tre -- ten.
  \l Gott ist in der Mit -- te. Al -- les in uns schwei -- ge und sich in -- nigst vor ihm beu -- ge.
  \l Wer ihn kennt, wer ihn nennt, schlag die Au -- gen nie -- der; kommt, er -- gebt euch wie -- der.
}
verseB = \lyricmode {
  Gott ist ge -- gen -- wär -- tig, dem die Che -- ru -- bi -- nen Tag und Nacht ge -- bü -- cket die -- nen.
  ''Hei -- lig, hei -- lig, hei -- lig!'' sin -- gen ihm zur Eh -- re al -- ler En -- gel ho -- he Chö -- re.
  Herr, ver -- nimm uns -- re Stimm, da auch wir Ge -- rin -- gen uns -- re Op -- fer brin -- gen.
}
verseC = \lyricmode {
  Herr, komm in mir woh -- nen; lass mein Herz auf Er -- den dir ein Hei -- lig -- tum noch wer -- den.
  Komm, du na -- hes Wes -- en; dich in mir ver -- klä -- re, dass ich dich stets lieb und eh -- re.
  Wo ich geh, sitz und steh, lass mich dich er -- blick -- en und vor dir mich bü -- cken.
}

% Set up music-aligned verses. Change to the correct number
\include "../../lib/3verse.ily"

%% All sheet music outputs
\include "../../lib/all-notation-outputs.ily"
% Slides output
\include "../../lib/slides-book-3verse.ily"
%% MIDI output
\include "../../lib/midi-output.ily"
