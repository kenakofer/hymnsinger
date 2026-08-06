%% Guitar lead sheets: melody, chord symbols, and a fretboard diagram row, at
%% the printed key plus the four transpositions (-guitar, -guitar-up1,
%% -guitar-up2, -guitar-dn1, -guitar-dn2).
%%
%% Songs without chords emit nothing here - see ht-song-has-chords? .
%%
%% predefined-guitar-fretboards.ly ships with LilyPond and carries the
%% standard grips for EADGBE tuning, so this book defines no diagrams of its
%% own. A chord with no predefined diagram still gets one: LilyPond computes a
%% playable fingering from the tuning. That file also registers barre shapes
%% via \addChordShape, which is what keeps the movable F and B-flat forms
%% looking like the ones people actually play.
\include "predefined-guitar-fretboards.ly"
\include "fret-books.ily"

%% No fingering numbers: six strings' worth of digits under a grid this size
%% reads as clutter rather than help. The uke books keep them - four strings
%% leave the room for it.
#(ht-fret-books "guitar" "guitar-tuning" 'none)
