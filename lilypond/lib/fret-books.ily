%% Shared machinery for the fretted-instrument lead sheets.
%%
%% A fret book is the lead sheet plus a row of fretboard diagrams under the
%% chord symbols. Everything except the tuning and the predefined-diagram file
%% is instrument-independent, so this file holds the whole thing and each
%% instrument book is a two-line wrapper:
%%
%%   \include "predefined-ukulele-fretboards.ly"
%%   \include "fret-books.ily"
%%   #(ht-fret-books "uke" "ukulele-tuning")
%%
%% An optional third argument sets the fingering-number style; see
%% ht-fret-books below.
%%
%% A guitar book would differ only in those three tokens.

\include "transpose-common.ily"

%% Which chord music to diagram.
%%
%% Songs store their chords in one of two shapes. The common one is
%%
%%   songChords = \chords { ... }
%%
%% where \songChords is the music itself. The four songs with a capo line
%% instead build \songChords out of several \new ChordNames blocks and keep
%% the music in \chordSymbols, because each block has to reference it:
%%
%%   chordSymbols = \chordmode { ... }
%%   songChords = << \new ChordNames { \chordSymbols } \CP \new ChordNames { ... } >>
%%
%% FretBoards must be handed the raw chord events - give it a built ChordNames
%% context and it engraves an empty line, silently. So prefer \chordSymbols
%% and fall back to \songChords, which is exactly "the raw music, wherever
%% this song happens to keep it".
%%
%% hymn-common.ily defaults \chordSymbols to an empty sequential music, so
%% "did the song define it?" is "does it contain any events?".
#(define (ht-music-empty? m)
   (and (ly:music? m)
        (let ((elts (ly:music-property m 'elements))
              (elt (ly:music-property m 'element)))
          (and (null? elts) (not (ly:music? elt))))))

%% Strip the context wrappers off the chord music, leaving the bare events.
%%
%% \chords { ... } is not raw chord events - it is shorthand for
%% \new ChordNames \chordmode { ... }, and that ChordNames travels with the
%% music. Put it inside \new FretBoards and the inner context wins: you get a
%% second row of chord *names* where the diagrams should be, and LilyPond
%% reports nothing wrong. Only \chordmode { ... } is bare.
%%
%% 69 of the 73 songs with chords use the \chords form, so this is the common
%% path, not a corner case.
%%
%% Two wrappers have to come off, not one: \chords parses to
%% UnrelativableMusic wrapping ContextSpeccedMusic wrapping the events. A
%% check for context-specification alone matches the *inner* node and never
%% fires, because the outer one is a plain music wrapper - which looks like it
%% works right up until you notice the diagrams are still names. Descend
%% through both kinds until neither applies.
#(define (ht-strip-context m)
   (if (and (ly:music? m)
            (or (music-is-of-type? m 'context-specification)
                (music-is-of-type? m 'music-wrapper-music))
            (ly:music? (ly:music-property m 'element)))
       (ht-strip-context (ly:music-property m 'element))
       m))

%% Flatten slash chords to root position, for the fret books only.
%%
%% G/B, C/E, F/C and friends are written for a keyboard's left hand or a bass
%% player. Ask FretBoards for one and the diagram comes out wrong rather than
%% merely awkward: LilyPond insists on placing the named bass on the lowest
%% sounding string, and when no playable grip satisfies that it drops chord
%% tones instead of giving up. G/B on guitar engraves as three notes with the
%% bottom three strings muted; Am/C on ukulele engraves as an empty grid with
%% no stopped strings at all, and the run only warns "No string for pitch".
%% A guitarist strumming from these charts wants the plain triad anyway - the
%% inversion is the other instrument's business - so drop it from both the
%% diagram and the printed name.
%%
%% \chordmode encodes the two slash forms differently, and they need different
%% repairs:
%%
%%   c/e  - an *inversion*. The E is an existing chord tone tagged
%%          'inversion, and the notes below it were moved down an octave
%%          ('octavation -1) to put it at the bottom. Dropping the tagged note
%%          alone would leave a chord missing its root, so the octavation has
%%          to be undone on the survivors as well.
%%
%%   c/+e - an *added bass*. The E is tagged 'bass and the triad above it is
%%          untouched, so the note simply comes off.
%%
%% The inversion note cannot simply be deleted, because in hymn slash chords it
%% is nearly always a chord tone that appears only once: the B of G/B is the
%% third of G, so deleting it leaves G-D, and LilyPond dutifully names that
%% G5 - a power chord, which is not the harmony and not what anyone wants to
%% strum. So an inversion note is *raised* back into the chord (undoing its
%% octavation like every other survivor) and only dropped when some other note
%% already carries that pitch class, which is the one case where keeping it
%% would double a tone.
%%
%% An added-bass note is genuinely extra and always comes off.
%%
%% Both tags live on the NoteEvents inside an EventChord, so this rewrites
%% each chord's element list and leaves every other music type alone.
#(define (ht-unoctavate! n)
   (let ((oct (ly:music-property n 'octavation #f))
         (p (ly:music-property n 'pitch #f)))
     (if (and (number? oct) (not (zero? oct)) (ly:pitch? p))
         (begin
           (ly:music-set-property!
            n 'pitch (ly:pitch-transpose p (ly:make-pitch (- oct) 0 0)))
           (ly:music-set-property! n 'octavation 0))))
   n)

#(define (ht-root-position-chord! ev)
   (let ((notes (ly:music-property ev 'elements)))
     (if (pair? notes)
         (let* ((plain (remove (lambda (n)
                                 (or (ly:music-property n 'inversion #f)
                                     (ly:music-property n 'bass #f)))
                               notes))
                (inv (filter (lambda (n) (ly:music-property n 'inversion #f))
                             notes))
                (classes (filter-map
                          (lambda (n)
                            (let ((p (ly:music-property n 'pitch #f)))
                              (and (ly:pitch? p) (ly:pitch-notename p))))
                          plain))
                (extra (remove (lambda (n)
                                 (let ((p (ly:music-property n 'pitch #f)))
                                   (and (ly:pitch? p)
                                        (memv (ly:pitch-notename p) classes))))
                               inv))
                (keep (append plain extra)))
           ;; Fire whenever the chord carried a slash at all, not only when a
           ;; note came off: the common case keeps every note and still needs
           ;; the octavation undone and the 'inversion tag cleared, or the
           ;; name prints its slash and the diagram stays inverted.
           (if (and (pair? keep) (< (length plain) (length notes)))
               (begin
                 (for-each (lambda (n)
                             (ly:music-set-property! n 'inversion #f)
                             (ly:music-set-property! n 'bass #f))
                           keep)
                 ;; Sort low-to-high. Un-octavating restores the right pitches
                 ;; but leaves them in the inversion's order, and both
                 ;; consumers read position, not pitch: FretBoards treats the
                 ;; first note as the bass and hunts for a grip with that note
                 ;; lowest, so a G/B left in place asks for a D-bass voicing
                 ;; and misses the predefined open G entirely. Sorting makes
                 ;; the event indistinguishable from a plain \chordmode g.
                 (ly:music-set-property!
                  ev 'elements
                  (sort (map ht-unoctavate! keep)
                        (lambda (x y)
                          (let ((px (ly:music-property x 'pitch #f))
                                (py (ly:music-property y 'pitch #f)))
                            (and (ly:pitch? px) (ly:pitch? py)
                                 (ly:pitch<? px py)))))))))))
   ev)

#(define (ht-root-position m)
   (music-map
    (lambda (n)
      (if (music-is-of-type? n 'event-chord)
          (ht-root-position-chord! n)
          n))
    m))

htChordMusic =
#(define-music-function (symbols chords) (ly:music? ly:music?)
   (ht-root-position
    (ly:music-deep-copy
     (ht-strip-context (if (ht-music-empty? symbols) chords symbols)))))

%% Does this song have chords at all?
%%
%% The fret books only make sense where chords exist; the ~130 songs without
%% them would otherwise emit a book with an empty diagram row above an empty
%% chord line. Rather than gate in the shell (which would have to parse .ly
%% files to find out), each song decides for itself at parse time and simply
%% emits no book when it has none. A missing PDF is what the site checks.
#(define (ht-song-has-chords? symbols chords)
   (not (and (or (not (ly:music? symbols)) (ht-music-empty? symbols))
             (or (not (ly:music? chords)) (ht-music-empty? chords)))))

%% Emit the five books for one instrument: the printed key plus the same four
%% transpositions the trad book offers.
%%
%% The transposition pair comes from \htTransposeFrom / \htTransposeTo exactly
%% as in transposed-books.ily - same derivation, same minor/modal handling.
%% The capoOnly tag is stripped from every book here, including the untransposed
%% one: a capo instruction and a fretboard diagram are two answers to the same
%% question, and printing both invites playing the chart twice-shifted.
%%
%% Built as a string and re-parsed for the same reason transposed-books.ily
%% does it: \bookOutputSuffix is a parse-time setting on the enclosing \book,
%% and a \book is not a music expression, so it cannot be produced from a
%% Scheme loop over book objects.
#(define (ht-fret-book suffix tuning finger-code shift)
   (format #f "
\\book {
  \\prescore_text
  \\bookOutputSuffix \"~a\" \\score {
    \\removeWithTag #'(midionly slidesOnly capoOnly)
    ~a
    \\fillFretLeadSheetScore
      { \\removeWithTag #'(midionly slidesOnly) \\soprano }
      { \\htChordMusic \\chordSymbols \\songChords }
      #~a
      #'~a
      \\tradLeadSheetStaffZoom
    ~a
  }
  \\postscore_text
  \\extra_verses
}
"
           suffix
           (if (= shift 0)
               ""
               (format #f "\\transpose \\htTransposeFrom \\hymnKey \\htTransposeTo \\hymnKey #~a"
                       shift))
           tuning
           finger-code
           (ht-spacing-snippet suffix)))

%% NAME is the book's base output suffix ("uke"); the transposed ones append
%% the same -up1/-up2/-dn1/-dn2 the trad books use, so the site's transpose
%% control needs no per-instrument special casing.
%%
%% FINGER-CODE is optional and defaults to 'below-string, LilyPond's own
%% default: a fingering number under each string. Pass 'none to drop them.
%% Guitar does - six strings of digits under an already-dense grid is noise,
%% where four strings have the room for it.
%%
%% Call this from a bare top-level #(...), never from a music function.
%% ly:parser-include-string splices at the parser's current position, and
%% inside a music function that position is mid-expression - the \book that
%% comes out lands where a music expression was expected and the parse
%% desyncs, taking the *next* \include down with it. The books still get
%% written before it fails, which makes the breakage look unrelated to this
%% file. transposed-books.ily calls its generator the same way.
#(define* (ht-fret-books name tuning #:optional (finger-code 'below-string))
   (if (ht-song-has-chords? (ly:parser-lookup 'chordSymbols)
                            (ly:parser-lookup 'songChords))
       (for-each
        (lambda (spec)
          (let ((suffix (if (string=? (car spec) "")
                            name
                            (string-append name (car spec)))))
            (if (ht-book? suffix)
                (ly:parser-include-string
                 (ht-fret-book suffix tuning finger-code (cdr spec))))))
        '(("" . 0) ("-up1" . 1) ("-up2" . 2) ("-dn1" . -1) ("-dn2" . -2)))))
