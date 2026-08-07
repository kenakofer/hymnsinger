%% Roman numeral lead sheet: melody with each chord named by its scale degree
%% rather than by letter (-roman).
%%
%% Songs without chords emit nothing here - a numeral book with no numerals in
%% it is just the lead sheet, which already exists. Same test the fret books
%% use, so the site's "does this file exist?" check works the same way.
%%
%% Unlike every other chord book this one has no transpositions. A numeral says
%% where a chord sits relative to the tonic, and that does not change when the
%% music moves - all five books would be the same page. The site hides the
%% transpose control on this view for the same reason.
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
%% treated as suspended; anything left over is called major, which is what an
%% unadorned root with a fifth means.
%% sus2 and sus4 are separate qualities, not one "sus": they are different
%% chords, and collapsing them prints the same numeral for both.
#(define (ht-roman-quality iv)
   (cond ((and (memv 4 iv) (memv 8 iv) (not (memv 7 iv))) 'aug)
         ((and (memv 3 iv) (memv 6 iv)) 'dim)
         ((memv 4 iv) 'major)
         ((memv 3 iv) 'minor)
         ((memv 5 iv) 'sus4)
         ((memv 2 iv) 'sus2)
         (else 'major)))

%% A tone added over a complete triad - the 6 of a sixth chord, the 9 of an
%% add9. Only meaningful once a third is present: without one the same interval
%% is the suspension itself, and ht-roman-quality has already named it.
%%
%% The major sixth (9 semitones) is the same interval as a diminished seventh,
%% so this is asked only for chords that are not diminished; on a dim chord the
%% quality branch has already spoken for it.
#(define (ht-roman-added-tone iv q)
   (and (memq q '(major minor))
        (cond ((and (memv 9 iv) (not (memv 10 iv)) (not (memv 11 iv))) "6")
              ((memv 2 iv) "9")     ; a 2nd over a full triad is an added 9th
              (else #f))))

%% Figured-bass digits for a chord standing on something other than its root.
%%
%% Which inversion it is comes from the interval between the root and the note
%% in the bass, not from a position in the pitch list: \chordmode hands the
%% pitches over in root position and reports the inverted note separately, so
%% the list itself never shows the inversion.
%%
%% Thirds and fifths are matched by semitone so major and minor chords share
%% one table - a minor third (3) and a major third (4) are both "first
%% inversion". A bass note that is not a chord tone has no standard figure, so
%% it gets none rather than a wrong one.
#(define (ht-roman-inversion-figure semitones-above-root seventh?)
   (let ((i (modulo semitones-above-root 12)))
     (cond ((= i 0) #f)                          ; root position
           ((memv i '(3 4)) (if seventh? "65" "6"))
           ((memv i '(6 7)) (if seventh? "43" "64"))
           ((memv i '(9 10 11)) (and seventh? "42"))
           (else #f))))

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
          (added (ht-roman-added-tone iv q))
          ;; A seventh for figuring purposes: it is the seventh that makes the
          ;; four-note figures (65, 43, 42) the right ones. The 9 semitones of
          ;; a diminished seventh count only on a diminished chord - elsewhere
          ;; that interval is an added sixth, which is a triad plus a tone and
          ;; still takes the three-note figures.
          (seventh? (or (memv 10 iv) (memv 11 iv)
                        (and (eq? q 'dim) (memv 9 iv))))
          ;; Case carries major/minor; dim and aug add a glyph as well.
          (base (if (memq q '(minor dim)) (string-downcase numeral) numeral))
          ;; An inverted chord becomes figured-bass digits. A true slash bass
          ;; (a note outside the chord) arrives as BASS instead and has no
          ;; figure, so it falls through to the plain numeral.
          (fig (and (ly:pitch? inversion)
                    (ht-roman-inversion-figure
                     (- (ly:pitch-semitones inversion) (ly:pitch-semitones root))
                     seventh?)))
          ;; The inversion figure already says "seventh chord" - 65 and 43 both
          ;; imply it - so a plain 7 alongside would say it twice. Quality
          ;; marks have to appear either way.
          ;;
          ;; M7 counts as a quality mark, not as the plain 7: the figures say
          ;; which note is in the bass, never whether the seventh is major, so
          ;; dropping it would print an inverted maj7 exactly like an inverted
          ;; dominant 7. It stays and the figure joins it: V M7 65.
          (sup (string-append
                (cond ((eq? q 'dim) (if (memv 9 iv)
                                        (if fig "°" "°7")
                                        (if (memv 10 iv) "ø" "°")))
                      ((eq? q 'aug) "+")
                      ((memv 11 iv) "M7")
                      (fig "")
                      ((memv 10 iv) "7")
                      (else ""))
                ;; Which suspension it is, not merely that there is one.
                (case q ((sus4) "sus4") ((sus2) "sus2") (else ""))
                ;; An added tone is not implied by any figure, so it prints
                ;; even alongside one.
                (or added "")))
          ;; Two-digit figures stack the way figured bass is written: 6 over 4,
          ;; not the number sixty-four. Raised as a unit so the pair sits beside
          ;; the numeral instead of hanging below the baseline, with the leading
          ;; pulled in - the default is set for running text and gapes at this
          ;; size - and a little space so the digits clear the numeral.
          (fig-markup
           (and fig
                (if (= (string-length fig) 2)
                    (make-line-markup
                     (list
                      (make-hspace-markup 0.5)
                      (make-raise-markup
                       0.75
                       (make-override-markup
                        '(baseline-skip . 1.5)
                        (make-left-column-markup
                         (list (markup (substring fig 0 1))
                               (markup (substring fig 1 2))))))))
                    (make-super-markup (markup fig))))))
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
         (if (string-null? sup) '() (list (make-super-markup (markup sup))))
         (if fig-markup (list (make-smaller-markup fig-markup)) '())))))))

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
#(define (ht-roman-book)
   "
\\book {
  \\prescore_text
  \\bookOutputSuffix \"roman\" \\score {
    \\removeWithTag #'(midionly slidesOnly capoOnly)
    \\fillTradLeadSheetScore
      { \\removeWithTag #'(midionly slidesOnly) \\soprano }
      { \\htRomanChordNames \\htRomanTonic \\hymnKey
          { \\htChordMusic \\chordSymbols \\songChords } }
      \\tradLeadSheetStaffZoom
  }
  \\postscore_text
  \\extra_verses
}
")

%% Call from a bare top-level #(...), never from a music function - see the
%% note on ht-fret-books for what goes wrong otherwise.
#(if (and (ht-book? "roman")
          (ht-song-has-chords? (ly:parser-lookup 'chordSymbols)
                               (ly:parser-lookup 'songChords)))
     (ly:parser-include-string (ht-roman-book)))
