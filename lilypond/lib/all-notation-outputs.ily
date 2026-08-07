%% Which notation books this run emits.
%%
%% Default is all of them, exactly as before. Pass -dht-books=<list> to emit a
%% subset:
%%
%%   lilypond -dht-books=transposed ...   # just the four \transpose books
%%   lilypond -dht-books=trad,lead  ...   # two specific books
%%   lilypond -dht-books=all        ...   # same as omitting it
%%
%% This exists because a change is usually confined to a few books. The
%% minor-key spelling fix touched only the transposed books, yet rebuilding
%% meant re-engraving all nine per song - and engraving is nearly the whole
%% cost of a build. Names are the output suffixes, plus "transposed" as
%% shorthand for the four \transpose books.
%%
%% The gating is a conditional \include rather than a conditional \book: a
%% \book is not a music expression, so wrapping one in #(if ...) #{ ... #}
%% silently discards it and emits nothing at all. Including the file or not is
%% the mechanism that works.
%%
%% Skipping a book does NOT remove output it produced earlier. A partial run
%% leaves the other files on disk, untouched and possibly stale - that is the
%% point, but it makes the caller responsible for knowing they are still
%% valid. generate-all-outputs.sh tracks that with the .inputhash stamp, and
%% deliberately does not write one after a partial build.

#(define ht-book-selection
   (let ((opt (ly:get-option 'ht-books)))
     (cond
      ((not opt) 'all)
      ((eq? opt #t) 'all)
      (else
       (let* ((s (if (symbol? opt) (symbol->string opt) (format #f "~a" opt)))
              ;; Split on commas by hand; 2.22 does not expose string-split here.
              (parts (let loop ((chars (string->list s)) (cur '()) (acc '()))
                       (cond
                        ((null? chars)
                         (reverse (if (null? cur)
                                      acc
                                      (cons (list->string (reverse cur)) acc))))
                        ((char=? (car chars) #\,)
                         (loop (cdr chars) '()
                               (if (null? cur)
                                   acc
                                   (cons (list->string (reverse cur)) acc))))
                        (else (loop (cdr chars) (cons (car chars) cur) acc))))))
         (if (member "all" parts) 'all parts))))))

#(define (ht-book? name)
   "Should the book with output suffix NAME be emitted this run?"
   (or (eq? ht-book-selection 'all)
       (and (member name ht-book-selection) #t)
       ;; "transposed" is shorthand for every \transpose book, trad and fret
       ;; alike. A fret instrument's own name means its whole family, since
       ;; the five are one feature and are almost never wanted apart.
       (and (member "transposed" ht-book-selection)
            (member name '("trad-up1" "trad-up2" "trad-dn1" "trad-dn2"
                           "lead-up1" "lead-up2" "lead-dn1" "lead-dn2"
                           "uke-up1" "uke-up2" "uke-dn1" "uke-dn2"
                           "guitar-up1" "guitar-up2" "guitar-dn1" "guitar-dn2"))
            #t)
       (and (member "lead" ht-book-selection)
            (member name '("lead-up1" "lead-up2" "lead-dn1" "lead-dn2"))
            #t)
       (and (member "uke" ht-book-selection)
            (member name '("uke-up1" "uke-up2" "uke-dn1" "uke-dn2"))
            #t)
       (and (member "guitar" ht-book-selection)
            (member name '("guitar-up1" "guitar-up2" "guitar-dn1" "guitar-dn2"))
            #t)))

%% Warn on a name that matches nothing, so a typo fails loudly instead of
%% quietly producing an empty build that then gets cached as good.
#(if (not (eq? ht-book-selection 'all))
     (let ((known '("trad" "clairnote" "shapenote" "4shapenote" "lead"
                    "trad-up1" "trad-up2" "trad-dn1" "trad-dn2" "transposed"
                    "lead-up1" "lead-up2" "lead-dn1" "lead-dn2"
                    "uke" "uke-up1" "uke-up2" "uke-dn1" "uke-dn2"
                    "guitar" "guitar-up1" "guitar-up2" "guitar-dn1"
                    "guitar-dn2" "roman")))
       (for-each
        (lambda (n)
          (if (not (member n known))
              (ly:warning "ht-books: unknown book ~a (known: ~a)" n known)))
        ht-book-selection)
       (ly:message "  [ht] books this run: ~a" ht-book-selection)))

%% A string include resolves against the process CWD, not against this file,
%% so relative-includes does not help here - spell the path out absolutely,
%% derived from wherever this .ily actually lives.
#(define ht-lib-dir
   (dirname (car (ly:input-file-line-char-column (*location*)))))

#(define (ht-include-book name file)
   (if (ht-book? name)
       (ly:parser-include-string
        (format #f "\\include \"~a/~a\"" ht-lib-dir file))))

#(ht-include-book "trad" "traditional-book.ily")
#(ht-include-book "clairnote" "clairnote-book.ily")

%% The lead sheet is a family of five now, like the fret books, and does its
%% own per-book gating inside the file - so include it whenever any of the
%% five is wanted, not just the base name.
#(if (or (ht-book? "lead") (ht-book? "lead-up1") (ht-book? "lead-up2")
         (ht-book? "lead-dn1") (ht-book? "lead-dn2"))
     (ly:parser-include-string
      (format #f "\\include \"~a/lead-sheet-book.ily\"" ht-lib-dir)))

%% The shape-note books set hs-active-shapes on entry and reset it on exit,
%% both inside their own file - so skipping the file skips the pair and the
%% variable stays at its #f default. Nothing leaks into the books that follow.
#(ht-include-book "shapenote" "shapenote-book.ily")
#(ht-include-book "4shapenote" "four-shapenote-book.ily")

%% transposed-books.ily holds all four \transpose books and does its own
%% per-book gating, so it is included whenever any of them is wanted.
#(if (or (ht-book? "trad-up1") (ht-book? "trad-up2")
         (ht-book? "trad-dn1") (ht-book? "trad-dn2"))
     (ly:parser-include-string
      (format #f "\\include \"~a/transposed-books.ily\"" ht-lib-dir)))

%% Same arrangement for each fretted instrument: one file, five books, its own
%% gating - plus it emits nothing at all for a song with no chords.
#(if (or (ht-book? "uke") (ht-book? "uke-up1") (ht-book? "uke-up2")
         (ht-book? "uke-dn1") (ht-book? "uke-dn2"))
     (ly:parser-include-string
      (format #f "\\include \"~a/ukulele-book.ily\"" ht-lib-dir)))

#(if (or (ht-book? "guitar") (ht-book? "guitar-up1") (ht-book? "guitar-up2")
         (ht-book? "guitar-dn1") (ht-book? "guitar-dn2"))
     (ly:parser-include-string
      (format #f "\\include \"~a/guitar-book.ily\"" ht-lib-dir)))

%% The Roman numeral sheet is a single book with no transposed siblings - a
%% numeral is already relative to the tonic, so transposing would reprint the
%% same page. It gates itself on the song having chords, like the fret books.
#(ht-include-book "roman" "roman-book.ily")
