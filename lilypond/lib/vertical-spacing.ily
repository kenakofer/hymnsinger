%% Opt-in vertical spacing controls.
%%
%% A song that sets nothing here gets LilyPond's defaults untouched. To use
%% them, define \spacing_overrides in the song, before the output includes:
%%
%%   spacing_overrides = \layout {
%%     \context { \Staff  \staffGap #10 }
%%     \context { \Lyrics \lyricsCentered #2 }
%%   }
%%
%% Distances are in staff-spaces.
%%
%% \staffGap governs the gap between two staves only when nothing sits between
%% them. In this repo's four-part scores a Lyrics context almost always does,
%% and then the lyrics' own nonstaff-* distances set the spacing and \staffGap
%% alone changes nothing at all -- even at absurd values, which makes it look
%% like the override never arrived. Reach for \lyricGap / \lyricGapFar (or
%% \lyricsCentered) there, and use \staffGap for the genuinely empty gaps.
%%
%% Every helper writes all four keys of the spacing alist, not just one. The
%% distances are measured between reference points, padding between the inked
%% outlines, and LilyPond honours whichever comes out larger -- so setting
%% basic-distance alone leaves padding as a floor underneath it, and the
%% distance you asked for quietly does not happen. That is the trap these
%% wrap. It is also why the \dropLyrics* helpers in hymn-common.ily cannot be
%% built on: they shift glyphs with extra-offset, which moves the ink without
%% telling the spacing engine anything, so the reserved space stays put.
%%
%% Nothing here is a floor at zero. Negative values overlap staves outright,
%% which is occasionally what a cramped system wants and is never what you
%% want by accident.

%% Distance to the next staff DOWN. Belongs on the upper staff of the pair.
staffGap =
#(define-music-function (dist) (number?)
   #{ \override VerticalAxisGroup.staff-staff-spacing =
        #`((basic-distance . ,dist) (minimum-distance . ,dist)
           (padding . 0) (stretchability . 0)) #})

%% Distance from a Lyrics line to the staff it is attached to, as named by
%% staff-affinity.
lyricGap =
#(define-music-function (dist) (number?)
   #{ \override VerticalAxisGroup.nonstaff-relatedstaff-spacing =
        #`((basic-distance . ,dist) (minimum-distance . ,dist)
           (padding . 0) (stretchability . 0)) #})

%% Distance from a Lyrics line to the staff on its far side.
lyricGapFar =
#(define-music-function (dist) (number?)
   #{ \override VerticalAxisGroup.nonstaff-unrelatedstaff-spacing =
        #`((basic-distance . ,dist) (minimum-distance . ,dist)
           (padding . 0) (stretchability . 0)) #})

%% Equal space above and below a line of lyrics sitting between two staves.
%%
%% staff-affinity #CENTER is the half that is easy to miss: with #UP or #DOWN
%% the far side is only ever a minimum, so the lyrics ride against their own
%% staff no matter what the two distances say. \globalLyrics already sets
%% #CENTER on every verse, so the inner verses are centred candidates that
%% only lack matching distances -- which is why their spacing looks arbitrary
%% until both sides are set together.
lyricsCentered =
#(define-music-function (dist) (number?)
   #{
     \override VerticalAxisGroup.staff-affinity = #CENTER
     \override VerticalAxisGroup.nonstaff-relatedstaff-spacing =
       #`((basic-distance . ,dist) (minimum-distance . ,dist)
          (padding . 0) (stretchability . 0))
     \override VerticalAxisGroup.nonstaff-unrelatedstaff-spacing =
       #`((basic-distance . ,dist) (minimum-distance . ,dist)
          (padding . 0) (stretchability . 0))
   #})

%% No default is defined for \spacing_overrides on purpose.
%% all-notation-outputs.ily emits its \layout hook only when a song has set
%% it, because substituting even an empty \layout variable perturbs the score
%% (see the comment there). Songs that want spacing define it; songs that do
%% not stay on the untouched code path, byte-for-byte.
