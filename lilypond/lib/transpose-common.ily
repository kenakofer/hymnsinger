%% Shared machinery for the transposed trad books (-trad-up1/up2/dn1/dn2).
%%
%% \transpose needs a pitch *pair*, and the second pitch is what fixes the
%% spelling: \transpose c df and \transpose c cs shift by the same semitone
%% but print five flats or seven sharps. Picking that spelling per song by
%% hand would mean a table of 17 keys times 4 shifts, so derive it instead.

%% Position on the circle of fifths for each major tonic: positive is sharps,
%% negative is flats, and the absolute value is the number of accidentals.
#(define ht-fifths
   '((-7 . (0 . -1/2)) (-6 . (4 . -1/2)) (-5 . (1 . -1/2)) (-4 . (5 . -1/2))
     (-3 . (2 . -1/2)) (-2 . (6 . -1/2)) (-1 . (3 . 0))    (0  . (0 . 0))
     (1  . (4 . 0))    (2  . (1 . 0))    (3  . (5 . 0))    (4  . (2 . 0))
     (5  . (6 . 0))    (6  . (3 . 1/2))  (7  . (0 . 1/2))))

#(define (ht-pitch-semitone notename alteration)
   "Semitones above c for a notename/alteration pair."
   (modulo (+ (list-ref '(0 2 4 5 7 9 11) notename)
              (inexact->exact (* 2 alteration)))
           12))

#(define (ht-fifths->pitch f)
   "The major tonic at circle-of-fifths position F, as an ly:pitch."
   (let ((na (assv-ref ht-fifths f)))
     (ly:make-pitch 0 (car na) (cdr na))))

%% Choose the spelling with the fewest accidentals, breaking ties toward flats
%% -- hymnals lean flat-side, and most of this corpus already sits there. This
%% keeps the worst case at six accidentals (e.g. f +1 -> gf, not fs).
#(define (ht-best-spelling semitone)
   "The ly:pitch major tonic SEMITONE steps above c with fewest accidentals."
   (let loop ((cands (map car ht-fifths)) (best #f))
     (if (null? cands)
         (ht-fifths->pitch best)
         (let* ((f (car cands))
                (p (ht-fifths->pitch f)))
           (loop (cdr cands)
                 (if (and (= (ht-pitch-semitone (ly:pitch-notename p)
                                                (ly:pitch-alteration p))
                             (modulo semitone 12))
                          (or (not best)
                              (< (abs f) (abs best))
                              ;; equal count: prefer the flat side
                              (and (= (abs f) (abs best)) (< f best))))
                     f
                     best))))))

%% \hymnKey is a \key event, so its tonic is readable at parse time - no need
%% to wait for a context the way \relativeMajorShapes does.
#(define (ht-key-tonic keymusic)
   (let ((t (ly:music-property keymusic 'tonic)))
     (if (ly:pitch? t) t (ly:make-pitch 0 0 0))))

%% How many sharps (+) or flats (-) the signature actually prints. Read from
%% the key's pitch-alist rather than assumed from the tonic: \key d \major and
%% \key d \minor share a tonic but sit five positions apart on the circle, and
%% treating d minor as D major is what produced eight-flat signatures with
%% double flats a semitone down.
%%
%% Taking it from the alist also means the modes need no special casing -
%% mixolydian and phrygian fall out of the same arithmetic as minor.
#(define (ht-key-fifths keymusic)
   (let ((alist (ly:music-property keymusic 'pitch-alist)))
     (if (pair? alist)
         (apply + (map (lambda (entry)
                         (inexact->exact (* 2 (cdr entry))))
                       alist))
         0)))

%% The major tonic whose signature matches this key - the relative major.
%% Everything downstream reasons in major, then the shift is applied to that.
#(define (ht-relative-major keymusic)
   (ht-fifths->pitch (ht-key-fifths keymusic)))

%% The two pitches to hand \transpose so the music moves SHIFT semitones and
%% lands in the best-spelled key.
%%
%% The pair is expressed relative-major to relative-major. \transpose only
%% cares about the interval between the two pitches, so shifting the relative
%% major by the same interval carries the real tonic along with it and keeps
%% the mode intact - a d minor song stays minor, it just changes pitch.
%%
%% The target's octave has to be set explicitly. ht-best-spelling names a
%% tonic, not a direction, and it always hands back octave 0, so c -1 comes
%% out as b in the same octave - eleven semitones *up*. Leaving both pitches
%% at octave 0 is only right when the target happens to sit above the source
%% within that octave; every key whose shift crosses c needs the correction.
htTransposeFrom =
#(define-scheme-function (keymusic) (ly:music?)
   (ht-relative-major keymusic))

htTransposeTo =
#(define-scheme-function (keymusic shift) (ly:music? integer?)
   (let* ((rm (ht-relative-major keymusic))
          (from (ht-pitch-semitone (ly:pitch-notename rm) (ly:pitch-alteration rm)))
          (to (ht-best-spelling (+ from shift)))
          ;; Semitones the pair spans with both at octave 0, then drop or lift
          ;; whole octaves until that span is the shift that was asked for.
          (span (- (ly:pitch-semitones to) (ly:pitch-semitones rm))))
     (ly:make-pitch (/ (- shift span) 12)
                    (ly:pitch-notename to)
                    (ly:pitch-alteration to))))
