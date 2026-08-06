%% Ukulele lead sheets: melody, chord symbols, and a fretboard diagram row,
%% at the printed key plus the four transpositions (-uke, -uke-up1, -uke-up2,
%% -uke-dn1, -uke-dn2).
%%
%% Songs without chords emit nothing here - see ht-song-has-chords? .
%%
%% predefined-ukulele-fretboards.ly ships with LilyPond and carries the
%% standard grips for GCEA tuning, so this book does not define any diagrams
%% of its own. A chord with no predefined diagram still gets one: LilyPond
%% computes a playable fingering from the tuning.
\include "predefined-ukulele-fretboards.ly"
\include "fret-books.ily"

#(ht-fret-books "uke" "ukulele-tuning")
