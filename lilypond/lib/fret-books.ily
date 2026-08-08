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

htChordMusic =
#(define-music-function (symbols chords) (ly:music? ly:music?)
   (ht-strip-context (if (ht-music-empty? symbols) chords symbols)))

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
