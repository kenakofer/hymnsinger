%% Roman numeral score: the full four-part engraving with each chord named by
%% its scale degree rather than by letter (-roman).
%%
%% Songs without chords emit nothing here - a numeral book with no numerals in
%% it is just the trad book, which already exists. Same test the fret books
%% use, so the site's "does this file exist?" check works the same way.
%%
%% Unlike every other chord book this one has no transpositions. A numeral says
%% where a chord sits relative to the tonic, and that does not change when the
%% music moves - all five books would be the same page. The site hides the
%% transpose control on this view for the same reason.
%%
%% It says the degree and the chord quality, and nothing else. An earlier
%% version added figured-bass digits for inversions (V65, I64); they were
%% dropped on purpose. The letter books this sits beside print the chord and
%% leave the bass to the staff, and matching them keeps one vocabulary across
%% the Chords tab instead of two.
\include "transpose-common.ily"
\include "fret-books.ily"

%% Numeral and accidental for a root, by its distance in semitones above the
%% tonic. Chromatic roots are spelled as an alteration of the nearest natural
%% degree, flat-side, which is how they are usually written: an E-flat chord in
%% G is bVI, not #V.
%%
%% Keyed by semitone rather than by note name so enharmonics land together -
%% a song may spell the same chord af or gs depending on where it came from,
%% and both mean the same degree.
#(define ht-roman-degrees
   '((0  . ("I"   . 0))   (1  . ("II"  . -1)) (2  . ("II"  . 0))
     (3  . ("III" . -1))  (4  . ("III" . 0))  (5  . ("IV"  . 0))
     (6  . ("V"   . -1))  (7  . ("V"   . 0))  (8  . ("VI"  . -1))
     (9  . ("VI"  . 0))   (10 . ("VII" . -1)) (11 . ("VII" . 0))))

%% The chord's pitches as semitone offsets above its own root, deduplicated and
%% sorted, so quality can be read off by looking for particular intervals.
#(define (ht-roman-intervals pitches root)
   (sort (delete-duplicates
          (map (lambda (p) (modulo (- (ly:pitch-semitones p)
                                      (ly:pitch-semitones root)) 12))
               pitches))
         <))

%% Augmented is checked before major because it contains a major third too, and
%% diminished before minor for the same reason. A chord with neither third is
%% suspended; anything left over is called major, which is what an unadorned
%% root with a fifth means.
#(define (ht-roman-quality iv)
   (cond ((and (memv 4 iv) (memv 8 iv) (not (memv 7 iv))) 'aug)
         ((and (memv 3 iv) (memv 6 iv)) 'dim)
         ((memv 4 iv) 'major)
         ((memv 3 iv) 'minor)
         ((or (memv 5 iv) (memv 2 iv)) 'sus)
         (else 'major)))

%% The modifier printed after the numeral.
%%
%% Deliberately the same vocabulary the letter chords use - the strings are the
%% ones in lib/global-chord-symbols.ily, plus Ignatzek's m and aug. A reader
%% switching between the Gtr/Uke sheets and this one should meet the same words
%% for the same chords; "dim" here and "°" there is a second notation to learn
%% for no gain. Minor is the exception, and only because the lowercase numeral
%% has already said it.
%%
%% Inversions are not shown. A slash chord prints as its root numeral, exactly
%% as the letter books print the chord and leave the bass to the staff.
#(define (ht-roman-modifier iv q)
   (cond ((eq? q 'dim) (if (memv 9 iv) "dim7" "dim"))
         ((eq? q 'aug) "aug")
         ((eq? q 'sus) (if (memv 10 iv) "sus7" "sus"))
         ((memv 11 iv) "maj7")
         ;; A minor seventh is m7 in the letter books; the lowercase numeral
         ;; carries the m, so only the 7 is left to print.
         ((memv 10 iv) "7")
         (else "")))

%% The chord namer itself, closed over the tonic to measure degrees from.
%%
%% This is a chordNameFunction, not a chordRootNamer: a numeral needs the root
%% and the chord quality together (case carries major vs minor), and the root
%% namer only ever sees the root pitch.
%%
%% Returning it from a closure rather than reading the tonic from a context
%% property is deliberate - a custom context property would have to be
%% registered with translator-property-description, which is private to
%% LilyPond's own module and not reachable from an .ily.
#(define ((ht-roman-namer tonic) pitches bass inversion context)
   (let* ((root (car pitches))
          (deg (assv-ref ht-roman-degrees
                         (modulo (- (ly:pitch-semitones root)
                                    (ly:pitch-semitones tonic)) 12)))
          (numeral (car deg))
          (alt (cdr deg))
          (iv (ht-roman-intervals pitches root))
          (q (ht-roman-quality iv))
          ;; Case carries major/minor; dim and aug name themselves.
          (base (if (memq q '(minor dim)) (string-downcase numeral) numeral))
          (sup (ht-roman-modifier iv q)))
     ;; Serif, bold, for the whole name at once so the numeral, its accidental
     ;; and the figures all share it. \roman is LilyPond's name for the serif
     ;; family - the coincidence with Roman numerals is not the reason for it.
     ;;
     ;; Roman numerals are letterforms doing a
     ;; number's job, and the sans face the other chord books use leaves I, II
     ;; and III as bare strokes that read as tally marks; serifs cap them and
     ;; make the count legible at a glance. Set here rather than as a ChordName
     ;; font-family override because the accidental glyphs come from the music
     ;; font and must not be switched with them.
     (make-bold-markup
      (make-roman-markup
       (make-line-markup
        (append
         (if (= alt 0)
             '()
             (list (markup #:hspace 0 #:normal-text (if (< alt 0) "♭" "♯"))))
         (list (markup base))
         (if (string-null? sup) '() (list (make-super-markup (markup sup))))))))))

%% Numerals are counted from the relative major, so a G minor song reads
%% Gm = vi rather than i. That matches how transpose-common.ily already reasons
%% about every key in this corpus, and it means the modal songs need no special
%% casing: the numeral follows the signature, whatever mode sits on top of it.
htRomanTonic =
#(define-scheme-function (keymusic) (ly:music?)
   (ht-relative-major keymusic))

%% chordNameExceptions must be cleared, not left alone. globalChordSymbols sets
%% it (lib/global-chord-symbols.ily) so that sus, 7, dim and friends print as
%% letter-chord markup, and exceptions are consulted *before* chordNameFunction
%% - leave them in place and every chord this book most needs to renumber comes
%% out as a letter name instead.
htRomanChordNames =
#(define-music-function (tonic music) (ly:pitch? ly:music?)
   #{
     \new ChordNames \with {
       chordNameFunction = #(ht-roman-namer tonic)
       chordNameExceptions = #'()
     }
     { $music }
   #})

%% One book, no transpositions - see the note at the top of the file.
%%
%% Built as a string and re-parsed for the same reason transposed-books.ily and
%% fret-books.ily do it: \bookOutputSuffix is a parse-time setting on the
%% enclosing \book, and a \book is not a music expression.
%%
%% capoOnly is stripped as it is in the fret books: a capo instruction names a
%% fret for a letter chord, which says nothing about a numeral.
%%
%% Built on the full four-part layout, not the lead sheet. The numerals name
%% the harmony the four voices are actually singing, so the parts that make
%% each chord should be on the page under them - a melody line asks the reader
%% to take the analysis on faith. This is the one chord book that is not a
%% lead sheet, which is why it calls \fillTradScore rather than
%% \fillTradLeadSheetScore.
#(define (ht-roman-book)
   (format #f "
\\book {
  \\prescore_text
  \\bookOutputSuffix \"roman\" \\score {
    \\removeWithTag #'(midionly slidesOnly capoOnly)
    \\fillTradScore
      { \\removeWithTag #'(midionly slidesOnly) \\soprano }
      { \\removeWithTag #'(midionly slidesOnly) \\alto }
      { \\removeWithTag #'(midionly slidesOnly) \\tenor }
      { \\removeWithTag #'(midionly slidesOnly) \\bass }
      { \\htRomanChordNames \\htRomanTonic \\hymnKey
          { \\htChordMusic \\chordSymbols \\songChords } }
      \\tradStaffZoom
    ~a
  }
  \\postscore_text
  \\extra_verses
}
"
           (ht-spacing-snippet "roman")))

%% Call from a bare top-level #(...), never from a music function - see the
%% note on ht-fret-books for what goes wrong otherwise.
#(if (and (ht-book? "roman")
          (ht-song-has-chords? (ly:parser-lookup 'chordSymbols)
                               (ly:parser-lookup 'songChords)))
     (ly:parser-include-string (ht-roman-book)))
