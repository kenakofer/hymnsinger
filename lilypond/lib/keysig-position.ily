%% Reports landmark positions in each engraving, for the song pages to hang UI
%% on: the first key signature (the transpose arrows point at it) and the end
%% of the last system (autoscroll needs to know where the music stops).
%%
%% Runs inside the ordinary PDF/PNG pass. The obvious alternative - render SVG
%% and read the coordinates out of it - costs more than twice the build again:
%% the SVG backend cannot share a run with the PDF one (--formats=pdf,png,svg
%% silently emits no SVG at all), so it would mean a second full parse and
%% layout. Here the numbers are already computed and the callbacks only read
%% them, so the cost is not measurable.
%%
%% Switched on with -dht-landmarks=<file>, which is also where the output goes.
%% Not stdout: the build runs LilyPond with -s, which suppresses ly:message
%% entirely. One line per book per landmark,
%%
%%   <book> keysig <x> <y> <w> <h>
%%   <book> lastbar <x> <y> <w> <h>
%%
%% as fractions of the page - independent of -dresolution, and directly what
%% the page CSS wants. scripts/extract-keysig.py collects them.
%%
%% The geometry, since it is not obvious:
%%   - Grob Y grows upward and page y downward, so converting one to the other
%%     is a reflection. It is anchored on the *system* top rather than the
%%     staff, which is what absorbs whatever sits above the staff inside the
%%     system (titles, a previous verse's lyrics) and varies per book.
%%   - A grob's Y extent is padded well beyond its ink, so boxes come from the
%%     grob's *stencil*. Stencil coordinates are local, offset from the grob's
%%     lower Y extent.
%%   - A multi-page score is vertically appended into one PNG by the build, so
%%     a landmark on page N is offset by the N-1 pages above it. Fractions are
%%     therefore of the *whole strip*, not of one page.

%% Switched on by -dht-landmarks. Not declared with ly:add-option on purpose:
%% ly:get-option answers #f for a name it has never seen and -d sets it
%% regardless, so declaring buys nothing and would have to be guarded against
%% running twice.

#(define ht:keysig #f)
#(define ht:staff #f)
#(define ht:bars '())
#(define ht:page-count 0)

#(define (ht:on?) (ly:get-option 'ht-landmarks))

%% -d hands the value over as a symbol, or as a string if it was quoted.
#(define (ht:option->string v)
   (cond ((string? v) v)
         ((symbol? v) (symbol->string v))
         (else (format #f "~a" v))))

%% Wired in unconditionally by hymn-common.ily, so they check the option
%% themselves: with it off this is one boolean per grob, which is as close to
%% free as a callback gets.
#(define (ht:grab-keysig grob)
   ;; First one wins: a mid-piece key change is not what the arrows point at,
   ;; and the first is on the first system by construction.
   ;;
   ;; Two grobs are skipped rather than measured:
   ;;
   ;; An empty alteration-alist means nothing is drawn - C major has no
   ;; accidentals to print - though the grob and a stencil still exist.
   ;;
   ;; A cancellation is the old key being struck out, not the new one.
   (if (and (ht:on?)
            (not ht:keysig)
            (pair? (ly:grob-property grob 'alteration-alist))
            (not (grob::has-interface grob 'key-cancellation-interface)))
       (set! ht:keysig grob))
   '())

#(define (ht:grab-staff grob)
   (if (and (ht:on?) (not ht:staff))
       (set! ht:staff grob))
   '())

#(define (ht:grab-bar grob)
   ;; Every bar line is kept; the last system's rightmost is picked at the end,
   ;; when the systems have been placed and can be compared.
   (if (ht:on?)
       (set! ht:bars (cons grob ht:bars)))
   '())

%% A grob's box on the page, in staff spaces from the paper's top-left.
%% Returns (x0 y0 x1 y1), or #f when the grob draws nothing.
%%
%% The grob's extent *in the system* is already the drawn box - it and the
%% stencil's own extent are the same rectangle, related by a pure translation
%% (verified: both 4.45999 tall for a three-flat signature, differing by a
%% constant). Combining the two, which is the tempting reading of "stencil
%% coordinates are local", double-counts that translation. It survives in
%% standard notation because the numbers happen to be close, but it puts
%% Clairnote's signature - whose stencil is built and shifted by a callback of
%% its own - about 190px too high, up on the credit line.
#(define (ht:ink-box grob sys layout sys-y)
   (if (not (ly:stencil? (ly:grob-property grob 'stencil)))
       #f
       (let* ((gx (ly:grob-extent grob sys X))
              (gy (ly:grob-extent grob sys Y))
              (lm (ly:output-def-lookup layout 'left-margin))
              (tm (ly:output-def-lookup layout 'top-margin))
              ;; Grob Y grows upward and page y downward, so the conversion is
              ;; a reflection. The reference is the system's own top extent
              ;; plus where the page placed the system, which together absorb
              ;; whatever sits above the staff inside the system (titles, a
              ;; previous verse's lyrics) and vary per book.
              (sys-y-ext (ly:grob-extent sys sys Y))
              (sys-top (cdr sys-y-ext))
              (origin (+ tm sys-y (- sys-top))))
         (list (+ lm (car gx))
               (- origin (cdr gy))
               (+ lm (cdr gx))
               (- origin (car gy))))))

#(define (ht:emit port book what box pw ph page-index)
   ;; page-index shifts a landmark down by the pages stacked above it, since
   ;; the build appends the pages into a single image.
   (if box
       (let* ((x0 (list-ref box 0))
              (y0 (+ (list-ref box 1) (* page-index ph)))
              (x1 (list-ref box 2))
              (y1 (+ (list-ref box 3) (* page-index ph)))
              (total (* ph (max 1 ht:page-count))))
         (format port "~a ~a ~a ~a ~a ~a\n"
                 book what
                 (exact->inexact (/ x0 pw))
                 (exact->inexact (/ y0 total))
                 (exact->inexact (/ (- x1 x0) pw))
                 (exact->inexact (/ (- y1 y0) total))))))

%% Which page a system landed on, zero-based, and that page's placement
%% offset for the system's slot.
%%
%% The system knows its own page-number, which is 1-based. Matching it against
%% the page list by identity does not work: a page's 'lines are probs, not the
%% grobs ly:grob-system hands back, so eq? never fires and every lookup fails
%% silently - which is what left lastbar unreported at first.
#(define (ht:system-page sys pages)
   (let* ((n (ly:grob-property sys 'page-number))
          (i (if (number? n) (max 0 (1- n)) 0))
          (page (if (< i (length pages)) (list-ref pages i) (car pages)))
          (conf (ly:prob-property page 'configuration)))
     ;; A page holds several systems and 'configuration lists their offsets in
     ;; order. Without knowing this system's index within the page the best
     ;; available answer is the last slot, which is the right one for the final
     ;; system - the only one this is asked about.
     (cons i (if (pair? conf) (car (last-pair conf)) 0))))

#(define (ht:report layout pages book)
   (let* ((pw (ly:output-def-lookup layout 'paper-width))
          (ph (ly:output-def-lookup layout 'paper-height))
          ;; -d gives the value as a symbol, so it needs converting before it
          ;; can name a file. Appended, so the nine books of a song accumulate
          ;; into one file: open-file with "a" refuses to create it, and plain
          ;; `open` is shadowed by LilyPond's \open articulation.
          (port (fdes->outport
                 (open-fdes (ht:option->string (ly:get-option 'ht-landmarks))
                            (logior O_WRONLY O_APPEND O_CREAT)
                            #o644))))
     (set! ht:page-count (length pages))
     ;; The key signature is on the first system, so the first page's own
     ;; placement offset is the one that applies. Clairnote is included: it
     ;; draws its own notation rather than accidentals, but that is still a
     ;; key signature sitting where one belongs, and measuring the grob rather
     ;; than reconstructing from its stencil gets it right.
     ;; The first staff's own box, in the same frame as the landmarks. The
     ;; page-space y this produces is wrong by the height of the title block -
     ;; see the note on ht:ink-box - but every landmark is wrong by the *same*
     ;; amount, so publishing the staff lets the merge step correct all of them
     ;; from one measurement: it finds the first staff line in the built PNG
     ;; and shifts everything by the difference.
     (if (and ht:staff (pair? pages))
         (let* ((sys (ly:grob-system ht:staff))
                (conf (ly:prob-property (car pages) 'configuration))
                (sys-y (if (pair? conf) (car conf) 0)))
           (ht:emit port book "staffref"
                    (ht:ink-box ht:staff sys layout sys-y) pw ph 0)))
     (if (and ht:keysig ht:staff (pair? pages))
         (let* ((sys (ly:grob-system ht:staff))
                (conf (ly:prob-property (car pages) 'configuration))
                (sys-y (if (pair? conf) (car conf) 0)))
           (ht:emit port book "keysig"
                    (ht:ink-box ht:keysig sys layout sys-y) pw ph 0)))
     ;; The last bar line. Each system has its own placement offset within its
     ;; page, so every candidate is resolved against the page it actually sits
     ;; on before they are compared - otherwise a two-page score measures the
     ;; final system against the first page's spacing.
     (if (and (pair? ht:bars) (pair? pages))
         (let ((best #f) (best-page 0))
           (for-each
            (lambda (b)
              (let* ((bs (ly:grob-system b))
                     (where (ht:system-page bs pages)))
                (if where
                    (let ((box (ht:ink-box b bs layout (cdr where))))
                      (if box
                          ;; Furthest down wins; ties break to the right, which
                          ;; is the final bar line of that system.
                          (let ((depth (+ (list-ref box 3) (* (car where) ph)))
                                (best-depth (if best
                                                (+ (list-ref best 3)
                                                   (* best-page ph))
                                                -1)))
                            (if (or (not best)
                                    (> depth best-depth)
                                    (and (= depth best-depth)
                                         (> (list-ref box 2) (list-ref best 2))))
                                (begin (set! best box)
                                       (set! best-page (car where))))))))))
            ht:bars)
           (ht:emit port book "lastbar" best pw ph best-page)))
     (close-port port)))

%% Ready to drop into \paper.
#(define (ht:page-post-process layout pages)
   (if (ht:on?)
     (let ((book (ly:output-def-lookup layout 'output-suffix "trad")))
       ;; The projection slides are not a score anything anchors to, and they
       ;; run to a dozen pages, so they would otherwise contribute a dozen
       ;; useless lines per song.
       (if (not (string-prefix? "slides" (ht:option->string book)))
           (ht:report layout pages book))
       ;; Cleared so the next book starts empty rather than reporting this
       ;; book's numbers for all nine.
       (set! ht:keysig #f)
       (set! ht:staff #f)
       (set! ht:bars '()))))
