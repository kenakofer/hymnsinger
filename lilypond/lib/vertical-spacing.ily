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
%% To widen the gap between the two staves of a system, use \gapBetweenStaves.
%% It is the only helper here that does that, and it works regardless of what
%% sits in the gap -- lyrics, fretboards, or nothing.
%%
%% \staffGap is measured inert in this repo and documented as such at its
%% definition; it is not the tool for that job. \lyricGap does work, but it
%% moves the lyrics relative to their own staff rather than moving the staves
%% apart.
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
%% Zero behaves as a floor in practice. Padding is enforced between the inked
%% outlines and these helpers pin it at 0, so a negative distance buys nothing
%% -- the gap stops where the outlines touch. Going past that would mean
%% negative padding too, which is deliberately not offered: overlapping ink is
%% never what a hymn page wants.
%%
%% These control the space INSIDE a system. The space BETWEEN systems -- below
%% one system's bass staff and above the next system's treble -- is a \paper
%% property, not a context one; see \systemSpacing at the bottom of this file.

%% Distance to the next staff DOWN. Belongs on the upper staff of the pair.
%%
%% Measured inert in this repo's scores -- see \gapBetweenStaves below, which
%% is the one that actually moves them. staff-staff-spacing is only consulted
%% for a staff whose parent is a StaffGrouper, and fillTradScore puts its two
%% TradStaves loose in a << >> with no \new StaffGroup around them, so nothing
%% ever reads this property. Kept because a future score that does group its
%% staves would use it.
staffGap =
#(define-music-function (dist) (number?)
   #{ \override VerticalAxisGroup.staff-staff-spacing =
        #`((basic-distance . ,dist) (minimum-distance . ,dist)
           (padding . 0) (stretchability . 0)) #})

%% Distance between the two staves of a system -- the treble/bass pair and
%% everything hanging between them. This is the working "\systemSpacer": it
%% widens the gap whether lyrics sit in it, fretboards sit above it, or the
%% gap is empty.
%%
%% Goes on \Score, not \Staff:
%%
%%   spacing_overrides = \layout {
%%     \context { \Score \gapBetweenStaves #14 }
%%   }
%%
%% default-staff-staff-spacing is the fallback LilyPond uses for a staff with
%% no StaffGrouper parent, which is every staff in this repo -- so here the
%% "default" is not a default at all, it is the only one in play. That is why
%% this works where \staffGap does not.
%%
%% It sets the distance between the staves themselves, so anything between
%% them rides along inside the wider gap rather than being pushed by it. To
%% move lyrics relative to their own staff, use \lyricGap; to move the two
%% apart with the lyrics keeping their position, use this.
%%
%% Like everything here the distance is a floor, so a value under the gap the
%% contents already force does nothing -- which reads as the override being
%% ignored until you pass the threshold. Whatever is in the gap sets that
%% threshold, so it differs per book: on tis-a-gift the lyric-filled trad gap
%% is already ~15 and only starts moving at 16, while the uke book responds
%% from 0 up. Sweep a few values rather than concluding from one.
%%
%% Going too far costs a page rather than degrading gently (trad spills at 20
%% here), so raise it a little at a time and check the page count.
gapBetweenStaves =
#(define-music-function (dist) (number?)
   #{ \override VerticalAxisGroup.default-staff-staff-spacing =
        #`((basic-distance . ,dist) (minimum-distance . ,dist)
           (padding . 0) (stretchability . 0)) #})

%% Distance from a Lyrics line to the staff it is attached to, as named by
%% staff-affinity.
lyricGap =
#(define-music-function (dist) (number?)
   #{ \override VerticalAxisGroup.nonstaff-relatedstaff-spacing =
        #`((basic-distance . ,dist) (minimum-distance . ,dist)
           (padding . 0) (stretchability . 0)) #})

%% Equal space above and below a line of lyrics sitting between two staves.
%%
%% \globalLyrics already sets #CENTER on every verse, so the inner verses are
%% centred candidates that only lack matching distances.
%%
%% Only the relatedstaff half does any work here. nonstaff-unrelatedstaff-
%% spacing is inert in this repo at every value: fillTradScore nests the verse
%% Lyrics INSIDE the top staff's << >>, so it is a child of that staff rather
%% than a sibling sitting between two staves, and there is no "unrelated staff
%% on the far side" for the property to describe. It is set below anyway, to
%% keep this helper correct for a score that does stack its contexts that way.
%%
%% staff-affinity is NOT the reason, though it looks like the obvious suspect:
%% forcing the Lyrics to #UP or #DOWN and setting the far distance to 20 still
%% moves nothing. A \lyricGapFar helper wrapping that property alone used to
%% live here and was deleted 2026-08-11 for being inert -- do not reintroduce
%% it. To widen the gap between staves, use \gapBetweenStaves.
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

%% Spacing for ONE system, in the soprano part just before its \break.
%%
%% Everything above is score-wide: a \layout block cannot say "this system
%% only". Nor can a mid-music \override of these alists -- the page-layout
%% pass reads them once and never sees the change, so writing one into the
%% music stream silently does nothing at all. Per-system control has to go
%% through line-break-system-details on the column that carries the break,
%% which is a different property with a different shape.
%%
%% The argument is a LIST of the gaps between adjacent stacked contexts, top
%% to bottom, for the system AFTER this break. A four-part score with lyrics
%% between the staves stacks treble / lyrics / bass, so it takes two numbers:
%%
%%   \systemGaps #'(20 20) \break
%%
%% Count the contexts that actually print on that system, not the parts --
%% \RemoveAllEmptyStaves means a staff that falls silent is not in the stack
%% and does not get an entry. Too few numbers is not an error; the gaps you
%% did not name just keep their default, which looks like the override was
%% partly ignored.
%%
%% Goes in soprano only, like \break itself: these are Score-level.
%%
%% Reach for this LAST. It pins a fixed distance, which takes away the
%% compression LilyPond uses to fit a page, so on a page that is anywhere near
%% full it tends to force a second one -- and it does that even when there is
%% obvious free space, which makes the extra page look like a bug somewhere
%% else. On angels every value tried (14, 16, 18, alone and combined with a
%% tighter \systemSpacing) spilled to two pages, while the flexible \layout
%% helpers above got the same widening on one. Use those unless one system
%% genuinely has to differ from its neighbours.
systemGaps =
#(define-music-function (dists) (list?)
   #{ \once \override Score.NonMusicalPaperColumn.line-break-system-details =
        #`((alignment-distances . ,dists)) #})

%% Space BETWEEN systems: below one system's lowest staff, above the next
%% system's highest. Goes in a \paper block, not \spacing_overrides:
%%
%%   \paper { \systemSpacing #8 }
%%
%% placed before the output includes, like \spacing_overrides.
%%
%% This is the one to reach for when a page looks loosely stacked. It is a
%% different property from everything above -- \staffGap and friends only ever
%% move staves within one system, and no value of them closes the gap between
%% systems.
%%
%% It sets an upper bound, not the gap: anything hanging below a system
%% (lyrics, a slur that dips under the bass staff) keeps its own clearance, so
%% tightening past roughly 7 stops moving those gaps while the clean ones keep
%% closing, and the spacing goes deliberately uneven.
%%
%% Tightening here does buy room the rest of the page can spend -- that is how
%% angels affords its refrain margin. But the room only reaches things that are
%% still free to move: a gap already pressed against its own contents will not
%% grow just because the page has slack. Pair it with the \layout helpers above
%% rather than expecting it to loosen anything by itself.
systemSpacing =
#(define-scheme-function (dist) (number?)
   #{ \paper {
        system-system-spacing =
          #`((basic-distance . ,dist) (minimum-distance . ,dist)
             (padding . 0) (stretchability . 0))
      } #})

%% Which books a set of overrides applies to.
%%
%% \spacing_overrides alone reaches every book in the song, which is usually
%% what you want and is what most songs should keep using. When one book needs
%% different treatment, name it in \spacing_overrides_by_book instead -- an
%% alist keyed by the book's output suffix, the same names \-dht-books takes:
%%
%%   spacing_overrides = \layout {              %% all books ...
%%     \context { \Lyrics \lyricGap #8 }
%%   }
%%   spacing_overrides_by_book = #`(            %% ... except these
%%     ("slides" . #f)                          %% opts out entirely
%%     ("clairnote" . ,#{ \layout {
%%        \context { \Lyrics \lyricGap #4 } } #}))
%%
%% A book named here uses its own entry INSTEAD of \spacing_overrides, not in
%% addition to it. #f is how a book opts out -- NOT \layout { }, which still
%% emits a block and still perturbs the page for the reason spelled out in
%% all-notation-outputs.ily.
%%
%% Opting out is the common case for the slides book, which prints one verse
%% much larger and paginates a system per slide, and for the two shape-note
%% books, which run at a bigger staff zoom and sit close to the page bottom
%% already. Margin added for the notation books tends to cost those a page.
%%
%% Suffixes are the printed ones: "trad", "clairnote", "shapenote",
%% "4shapenote", "lead", "roman", "uke", "guitar", "slides", and the
%% transposed forms like "trad-up1". A name that matches no book is silently
%% ignored, so a typo reads as the override not applying.
#(define (ht-spacing-for suffix)
   "The \\layout this book should use: its own entry if it has one, otherwise
the song-wide \\spacing_overrides, otherwise #f.

#f means emit no \\layout at all, which is not the same as emitting an empty
one -- a \\layout holding only a substituted variable re-resolves \\Score from
the built-in defaults and perturbs the page (see all-notation-outputs.ily).
So a book opts out with #f, not with \\layout { }."
   (let* ((by-book (if (defined? 'spacing_overrides_by_book)
                       (ly:parser-lookup 'spacing_overrides_by_book)
                       '()))
          (hit (and (list? by-book) (assoc suffix by-book))))
     (cond
      (hit (cdr hit))
      ((defined? 'spacing_overrides) (ly:parser-lookup 'spacing_overrides))
      (else #f))))

%% The same lookup, as a snippet to splice into the books that build their
%% \score from a format string. Returns "" when the book has nothing to add,
%% so it is always safe to interpolate.
%%
%% It stashes the value in a parser variable rather than returning the \layout
%% itself: the books are re-parsed from strings, and a Scheme-local binding is
%% not visible to that parse. The variable is per-book and read immediately, so
%% the books cannot collide.
#(define (ht-spacing-snippet suffix)
   (let ((sp (ht-spacing-for suffix)))
     (if sp
         (begin
           (ly:parser-define! 'ht-this-book-spacing sp)
           "\\layout { $ht-this-book-spacing \\context { \\Score \\remove \"Bar_number_engraver\" } }")
         "")))

%% No default is defined for \spacing_overrides on purpose.
%% all-notation-outputs.ily emits its \layout hook only when a song has set
%% it, because substituting even an empty \layout variable perturbs the score
%% (see the comment there). Songs that want spacing define it; songs that do
%% not stay on the untouched code path, byte-for-byte.
