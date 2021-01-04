%    This file "clairnote.ly" is a LilyPond include file for producing
%    sheet music in Clairnote music notation (http://clairnote.org).
%    Version: 20181125
%
%    Copyright © 2013, 2014, 2015, 2016, 2017, 2018 Paul Morris,
%    except for functions copied and modified from LilyPond source code,
%    the LilyPond Snippet Repository, and openLilyLib, as noted in
%    comments below.
%    Contact information: http://clairnote.org/about/
%
%    This file is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This file is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this file.  If not, see <http://www.gnu.org/licenses/>.

\version "2.19.49"

% For docstrings we use ;; instead of the usual "" to allow automated
% minification for LilyBin + Clairnote.

%--- UTILITY FUNCTIONS ----------------

#(define (non-zero? n) (not (zero? n)))

#(define (positive-integer? n) (and (positive? n) (integer? n)))

#(define (map-pairs proc . pairs)
   (cons
    (reduce proc '() (map car pairs))
    (reduce proc '() (map cdr pairs))))

#(define (cn-notehead-pitch grob)
   ;; Takes a note head grob and returns its pitch.
   (define event (ly:grob-property grob 'cause))
   (if (ly:stream-event? event)
       (ly:event-property event 'pitch)
       (begin
        (ly:warning "clairnote.ly cannot access the pitch of a note head grob.  (Are you trying to use the Ambitus_engraver?  It is incompatible with clairnote.ly.)")
        (ly:make-pitch 0 0 0))))

#(define (cn-notehead-semitone grob)
   ;; Takes a note head grob and returns its semitone.
   (ly:pitch-semitones (cn-notehead-pitch grob)))

#(define (cn-staff-symbol-property grob prop default)
   ;; Takes a grob @var{grob}, a symbol @var{prop}, and
   ;; a @var{default} value. Returns that custom StaffSymbol
   ;; property or silently falls back to the default value.
   (define staff-sym (ly:grob-object grob 'staff-symbol))
   (if (ly:grob? staff-sym)
       (ly:grob-property staff-sym prop)
       default))

#(define (cn-get-base-staff-space grob)
   ;; Takes a grob and returns the custom StaffSymbol property
   ;; cn-base-staff-space.  Silently falls back to the default of 0.75.
   (cn-staff-symbol-property grob 'cn-base-staff-space 0.75))

#(define (cn-magnification grob)
   ;; Return the current magnification (from magnifyStaff, etc.)
   ;; via a grob's font size.
   (magstep (ly:grob-property grob 'font-size 0)))

#(define (cn-get-staff-clef-adjust staff-octaves clef-octave-shift)
   ;; Calculate the amount to vertically adjust the position of the clef,
   ;; key signature, and time signature, in note-spaces / half-staff-spaces.
   (+
    (* 12 clef-octave-shift)
    (if (odd? staff-octaves)
        6
        (if (> staff-octaves 2) 12 0))))

#(define (cn-staff-clef-adjust-from-grob grob)
   (cn-get-staff-clef-adjust
    (cn-staff-symbol-property grob 'cn-staff-octaves 2)
    (cn-staff-symbol-property grob 'cn-clef-shift 0)))

#(define (cn-note-heads-from-grob grob default)
   ;; Takes a grob like a Stem and returns a list of
   ;; NoteHead grobs or default.
   (let* ((heads-array (ly:grob-object grob 'note-heads))
          (heads-list (if (ly:grob-array? heads-array)
                          (ly:grob-array->list heads-array)
                          ;; should never/rarely? happen:
                          default)))
     heads-list))


%--- NOTE HEADS AND STEM ATTACHMENT ----------------

#(define cn-whole-note-black-path
   '(moveto 0 0
      curveto 0 0.16054432 0.12694192 0.28001904 0.272552 0.35842432
      curveto 0.47416576 0.4666984 0.70564816 0.50776784 0.93339712 0.50776784
      curveto 1.16114576 0.50776784 1.39636192 0.4666984 1.59797568 0.35842432
      curveto 1.74358576 0.28001904 1.87052768 0.16054432 1.87052768 0
      curveto 1.87052768 -0.16054432 1.74358576 -0.2800192 1.59797568 -0.35842448
      curveto 1.39636192 -0.46669856 1.16114592 -0.507768 0.93339712 -0.507768
      curveto 0.70564816 -0.507768 0.47416576 -0.46669856 0.272552 -0.35842448
      curveto 0.12694192 -0.2800192 0 -0.16054432 0 0
      closepath))

#(define cn-whole-note-white-path
   ;; white-path is the black path with the center hole added
   (append
    cn-whole-note-black-path
    '(moveto 1.06033904 -0.36566768
       curveto 1.24701856 -0.36566768 1.32542384 -0.2688184 1.32542384 -0.09707328
       curveto 1.32542384 0.19788 1.10140848 0.36566752 0.80645504 0.36566752
       curveto 0.61977552 0.36566752 0.545104 0.26881824 0.545104 0.09707312
       curveto 0.545104 -0.19788016 0.7653856 -0.36566768 1.06033904 -0.36566768
       closepath)))

#(define (cn-whole-note-stencil grob white-note)
   ;; Returns default Clairnote whole note stencils.
   (let ((mag (cn-magnification grob))
         (wn-path (if white-note
                      cn-whole-note-white-path
                      cn-whole-note-black-path)))
     (ly:stencil-scale
      (make-path-stencil wn-path 0.0001 1 1 #t)
      mag mag)))

#(define cn-note-black-path
   '(moveto 1.0161518991984164 0.5004939160736768
      curveto 1.1900858991984165 0.45804726744838686 1.3000056991984164 0.36006297281891986 1.3267185991984165 0.22365338254444356
      curveto 1.3472530991984164 0.11878494731492373 1.3090816991984164 -0.03242382812749062 1.2346937991984164 -0.14100554722801906
      curveto 1.1037044991984164 -0.3321698541497182 0.8786728091984164 -0.46440803197455877 0.6176073691984164 -0.5036333230878486
      curveto 0.5243774691984164 -0.517643902935715 0.36590771919841636 -0.5120649140876494 0.28844503919841635 -0.49205136745873423
      curveto -0.029717590801583628 -0.40984214143367353 -0.09642331080158363 -0.0917693764989545 0.14752670919841637 0.17990713903061328
      curveto 0.2984087391984164 0.347937968940766 0.5439097091984164 0.4755783490866303 0.7757855691984165 0.5065506656056886
      curveto 0.8399878691984165 0.5151219432426919 0.9695811491984164 0.5118635199715458 1.0161502991984164 0.5005020382431211
      closepath))

#(define cn-note-white-path
   '(moveto 1.026468864255086 0.4998680875655276
      curveto 1.215249864255086 0.4618436649454002 1.337174464255086 0.35147108531050375 1.354920364255086 0.20252749405141746
      curveto 1.369178964255086 0.08282868839604651 1.312372764255086 -0.07672001395465605 1.209350364255086 -0.20633856802981299
      curveto 1.077365164255086 -0.37239062345611024 0.889153024255086 -0.47211463127579484 0.6458905642550861 -0.5048878796193299
      curveto 0.585101844255086 -0.5130801213612108 0.548868934255086 -0.5134163330622651 0.443309034255086 -0.5067845101638356
      curveto 0.32885581425508603 -0.49958868733223255 0.30882433425508604 -0.4965974421400958 0.260617494255086 -0.47979947287536673
      curveto 0.118058624255086 -0.4300386473948317 0.024819864255086005 -0.335419029253747 0.0042339542550860025 -0.21961971038330325
      curveto -0.015404825744913999 -0.1091556900709823 0.035236334255086 0.05025573233647185 0.132092634255086 0.18283290751856218
      curveto 0.268217284255086 0.3691712451565947 0.47658985425508604 0.48176186299022195 0.730680684255086 0.5062696961187646
      curveto 0.823563584255086 0.5152225290660725 0.965453244255086 0.5121589666760266 1.026469764255086 0.4998666604401908
      closepath
      moveto 0.8920403042550861 0.32723653716982337
      curveto 0.801899114255086 0.305937547790631 0.674353834255086 0.25092305532124815 0.517242874255086 0.16559336664623436
      curveto 0.199745884255086 -0.006853856240945699 0.109727534255086 -0.09774589911519554 0.151265174255086 -0.2039339094078499
      curveto 0.168776074255086 -0.24869436361851288 0.191705974255086 -0.27755407274963595 0.226470474255086 -0.2985602160096806
      curveto 0.309656374255086 -0.34884402584120455 0.42197617425508605 -0.33748020734960626 0.634757234255086 -0.25724484236248213
      curveto 0.9774722042550861 -0.1280260070658748 1.216026564255086 0.03390026706789495 1.2240259642550861 0.14273918170232358
      curveto 1.2287459642550862 0.20700273076812625 1.184881964255086 0.28132959706261473 1.121983764255086 0.3156476039275703
      curveto 1.083730764255086 0.33652340307350437 1.077348764255086 0.3379303583723863 1.015085564255086 0.3392592023444909
      curveto 0.969948864255086 0.34025914149726677 0.9307790642550859 0.33638021483136094 0.892038904255086 0.32724518554936555
      closepath))

#(define (cn-default-note-head-stencil grob white-note)
   ;; Returns default Clairnote note head stencils.
   ;; The hollow half-note and solid quarter-note glyphs are modified versions
   ;; (rotated -4 degrees then scaled vertically by 0.9299)
   ;; of these glyphs from the Bravura font,
   ;; licensed under the SIL Open Font License (OFL), see:
   ;; http://scripts.sil.org/OFL
   ;; http://www.smufl.org/fonts/
   ;; http://blog.steinberg.net/2013/05/introducing-bravura-music-font/
   (let ((mag (cn-magnification grob))
         (nh-path (if white-note
                      cn-note-white-path
                      cn-note-black-path)))
     (ly:stencil-scale
      (make-path-stencil nh-path 0.0001 1 1 #t)
      mag mag)))

#(define (cn-lilypond-note-head-stencil grob white-note)
   ;; Returns 'lilypond' style note head stencils (Emmentaler font).
   (if white-note
       ;; white notes are scaled horizontally to match black ones
       (ly:stencil-scale
        (ly:font-get-glyph (ly:grob-default-font grob) "noteheads.s1")
        0.945 1)
       (ly:font-get-glyph (ly:grob-default-font grob) "noteheads.s2")))

#(define (cn-funksol-note-head-stencil grob white-note)
   ;; Returns 'funksol' style note head stencils.
   (ly:font-get-glyph (ly:grob-default-font grob)
     (if white-note
         "noteheads.s1solFunk"
         "noteheads.s2solFunk")))

#(define (cn-stylish-note? grob)
   ;; Does a note head grob have one of these style properties.
   (define style (ly:grob-property-data grob 'style))
   ;; TODO: better handling of various notehead styles
   ;; http://lilypond.org/doc/v2.18/Documentation/notation/note-head-styles
   ;; output-lib.scm
   (and (not (null? style))
        (memq style '(harmonic
                      harmonic-black
                      harmonic-mixed
                      diamond
                      cross
                      xcircle
                      triangle
                      slash))))

#(define (cn-whole-note? grob)
   ;; Note: longer durations than whole note also return #t.
   ;; duration-log: 0 is whole, 1 is half, 2 is quarter and shorter.
   (< (ly:grob-property grob 'duration-log) 1))

% Set to functions depending on the version of Clairnote.
#(define cn-white-note? '())
#(define cn-default-note-head-stencil-callback '())

#(define (cn-make-note-head-stencil-callback
          style-fn white-note? width-scale height-scale)
   ;; Returns a callback function for the note head stencil.
   ;; style-fn (function) takes a grob and a boolean and
   ;; returns a black or white note head stencil.
   ;; white-note? (function) takes a grob and returns
   ;; whether the note should be white.
   ;; width-scale and height-scale (numbers) for scaling the stencil.
   (lambda (grob)
     (cond
      ((cn-stylish-note? grob) (ly:note-head::print grob))
      ((cn-whole-note? grob) (cn-whole-note-stencil grob (white-note? grob)))
      (else
       (let ((stil (style-fn grob (white-note? grob))))
         (if (and (= 1 width-scale) (= 1 height-scale))
             stil
             (ly:stencil-scale stil width-scale height-scale)))))))

#(define (cn-make-note-head-rotation-callback rotn)
   ;; Returns a callback function for note head rotation,
   ;; that excludes whole notes and stylish notes.
   ;; Takes a list of three numbers like '(-9 0 0)
   (lambda (grob)
     (if (or (cn-whole-note? grob)
             (cn-stylish-note? grob))
         #f
         rotn)))

#(define (cn-make-stem-attachment-callback black-attach white-attach)
   ;; Returns a callback function for stem attachment,
   ;; that excludes whole notes and stylish notes.
   ;; The arguments are pairs of numbers for black and white notes.
   (lambda (grob)
     (if (or (cn-whole-note? grob)
             (cn-stylish-note? grob))
         (ly:note-head::calc-stem-attachment grob)
         (if (cn-white-note? grob)
             white-attach
             black-attach))))


%--- ACCIDENTAL STYLE ----------------

%% Procedures copied from scm/music-functions.scm, renamed with cn- prefix.

#(define (cn-recent-enough? bar-number alteration-def laziness)
   (or (number? alteration-def)
       (equal? laziness #t)
       (<= bar-number (+ (cadr alteration-def) laziness))))

#(define (cn-accidental-invalid? alteration-def)
   ;; Checks an alteration entry for being invalid.

   ;; Non-key alterations are invalidated when tying into the next bar or
   ;; when there is a clef change, since neither repetition nor cancellation
   ;; can be omitted when the same note occurs again.

   ;; Returns @code{#f} or the reason for the invalidation, a symbol.
   (let* ((def (if (pair? alteration-def)
                   (car alteration-def)
                   alteration-def)))
     (and (symbol? def) def)))

#(define (cn-extract-alteration alteration-def)
   (cond ((number? alteration-def)
          alteration-def)
     ((pair? alteration-def)
      (car alteration-def))
     (else 0)))

%% End of unmodified copied procedures.

#(define (cn-convert-to-semi-alts cn-alts local-alts)
   ;; Converts accidental alteration data to allow lookup by semitone.
   ;; From: ((octave . notename) . (alter barnum . measure-position))
   ;; To: (semitone alter barnum . measure-position)

   ;; notename is 0-6 diatonic note number.

   ;; With clef changes or notes tied across a bar line we get
   ;; e.g. ((0 . 6) clef 1 . #<Mom 7/8>) with 'clef or 'tied as the
   ;; alter value to invalidate the entry. Then we have to look up
   ;; the alter value in cn-alts, the cnAlterations context property.
   ;; This is the sole purpose of cnAlterations. It would be much
   ;; simpler if LilyPond did not destructively overload the alter
   ;; value like this.
   ;; (format #t "cn-alts: ~a \n" cn-alts)
   (map (lambda (entry)
          (let*
           ((octave (caar entry))
            (notename (cdar entry))
            (alteration-def (cdr entry))
            (alter (if (cn-accidental-invalid? alteration-def)
                       (cn-extract-alteration
                        (assoc-ref cn-alts (cons octave notename)))
                       (cn-extract-alteration alteration-def)))
            (pitch (ly:make-pitch octave notename alter))
            (semitone (ly:pitch-semitones pitch)))
           (cons semitone alteration-def)))
     local-alts))

#(define (cn-merge-semi-alts cn-semi-alts local-semi-alts)
   ;; Update cn-semi-alts by merging local-semi-alts into it.
   ;; Their entries are: (semitone alter barnum . measure-position)
   (define (merge-entry! local-entry)
     (let* ((semi (car local-entry))
            (cn-entry (assv semi cn-semi-alts)))

       ;; (format #t "local-entry: ~a \n" local-entry)
       ;; (format #t "cn-entry: ~a \n\n" cn-entry)

       ;; We merge when there is no entry for a given semitone,
       ;; or when there is one with a previous barnum,
       ;; or when there is one with the same barnum and a
       ;; previous measure-position.
       (if (or (not cn-entry)
               (< (caddr cn-entry) (caddr local-entry))
               (and (= (caddr cn-entry) (caddr local-entry))
                    (ly:moment<? (cdddr cn-entry) (cdddr local-entry))))
           (set! cn-semi-alts
                 (assv-set! cn-semi-alts semi (cdr local-entry))))))

   ;; (format #t "cn-semi-alts: ~a \n" cn-semi-alts)
   ;; (format #t "local-semi-alts: ~a \n\n" local-semi-alts)

   (for-each merge-entry! local-semi-alts)
   cn-semi-alts)

#(define (cn-refresh-semi-alts! context)
   ;; Converts localAlterations to a semitone-based version and
   ;; returns the result after storing it in the cnSemiAlterations
   ;; context property.
   (let*
    ;; localAlterations includes key signature entries like
    ;; (notename . alter) and maybe ((octave . notename) . alter)
    ;; so we filter these out, leaving only accidental entries:
    ;; ((octave . notename) . (alter barnum . measure-position))
    ((local-alts-raw (ly:context-property context 'localAlterations '()))
     (accidental-alt? (lambda (entry) (pair? (cdr entry))))
     (local-alts (filter accidental-alt? local-alts-raw)))

    (if (null? local-alts)
        (begin
         (ly:context-set-property! context 'cnSemiAlterations '())
         (ly:context-set-property! context 'cnAlterations '())
         '())
        (let*
         ((cn-alts (ly:context-property context 'cnAlterations '()))
          ;; Convert local-alts for lookup by semitone:
          ;; (semitone alter barnum . measure-position))
          (local-semi-alts (cn-convert-to-semi-alts cn-alts local-alts))

          (cn-semi-alts (ly:context-property context 'cnSemiAlterations '()))
          (new-semi-alts (cn-merge-semi-alts cn-semi-alts local-semi-alts)))

         ;; (format #t "local-alts: ~a \n" local-alts)
         ;; (format #t "semi-alts: ~a \n" new-semi-alts)

         (ly:context-set-property! context 'cnSemiAlterations new-semi-alts)
         new-semi-alts))))

#(define (cn-check-pitch-against-signature context pitch barnum measurepos laziness)
   ;; A modified version of this function from scm/music-functions.scm.
   ;; Arguments octaveness and all-naturals have been removed. Currently
   ;; laziness is always 0. We check active accidentals by semitone,
   ;; which requires conversion to semitones first, but we check
   ;; key signature by diatonic notename/number (0-6).

   ;; Checks the need for an accidental and a @q{restore} accidental
   ;; against @code{localAlterations} and @code{keyAlterations}.
   ;; The @var{laziness} is the number of measures for which reminder
   ;; accidentals are used (i.e., if @var{laziness} is zero, only cancel
   ;; accidentals in the same measure; if @var{laziness} is three, we
   ;; cancel accidentals up to three measures after they first appear.
   (let*
    ((notename (ly:pitch-notename pitch))
     (octave (ly:pitch-octave pitch))
     (alter (ly:pitch-alteration pitch))
     (semi (ly:pitch-semitones pitch))

     (cn-semi-alts (cn-refresh-semi-alts! context))

     ;; from-cn-alts will be #f or (alter barnum . measure-position)
     (from-cn-semi-alts (assoc-get semi cn-semi-alts))

     (key-alts (ly:context-property context 'keyAlterations '()))
     ;; from-key-alts will be #f or an alter number (e.g. 1/2, -1/2, 0)
     (from-key-alts
      (or (assoc-get notename key-alts)
          ;; If no notename match is found in keyAlterations,
          ;; we may have octave-specific entries like
          ;; ((octave . notename) alteration) instead of
          ;; (notename . alteration), so we try those as well.
          (assoc-get (cons octave notename) key-alts)))

     ;; Get previous alteration for comparison with pitch.
     (previous-alteration
      (or (and from-cn-semi-alts
               (cn-recent-enough? barnum from-cn-semi-alts laziness)
               from-cn-semi-alts)
          from-key-alts)))

    ;; (format #t "current: ~a ~a ~a ~a \n\n" semi alter barnum measurepos)

    ;; Add the current note to cnAlterations.
    (ly:context-set-property! context 'cnAlterations
      (assoc-set! (ly:context-property context 'cnAlterations)
        `(,octave . ,notename) `(,alter ,barnum . ,measurepos)))

    ;; Return a pair of booleans.
    ;; The first is always false since we never print an extra natural sign.
    ;; The second is whether an accidental sign should be printed.
    ;; We print it if the previous alter is either invalidated or
    ;; doesn't match the current one.
    (if (cn-accidental-invalid? previous-alteration)
        '(#f . #t)
        (let ((prev-alt (cn-extract-alteration previous-alteration)))
          (if (= alter prev-alt)
              '(#f . #f)
              '(#f . #t))))))

#(define (cn-make-accidental-rule laziness)
   ;; Slightly modified, octaveness argument has been removed.

   ;; Create an accidental rule that makes its decision based on a laziness value.
   ;; @var{laziness} states over how many bars an accidental should be remembered.
   ;; @code{0}@tie{}is the default -- accidental lasts over 0@tie{}bar lines, that
   ;; is, to the end of current measure.  A positive integer means that the
   ;; accidental lasts over that many bar lines.  @w{@code{-1}} is `forget
   ;; immediately', that is, only look at key signature.  @code{#t} is `forever'.

   (lambda (context pitch barnum measurepos)
     (cn-check-pitch-against-signature context pitch barnum measurepos laziness)))

accidental-styles.clairnote-default =
#`(#t (Staff ,(cn-make-accidental-rule 0)) ())

accidental-styles.none = #'(#t () ())


%--- ACCIDENTAL SIGNS ----------------

#(define cn-acc-sign-stils
   ;; associative list of accidental sign stencils
   (let*
    ((vertical-line
      (make-path-stencil '(moveto 0 -0.5 lineto 0 0.5) 0.2 1 1 #f))

     (circle (make-circle-stencil 0.24 0.01 #t))

     (diagonal-line
      (make-path-stencil '(moveto -0.13 -0.07 lineto 0.13 0.07) 0.33 1 1 #f))

     (short-vertical-line
      (make-path-stencil '(moveto 0 -0.3 lineto 0 0.3) 0.2 1 1 #f))

     (acc-sign (lambda (dot-position)
                 ;; Return a sharp or flat sign stencil.
                 (ly:stencil-add vertical-line
                   (ly:stencil-translate circle `(0 . ,dot-position)))))

     (double-acc-sign (lambda (stil)
                        ;; Return a double sharp or double flat sign stencil.
                        (ly:stencil-add
                         (ly:stencil-translate stil '(-0.25 . 0))
                         (ly:stencil-translate stil '(0.25 . 0)))))

     (sharp (acc-sign 0.5))
     (flat (acc-sign -0.5))
     (natural (ly:stencil-add diagonal-line
                (ly:stencil-translate short-vertical-line '(0.2 . -0.3))
                (ly:stencil-translate short-vertical-line '(-0.2 . 0.3)))))

    `((1/2 . ,sharp)
      (-1/2 . ,flat)
      (0 . ,natural)
      (1 . ,(double-acc-sign sharp))
      (-1 . ,(double-acc-sign flat)))))

#(define (cn-accidental-grob-callback grob)
   ;; Returns an accidental sign stencil.
   (let* ((mag (cn-magnification grob))
          (alt (accidental-interface::calc-alteration grob))
          (stil (assoc-ref cn-acc-sign-stils alt)))
     (if stil
         (ly:stencil-scale stil mag mag)
         ;; else fall back to traditional accidental sign
         (ly:stencil-scale (ly:accidental-interface::print grob) 0.63 0.63))))


%--- KEY SIGNATURES ----------------

#(define (cn-get-keysig-alt-count alt-alist)
   ;; Return number of sharps/flats in key sig, (+) for sharps, (-) for flats.
   (if (null? alt-alist)
       0
       (* (length alt-alist) 2 (cdr (car alt-alist)))))

#(define (cn-get-major-tonic alt-count)
   ;; Return number of the tonic note 0-6, as if the key sig were major.
   ;; (alt-count maj-num)
   ;; (-7 0) (-5 1) (-3 2) (-1 3) (1 4) (3 5) (5 6) (7 0)
   ;; (-6 4) (-4 5) (-2 6) (0 0) (2 1) (4 2) (6 3)
   (if (odd? alt-count)
       (modulo (- (/ (+ alt-count 1) 2) 4) 7)
       (modulo (/ alt-count 2) 7)))

#(define (cn-make-keysig-posns prev pattern result x-inc)
   ;; Calculate x and y positions for keysig dots.
   (if (null? pattern)
       result
       (let*
        ((whole-step (eqv? (car pattern) prev))
         (y-step (if whole-step 2 1))
         (x-step (if whole-step 0 x-inc))
         (last-xy (last result))
         (new-xy (cons (+ x-step (car last-xy)) (+ y-step (cdr last-xy)))))

        (cn-make-keysig-posns
         (car pattern)
         (cdr pattern)
         (append result (list new-xy))
         x-inc))))

#(define (cn-make-keysig-stack mode alt-list note-space black-tonic tonic-num)
   ;; Create the stack of circles (and tonic oval) for the key sig.
   (let*
    ((raw-pattern (take (drop '(#t #t #t #f #f #f #f #t #t #t #f #f #f #f) mode) 7))
     (raw-first-item (list-ref raw-pattern 0))
     ;; invert raw-pattern if needed, so that the first item is
     ;; #t for black tonic and #f for white tonic
     (pattern (if (or
                   (and black-tonic (not raw-first-item))
                   (and (not black-tonic) raw-first-item))
                  (map not raw-pattern)
                  raw-pattern))
     (first-item (list-ref pattern 0))
     (x-inc (if (and (pair? alt-list) (positive? (cdr (car alt-list)))) -0.8 0.8))

     (raw-posns (cn-make-keysig-posns (car pattern) (cdr pattern) '((0 . 0)) x-inc))
     (posns-b (map (lambda (p) (cons (car p) (* (cdr p) note-space))) raw-posns))

     (posns (if (negative? x-inc)
                (map (lambda (p) (cons (+ 1.2 (car p)) (cdr p))) posns-b)
                posns-b))

     (black-dot (make-oval-stencil 0.34 0.34 0.14 #t))
     (white-dot (make-oval-stencil 0.34 0.34 0.15 #f))

     (stack-list (map (lambda (xy bw)
                        (ly:stencil-translate (if bw black-dot white-dot) xy))
                   posns pattern))

     ;; add alterations - convert alt-list to a relative basis, tonic = 0, etc.
     (relative-alt-list (map (lambda (n)
                               (cons (modulo (- (car n) tonic-num) 7) (cdr n))) alt-list))
     (full-alt-list (map (lambda (n)
                           (assoc-ref relative-alt-list n)) '(0 1 2 3 4 5 6)))

     (sharp-line (make-path-stencil '(moveto 0 -0.2 lineto -0.7 -0.9) 0.22 1 1 #f))
     (flat-line (make-path-stencil '(moveto 0 0.2 lineto -0.7 0.9) 0.22 1 1 #f))

     (alt-stack-list (map (lambda (stil alt xy)
                            (cond
                             ((eqv? -1/2 alt)
                              (ly:stencil-combine-at-edge stil X -1
                                (ly:stencil-translate flat-line xy)
                                -0.2))
                             ((eqv? 1/2 alt)
                              (ly:stencil-combine-at-edge stil X -1
                                (ly:stencil-translate sharp-line xy)
                                -0.2))
                             (else stil)))
                       stack-list full-alt-list posns))
     (combined-stack (fold ly:stencil-add empty-stencil alt-stack-list))
     ;; horizontal position adjustment
     (extent (ly:stencil-extent combined-stack 0))
     (positioned-stack
      (ly:stencil-translate-axis combined-stack (- (car extent)) X)))
    positioned-stack))

#(define (cn-draw-keysig grob)
   ;; Draws Clairnote key signature stencils.
   (let*
    ((base-staff-space (cn-get-base-staff-space grob))
     (tonic-pitch (ly:grob-property grob 'cn-tonic))
     ;; number of the tonic (0-6) (C-B)
     (tonic-num (ly:pitch-notename tonic-pitch))
     ;; semitone of tonic (0-11) (C-B)
     (tonic-semi (modulo (ly:pitch-semitones tonic-pitch) 12))

     (alt-list (ly:grob-property grob 'alteration-alist))
     (alt-count (cn-get-keysig-alt-count alt-list))
     (major-tonic-num (cn-get-major-tonic alt-count))
     ;; number of the mode (0-6)
     (mode (modulo (- tonic-num major-tonic-num) 7))
     ;; the distance between two adjacent notes given vertical staff compression
     (note-space (* 0.5 base-staff-space))
     (black-tonic (eqv? 0 (modulo tonic-semi 2)))
     (raw-stack (cn-make-keysig-stack mode alt-list note-space black-tonic tonic-num))

     ;; position the sig vertically, C-tonic keys stay in place, the rest are moved down.
     (base-vert-adj (if (= 0 tonic-semi) tonic-semi (- tonic-semi 12)))

     ;; adjust position for odd octave staves and clefs shifted up/down an octave, etc.
     (staff-clef-adjust (cn-staff-clef-adjust-from-grob grob))
     (vert-adj (* note-space (+ base-vert-adj staff-clef-adjust)))
     (stack (ly:stencil-translate-axis raw-stack vert-adj Y)))

    ;; TODO: is this horizontal adjustment needed?
    ;; shift the sig to the right for better spacing
    ;; (ly:stencil-translate-axis stack 0 X)
    ;; (if (> mode 2)
    ;;    (ly:stencil-translate-axis stack 0.35 X)
    ;;    (ly:stencil-translate-axis stack 0.9 X))

    stack))

#(define (cn-key-signature-grob-callback grob)
   ;; Returns a key signature stencil or #f. Clairnote's staff
   ;; definition has printKeyCancellation = ##f, which prevents
   ;; key cancellations, except when changing to C major or
   ;; A minor. So here we return #f for those key cancellations.
   (if (grob::has-interface grob 'key-cancellation-interface)
       #f
       (let ((stil (cn-draw-keysig grob))
             (mag (cn-magnification grob)))
         (ly:stencil-scale stil mag mag))))

#(define (Cn_key_signature_engraver context)
   ;; Sets the tonic for the key on key signature grobs.
   ;; Spare parts: (ly:context-property context 'printKeyCancellation)
   (make-engraver
    (acknowledgers
     ((key-signature-interface engraver grob source-engraver)
      (ly:grob-set-property! grob 'cn-tonic
        (ly:context-property context 'tonic))))))


%--- CLEFS AND OTTAVA (8VA 8VB 15MA 15MB) ----------------

%% see /scm/parser-clef.scm and /ly/music-functions-init.ly

%% We use an engraver to convert to Clairnote clef properties
%% on the fly, rather than changing the traditional properties
%% themselves at the source.  This allows TradStaff to work
%% fully for any clef.

#(define (cn-convert-clef-glyph glyph pos)
   ;; Takes a standard clefGlyph or cueClefGlyph string and
   ;; a clefPosition or cueClefPosition integer.
   ;; Returns the corresponding Clairnote clef glyph string.
   ;; Return '() when \cueClefUnset.
   (if (null? glyph)
       '()
       (or
        (cond
         ;; G clef glyph
         ;; -4 french => treble
         ;; -2 treble => treble
         ((string=? "clefs.G" glyph)
          (if (member pos '(-2 -4)) "clefs.G" #f))

         ;; F clef glyph
         ;; 0 varbaritone => bass
         ;; 2 bass => bass
         ;; 4 subbass => bass
         ((string=? "clefs.F" glyph)
          (if (member pos '(2 0 4)) "clefs.F" #f))

         ;; C clef glyph
         ;; -4 soprano => treble
         ;; -2 mezzosoprano => alto
         ;; 0 alto => alto (settings unchanged, but needed)
         ;; 2 tenor => alto
         ;; 4 baritone => bass
         ((string=? "clefs.C" glyph)
          (cond
           ((member pos '(0 2 -2)) "clefs.C")
           ((= -4 pos) "clefs.G")
           ((= 4 pos) "clefs.F")
           (else #f)))

         ((string=? "clefs.percussion" glyph) "clefs.percussion")
         (else #f))

        (begin
         (ly:warning "clef unsupported by clairnote.ly, using another clef instead.")
         (cond
          ((string=? "clefs.F" glyph) "clefs.F")
          ((string=? "clefs.C" glyph) "clefs.C")
          (else "clefs.G"))))))

#(define (cn-convert-clef-transposition trans)
   ;; Takes standard clefTransposition or cueClefTransposition values and
   ;; converts them.
   ;; If trans is already a Clairnote value (...-12, 12, 24...) just return trans,
   ;; else convert from 7 notes per octave to 12.  7-->12, 14-->24. Rounding
   ;; means only multiples of 12 are ever returned (... -24, -12, 0, 12, 24 ...).
   ;; Return '() when \cueClefUnset.
   (cond
    ((null? trans) '())
    ((= 0 (modulo trans 12)) trans)
    (else (* 12 (round (/ trans 7))))))

#(define (cn-convert-clef-position glyph clef-adjust)
   ;; Takes standard clefPosition or cueClefPosition values and converts
   ;; them. Returns defaults for two-octave staves.
   ;; Return '() when \cueClefUnset.
   (if (null? glyph)
       '()
       (+ clef-adjust
         (cond
          ((string=? "clefs.G" glyph) -5)
          ((string=? "clefs.F" glyph) 5)
          ;; clefs.C and clefs.percussion
          (else 0)))))

#(define (cn-convert-middle-c-clef-position glyph clef-adjust trans)
   ;; Takes standard middleCClefPosition or middleCCuePosition values
   ;; and converts them. trans is clefTransposition or cueClefTransposition.
   ;; Returns defaults for two-octave staves.

   ;; To calculate the clairnote middle c position subtract the clef position
   ;; from 12 for bass clef or from -12 for treble clef (to adjust the clef
   ;; position without affecting the position of middle c or other notes).
   ;; Return '() when \cueClefUnset.
   (if (null? glyph)
       '()
       (+ clef-adjust
         (- trans)
         (cond
          ((string=? "clefs.G" glyph) -12)
          ((string=? "clefs.F" glyph) 12)
          ;; clefs.C and clefs.percussion
          (else 0)))))

#(define (cn-convert-middle-c-offset offset)
   ;; Takes standard middleCOffset values for Ottava/8va and converts them.
   (if (null? offset)
       '()
       (* offset 12/7)))

#(define (Cn_clef_ottava_engraver context)
   ;; Overrides clef and ottava settings. A closure stores the previous
   ;; properties in order to detect changed settings. Uses listeners
   ;; to modify context properties before grobs are created.

   ;; In order to have stems change direction at the vertical center
   ;; of the staff we use different clef settings for staves with odd
   ;; or even numbers of octaves (with clef-adjust).
   (let*
    ((props (alist->hash-table '((clefGlyph . ())
                                 (clefPosition . ())
                                 (middleCClefPosition . ())
                                 (clefTransposition . ())

                                 (cueClefGlyph . ())
                                 (cueClefPosition . ())
                                 (middleCCuePosition . ())
                                 (cueClefTransposition . ())

                                 ;; for ottava, 8va
                                 (middleCOffset . ())

                                 (cnStaffOctaves . ())
                                 (cnClefShift . ()))))
     (set-prop! (lambda (kee val)
                  (hash-set! props kee val)
                  (ly:context-set-property! context kee val)))

     ;; Most arguments to the following functions are property name
     ;; symbols, e.g. glyph will be 'clefGlyph or 'cueClefGlyph.
     ;; But clef-adjust is a number.
     (set-glyph! (lambda (glyph pos)
                   (set-prop! glyph
                     (cn-convert-clef-glyph
                      (ly:context-property context glyph)
                      (ly:context-property context pos)))))

     (set-transposition! (lambda (trans)
                           (set-prop! trans
                             (cn-convert-clef-transposition
                              (ly:context-property context trans)))))

     (set-position! (lambda (pos glyph clef-adjust)
                      (set-prop! pos
                        (cn-convert-clef-position
                         (hash-ref props glyph '()) clef-adjust))))

     (set-middle-c! (lambda (midc glyph clef-adjust trans)
                      (set-prop! midc
                        (cn-convert-middle-c-clef-position
                         (hash-ref props glyph '())
                         clef-adjust
                         (hash-ref props trans '())))))
     (changed? (lambda (prop equality-predicate)
                 (not (equality-predicate
                       (hash-ref props prop)
                       (ly:context-property context prop))))))
    (make-engraver
     (listeners
      ;; TODO: confirm that rhythmic-event is best event to listen to.
      ((rhythmic-event engraver event)
       (let*
        ((new-staff-octaves (changed? 'cnStaffOctaves eqv?))
         (new-clef-shift (changed? 'cnClefShift eqv?))
         (new-mid-c-offset (changed? 'middleCOffset eqv?))

         (new-clef (or (changed? 'clefPosition eqv?)
                       (changed? 'middleCClefPosition eqv?)
                       (changed? 'clefTransposition eqv?)
                       (changed? 'clefGlyph equal?)))

         (new-cue (or (changed? 'cueClefPosition eqv?)
                      (changed? 'middleCCuePosition eqv?)
                      (changed? 'cueClefTransposition eqv?)
                      (changed? 'cueClefGlyph equal?))))

        ;; The Clef engraver is called every measure (!),
        ;; so exit early if nothing changed.
        (if (or new-clef new-cue
                new-staff-octaves new-clef-shift new-mid-c-offset)
            (let
             ;; clef-adjust shifts clefPosition and middleCClefPosition:
             ;; up 6 note-positions for odd octave staves
             ;; up 12 for even octave staves with 4 or more octaves
             ;; up or down 12 * Staff.cnClefShift
             ((clef-adjust (cn-get-staff-clef-adjust
                            (ly:context-property context 'cnStaffOctaves)
                            (ly:context-property context 'cnClefShift))))

             ;; Custom Clairnote props don't need conversion, just store them.
             (if new-staff-octaves (hash-set! props 'cnStaffOctaves
                                     (ly:context-property context 'cnStaffOctaves)))
             (if new-clef-shift (hash-set! props 'cnClefShift
                                  (ly:context-property context 'cnClefShift)))

             ;; The order in which clef properties are set is important!
             (if new-clef (set-glyph! 'clefGlyph 'clefPosition))
             (if new-cue (set-glyph! 'cueClefGlyph 'cueClefPosition))

             (if (or new-clef new-staff-octaves new-clef-shift)
                 (begin
                  (set-transposition! 'clefTransposition)
                  (set-position! 'clefPosition 'clefGlyph clef-adjust)
                  (set-middle-c! 'middleCClefPosition
                    'clefGlyph clef-adjust 'clefTransposition)))

             (if (or new-cue new-staff-octaves new-clef-shift)
                 (begin
                  (set-transposition! 'cueClefTransposition)
                  (set-position! 'cueClefPosition 'cueClefGlyph clef-adjust)
                  (set-middle-c! 'middleCCuePosition
                    'cueClefGlyph clef-adjust 'cueClefTransposition)))

             ;; Ottava, 8va, 8vb, etc.
             (if new-mid-c-offset
                 (set-prop! 'middleCOffset
                   (cn-convert-middle-c-offset
                    (ly:context-property context 'middleCOffset))))

             (ly:set-middle-C! context)
             )))))

     ;; Copy clefTransposition context property to a custom Clef grob property.
     (acknowledgers
      ((clef-interface engraver grob source-engraver)
       (ly:grob-set-property! grob 'cn-clef-transposition
         (ly:context-property context 'clefTransposition))))
     )))


%--- CLEF GLYPHS

#(define cn-clef-curves
   ;; treble
   '(("clefs.G" .
       (moveto 1.5506 4.76844
         curveto 1.5376 4.76844 1.5066 4.75114 1.5136 4.73384
         lineto 1.7544 4.17292
         curveto 1.8234 3.97367 1.8444 3.88334 1.8444 3.66416
         curveto 1.8444 3.16204 1.5635 2.76967 1.2174 2.38312
         lineto 1.0789 2.2278
         curveto 0.5727 1.68982 0 1.16441 0 0.45906
         curveto 0 -0.36713 0.6414 -1.05 1.4549 -1.05
         curveto 1.5319 -1.05 1.6984 -1.0492 1.8799 -1.0372
         curveto 2.0139 -1.0282 2.1594 -0.9969 2.2732 -0.9744
         curveto 2.3771 -0.9538 2.5752 -0.8757 2.5752 -0.8757
         curveto 2.7512 -0.8152 2.6612 -0.62915 2.5442 -0.6835
         curveto 2.5442 -0.6835 2.3481 -0.7626 2.2449 -0.7822
         curveto 2.1355 -0.803 1.9939 -0.8319 1.8645 -0.8382
         curveto 1.6935 -0.8462 1.5257 -0.8402 1.4569 -0.8352
         curveto 1.1541 -0.8139 0.8667 -0.67432 0.6558 -0.48763
         curveto 0.5148 -0.36284 0.3782 -0.17408 0.3582 0.12709
         curveto 0.3582 0.76471 0.792 1.23147 1.255 1.71365
         lineto 1.3978 1.86523
         curveto 1.8046 2.29959 2.185 2.75829 2.185 3.32815
         curveto 2.185 3.77846 1.9185 4.42204 1.6113 4.75678
         curveto 1.5983 4.76858 1.5713 4.77188 1.5513 4.76828
         closepath))

     ;; bass
     ("clefs.F" .
       (moveto 0.2656 0.78107
         curveto 0.3775 0.79547 0.4351 0.84567 0.7003 0.85587
         curveto 0.9459 0.86587 1.0531 0.85987 1.1805 0.83797
         curveto 1.6967 0.74937 2.1173 0.13032 2.1173 -0.64059
         curveto 2.1173 -2.10531 0.9987 -3.04975 0.019 -3.8078
         curveto 0 -3.8345 0 -3.846 0 -3.8652
         curveto 0 -3.9101 0.022 -3.94 0.056 -3.94
         curveto 0.071 -3.94 0.079 -3.93904 0.107 -3.9231
         curveto 1.3341 -3.23572 2.6095 -2.2656 2.6095 -0.57604
         curveto 2.6095 0.4711 2.0006 1.05061 1.1664 1.05061
         curveto 0.9058 1.05561 0.7658 1.05861 0.5568 1.02591
         curveto 0.4588 1.01061 0.248 0.97281 0.219 0.92831
         curveto 0.165 0.89151 0.162 0.77308 0.266 0.78129
         closepath))

     ;; alto
     ("clefs.C" .
       (moveto 1.0406 2.93878
         curveto 0.9606 2.93578 0.8881 2.93178 0.8237 2.92878
         lineto 0.8237 2.92846
         curveto 0.6586 2.92046 0.4659 2.89806 0.3697 2.87906
         curveto 0.1409 2.83386 0.0236 2.78916 0 2.75937
         curveto -0.018 2.73927 -0.015 2.71087 0 2.69037
         curveto 0.023 2.64587 0.145 2.67017 0.4188 2.72887
         curveto 0.5108 2.74867 0.6924 2.76597 0.8607 2.77257
         curveto 1.0868 2.78157 1.2883 2.70417 1.3194 2.69167
         curveto 1.7053 2.53668 2.0444 2.24033 2.0444 1.46855
         curveto 2.0444 0.8488 1.8942 0.04261 1.4629 0.04261
         curveto 1.4489 0.04061 1.4419 0.03861 1.4289 0.02891
         curveto 1.4149 0.01311 1.4179 0.00091 1.4169 -0.01179
         curveto 1.4169 -0.01193 1.4169 -0.01195 1.4169 -0.01211
         curveto 1.4169 -0.01225 1.4169 -0.01227 1.4169 -0.01243
         curveto 1.4169 -0.02513 1.4169 -0.03723 1.4289 -0.05313
         curveto 1.4389 -0.06213 1.4479 -0.06493 1.4629 -0.06683
         curveto 1.8942 -0.06683 2.0444 -0.87302 2.0444 -1.49278
         curveto 2.0444 -2.26455 1.7053 -2.56059 1.3194 -2.71559
         curveto 1.2884 -2.72799 1.0868 -2.80579 0.8607 -2.79679
         curveto 0.6924 -2.78979 0.5113 -2.77259 0.4188 -2.75279
         curveto 0.145 -2.69409 0.0231 -2.66979 0 -2.71429
         curveto -0.011 -2.73479 -0.014 -2.76349 0 -2.78359
         curveto 0.024 -2.81339 0.1409 -2.85799 0.3697 -2.90328
         curveto 0.4657 -2.92228 0.6586 -2.94468 0.8237 -2.95268
         lineto 0.8237 -2.953
         curveto 0.9525 -2.958 1.1126 -2.9714 1.305 -2.96
         curveto 1.9479 -2.916 2.5587 -2.47655 2.5587 -1.48844
         curveto 2.5587 -0.89409 2.1807 -0.20184 1.7065 -0.01218
         curveto 2.1807 0.17748 2.5587 0.86972 2.5587 1.46406
         curveto 2.5587 2.45218 1.9479 2.89194 1.305 2.93594
         curveto 1.209 2.94194 1.1207 2.94094 1.0406 2.93794
         closepath))
     ))

#(define (cn-number-stencil grob number)
   ;; Returned stencils are centered horizontally, number must be 0-9.
   (ly:stencil-aligned-to
    (ly:font-get-glyph (ly:grob-default-font grob)
      (list-ref '("zero" "one" "two" "three" "four"
                   "five" "six" "seven" "eight" "nine") number))
    X 0))

#(define (cn-clef-number-shift glyph octave)
   ;; Takes a glyph (string) and an octave (integer) and
   ;; returns a pair of numbers for shifting the position
   ;; of the clef number stencil along x and y axes.
   (cond
    ((string=? "clefs.G" glyph) (case octave
                                  ((4) '(1.5 . -0.63))
                                  ((6) '(1.6 . -0.63))
                                  (else '(1.7 . -0.63))))
    ((string=? "clefs.F" glyph) '(1.0 . -1.33))
    ((string=? "clefs.C" glyph) '(0.9 . 0.48))
    (else '(0 . 0))))

#(define (cn-clef-stencil-callback grob)
   ;; Returns a stencil for clef grobs.
   (let* ((glyph (ly:grob-property grob 'glyph))
          (curve-path (assoc-ref cn-clef-curves glyph)))
     (if curve-path
         (let*
          ((curve-stil (make-path-stencil curve-path 0.0001 1 1 #t))
           (mag (cn-magnification grob))
           (scaled-curve (ly:stencil-scale curve-stil mag mag))

           (transpo (ly:grob-property grob 'cn-clef-transposition))
           ;; bass clef default octave is 3, treble and alto are 4
           (default-octave (if (string=? "clefs.F" glyph) 3 4))
           (octave (+ default-octave (/ transpo 12)))
           (number-shift (map-pairs * (cons mag mag)
                           (cn-clef-number-shift glyph octave)))
           (scale 0.9)
           (number-stil (ly:stencil-translate
                         (ly:stencil-scale
                          (cn-number-stencil grob octave)
                          scale scale)
                         number-shift))
           (2nd-number-stil
            (if (string=? "clefs.C" glyph)
                (ly:stencil-translate
                 (ly:stencil-scale
                  (cn-number-stencil grob (1- octave))
                  scale scale)
                 (cons (* mag 0.9) (* mag -2.46)))
                empty-stencil))

           (combined-stil (ly:stencil-add scaled-curve
                            number-stil 2nd-number-stil))
           ;; 'glyph-name is e.g. "clefs.G_change"
           ;; when 'glyph is just "clefs.G"
           (glyph-name (ly:grob-property grob 'glyph-name)))

          ;; for clef changes, scale stencil to 80 percent
          (if (member glyph-name '("clefs.G_change" "clefs.F_change"
                                    "clefs.C_change"))
              (ly:stencil-scale combined-stil 0.8 0.8)
              combined-stil))

         ;; clefs that aren't G, F, or C clefs use standard
         ;; stencil callback e.g. percussion clef
         (ly:clef::print grob))))


%--- REPEAT SIGN DOTS (BAR LINES) ----------------

%% adjust the position of dots in repeat signs
%% for Clairnote staff or traditional staff

#(add-bar-glyph-print-procedure ":"
   (lambda (grob extent)
     ;; A procedure that draws repeat sign dots at
     ;; @code{dot-positions}. The coordinates are the same as
     ;; @code{StaffSymbol.line-positions}, a dot-position of X
     ;; is equivalent to a line-position of X.
     (let*
      ((staff-sym (ly:grob-object grob 'staff-symbol))
       (is-clairnote-staff
        (if (ly:grob? staff-sym)
            (ly:grob-property staff-sym 'cn-is-clairnote-staff)
            #t))
       (odd-octaves
        (if (ly:grob? staff-sym)
            (member -2 (ly:grob-property staff-sym 'line-positions))
            #f))
       (dot-positions
        (if is-clairnote-staff
            (if odd-octaves '(4 8) '(-2 2))
            '(-1 1)))
       (staff-space (ly:staff-symbol-staff-space grob))
       (dot (ly:font-get-glyph (ly:grob-default-font grob) "dots.dot")))
      (fold
       (lambda (dp prev)
         (ly:stencil-add prev
           (ly:stencil-translate-axis dot (* dp (/ staff-space 2)) Y)))
       empty-stencil
       dot-positions))))


%--- TIME SIGNATURES ----------------

#(define (cn-time-signature-grob-callback grob)
   ;; Adjust vertical position of time sig based on vertical staff scaling.
   (let*
    ((base-staff-space (cn-get-base-staff-space grob))
     (vscale-staff (* 12/7 base-staff-space))
     (base-y-offset (* (+ vscale-staff -0.9) -2.5))

     ;; adjust position for odd octave staves and clefs shifted up/down an octave
     ;; note-space is the distance between two adjacent notes given vertical staff compression
     (note-space (* 0.5 base-staff-space))
     (staff-clef-adjust (cn-staff-clef-adjust-from-grob grob))

     (y-offset (+ base-y-offset (* note-space staff-clef-adjust)))

     ;; adjustment for \magnifyStaff
     (mag (cn-magnification grob))
     (final-y-offset (* y-offset mag)))

    (ly:grob-set-property! grob 'Y-offset final-y-offset)))


%--- STEM LENGTH AND DOUBLE STEMS ----------------

#(define (cn-grob-edge grob positive)
   ;; Takes a grob and returns the edge of the grob in positive
   ;; or negative direction (up or down), positive arg is boolean.
   (let* ((offset (ly:grob-property grob 'Y-offset))
          (extent (ly:grob-property grob 'Y-extent))
          (extent-dir (if positive (cdr extent) (car extent))))
     (+ offset extent-dir)))

#(define (cn-grobs-edge grobs positive)
   ;; Takes a list of grobs and positive, a boolean of whether the
   ;; direction we care about is positive/up or not/down, and returns
   ;; the furthest edge of the grobs in that direction.
   (let* ((comparator (if positive > <))
          (final-edge
           (fold (lambda (g prev-edge)
                   (let ((this-edge (cn-grob-edge g positive)))
                     (if (comparator this-edge prev-edge)
                         this-edge
                         prev-edge)))
             (cn-grob-edge (car grobs) positive)
             (cdr grobs))))
     final-edge))

#(define (cn-double-stem grob)
   (let*
    ((stem-stil (ly:stem::print grob))
     (dir (ly:grob-property grob 'direction))
     (up-stem (= 1 dir))

     ;; --- X / width / spacing ---

     (stem-x-extent (ly:grob-property grob 'X-extent))
     (stem-width (abs (- (car stem-x-extent) (cdr stem-x-extent))))

     ;; by default second stem is 1.5 times as thick as standard stem
     (width-scale (ly:grob-property grob 'cn-double-stem-width-scale 1.5))
     (stem2-width (* stem-width width-scale))

     ;; amount to move the edges outward to achieve 2nd stem width
     (width-shift (/ (abs (- stem-width stem2-width)) 2))

     ;; spacing is 3.5 times stem-width by default
     (spacing-scale (ly:grob-property grob 'cn-double-stem-spacing 3.5))
     (spacing-shift (* dir spacing-scale stem-width))

     (stem-left-edge (car stem-x-extent))
     (stem-right-edge (cdr stem-x-extent))

     (stem2-left-edge (+ spacing-shift stem-left-edge (* -1 width-shift)))
     (stem2-right-edge (+ spacing-shift stem-right-edge width-shift))

     ;; Note that SVG output needs extents pairs to be in proper ascending order
     (stem2-x-extent (cons stem2-left-edge stem2-right-edge))

     ;; --- Y / length ---

     (stem-y-extent (ly:grob-property grob 'Y-extent))
     (note-heads (cn-note-heads-from-grob grob '()))
     (heads-edge (cn-grobs-edge note-heads up-stem))
     (stem-tip (if up-stem (cdr stem-y-extent) (car stem-y-extent)))

     (stem2-y-extent (if up-stem
                         (cons heads-edge stem-tip)
                         (cons stem-tip heads-edge)))

     (blot (ly:output-def-lookup (ly:grob-layout grob) 'blot-diameter))

     (stem2-stil (ly:round-filled-box stem2-x-extent stem2-y-extent blot)))

    (ly:grob-set-property! grob 'stencil
      (ly:stencil-add stem-stil stem2-stil))
    ;; X-extent needs to be set here because its usual callback
    ;; ly:stem::width doesn't take the actual stencil width into account
    (ly:grob-set-property! grob 'X-extent
      (ly:stencil-extent (ly:grob-property grob 'stencil) 0))
    ))

#(define (cn-multiply-details details multiplier skip-list)
   ;; multiplies each of the values of a details property
   ;; (e.g. of the stem grob) by multiplier, except for
   ;; skip-list, a list of symbols, e.g. '(stem-shorten)
   (define multiply-by (lambda (x) (* x multiplier)))
   (map
    (lambda (dt)
      (let ((head (car dt))
            (vals (cdr dt)))
        (cons head (if (memq head skip-list)
                       vals
                       (map multiply-by vals)))))
    details))

#(define (cn-customize-stem grob double-stems)
   ;; Lengthen all stems to undo staff compression side effects,
   ;; and give half notes double stems.
   (let* ((bss-inverse (/ 1 (cn-get-base-staff-space grob)))
          (deets (ly:grob-property grob 'details))
          (deets2 (cn-multiply-details deets bss-inverse '(stem-shorten))))

     (ly:grob-set-property! grob 'details deets2)

     ;; double stems for half notes
     (if (and double-stems
              (= 1 (ly:grob-property grob 'duration-log)))
         (cn-double-stem grob))))

#(define (cn-make-stem-grob-callback double-stems)
   ;; Make sure omit is not in effect (i.e. stencil is not #f)
   ;; and the stem has a notehead (i.e. is not for a rest,
   ;; rest grobs have stem grobs that have no stencil)
   (lambda (grob)
     (if (and (ly:grob-property-data grob 'stencil)
              (not (null? (ly:grob-object grob 'note-heads))))
         (cn-customize-stem grob double-stems))))

%--- CROSS-STAFF STEMS ----------------

% Needed for cross-staff stems for double stemmed half notes.
% Code modified from music-functions.scm. Used with \crossStaff function.
% Procedures have been encapsulated inside cn-make-stem-spans!.

#(define (cn-make-stem-spans! ctx stems trans)
   ;; Create stem spans for cross-staff stems

   (define (close-enough? x y)
     ;; Values are close enough to ignore the difference
     (< (abs (- x y)) 0.0001))

   (define (extent-combine extents)
     ;; Combine a list of extents
     (if (pair? (cdr extents))
         (interval-union (car extents) (extent-combine (cdr extents)))
         (car extents)))

   (define ((stem-connectable? ref root) stem)
     ;; Check if the stem is connectable to the root
     ;; The root is always connectable to itself
     (or (eq? root stem)
         (and
          ;; Horizontal positions of the stems must be almost the same
          (close-enough? (car (ly:grob-extent root ref X))
            (car (ly:grob-extent stem ref X)))
          ;; The stem must be in the direction away from the root's notehead
          (positive? (* (ly:grob-property root 'direction)
                       (- (car (ly:grob-extent stem ref Y))
                         (car (ly:grob-extent root ref Y))))))))

   (define (stem-span-stencil span)
     ;; Connect stems if we have at least one stem connectable to the root
     (let* ((system (ly:grob-system span))
            (root (ly:grob-parent span X))
            (stems (filter (stem-connectable? system root)
                           (ly:grob-object span 'stems))))
       (if (<= 2 (length stems))
           (let* ((yextents (map (lambda (st)
                                   (ly:grob-extent st system Y)) stems))
                  (yextent (extent-combine yextents))
                  (layout (ly:grob-layout root))
                  (blot (ly:output-def-lookup layout 'blot-diameter))

                  ;; START CLAIRNOTE EDITS

                  ;; we just get the 1st notehead, does it matter which?
                  (note-head (list-ref (cn-note-heads-from-grob root '()) 0)))

             ;; if is half note...
             (if (and note-head (= 1 (ly:grob-property note-head 'duration-log)))
                 ;; TODO: better cross staff double stems for half notes,
                 ;; and un-hardcode the following stem X extent, works
                 ;; fine with 'set-global-staff-size' but ugly with 'magnifyStaff'
                 (ly:round-filled-box '(-0.065 . 0.065) yextent blot)

                 (begin
                  ;; Hide spanned stems
                  (for-each (lambda (st)
                              (set! (ly:grob-property st 'stencil) #f))
                    stems)
                  ;; Draw a nice looking stem with rounded corners
                  (ly:round-filled-box (ly:grob-extent root root X) yextent blot))))

           ;; END CLAIRNOTE EDITS

           ;; Nothing to connect, don't draw the span
           #f)))

   (define ((make-stem-span! stems trans) root)
     ;; Create a stem span as a child of the cross-staff stem (the root)
     (let ((span (ly:engraver-make-grob trans 'Stem '())))
       (ly:grob-set-parent! span X root)
       (set! (ly:grob-object span 'stems) stems)
       ;; Suppress positioning, the stem code is confused by this weird stem
       (set! (ly:grob-property span 'X-offset) 0)
       (set! (ly:grob-property span 'stencil) stem-span-stencil)))

   (define (stem-is-root? stem)
     ;; Check if automatic connecting of the stem was requested.  Stems connected
     ;; to cross-staff beams are cross-staff, but they should not be connected to
     ;; other stems just because of that.
     (eq? cross-staff-connect (ly:grob-property-data stem 'cross-staff)))

   ;; make-stem-spans! continued..

   ;; Cannot do extensive checks here, just make sure there are at least
   ;; two stems at this musical moment
   (if (<= 2 (length stems))
       (let ((roots (filter stem-is-root? stems)))
         (for-each (make-stem-span! stems trans) roots))))

% overwrites the default engraver in order to call custom cn-make-stem-spans!
#(define (Cn_span_stem_engraver ctx)
   ;; Connect cross-staff stems to the stems above in the system
   (let ((stems '()))
     (make-engraver
      ;; Record all stems for the given moment
      (acknowledgers
       ((stem-interface trans grob source)
        (set! stems (cons grob stems))))
      ;; Process stems and reset the stem list to empty
      ((process-acknowledged trans)
       (cn-make-stem-spans! ctx stems trans)
       (set! stems '())))))

% It's ugly, but we store the default LilyPond
% Span_stem_engraver procedure so we can set a local
% "Span_stem_engraver" depending on the version of Clairnote.
#(define LilyPond_span_stem_engraver Span_stem_engraver)
#(define Span_stem_engraver Span_stem_engraver)


%--- DOTS ON DOTTED NOTES ----------------

#(define (cn-highest-semitone note-heads)
   (reduce max -inf.0 (map cn-notehead-semitone note-heads)))

#(define (cn-make-dots-callback is-rhythmic-staff)
   ;; Avoid collision between double-stem and dots by shifting right the dots
   ;; on double-stemmed half notes but only when they are on a staff line,
   ;; have an up stem, and are the highest note in their column.
   ;; We use a callback here so that the stem width is already set.
   ;; Returns a procedure that returns pair of numbers or #f for the
   ;; Dots.extra-offset grob property.
   (lambda (dots-grob)
     (let*
      ((parent (ly:grob-parent dots-grob Y))
       ;; parent is a Rest grob or a NoteHead grob
       (note-head (and (not (grob::has-interface parent 'rest-interface)) parent))
       (semi '())
       (stem '()))
      (and note-head

           ;; is half note?
           (= 1 (ly:grob-property note-head 'duration-log))

           ;; is line note?
           (begin (set! semi (cn-notehead-semitone note-head))
             (or (= 0 (modulo semi 4)) is-rhythmic-staff))

           ;; is up-stem?
           (begin (set! stem (ly:grob-object (ly:grob-parent note-head X) 'stem))
             stem)
           (not (null? stem))
           (= 1 (ly:grob-property stem 'direction))

           ;; is highest note?
           (let* ((note-heads (cn-note-heads-from-grob stem '())))
             (or (= 1 (length note-heads))
                 (= semi (cn-highest-semitone note-heads))))

           ;; return a pair for Dots.extra-offset
           ;; maybe a better calculation is possible based on custom
           ;; double stem Staff context properties, but that would take
           ;; an engraver to access it, and Dots engraver is in Voice context
           (let* ((stem-extent (ly:grob-property stem 'X-extent))
                  (stem-width (- (cdr stem-extent) (car stem-extent)))
                  (x-offset (* 0.75 stem-width)))
             (cons x-offset 0))
           ))))


%--- BEAMS ----------------

#(define (cn-beam-grob-callback grob)
   ;; Adjust size and spacing of beams.
   ;; Needed due to vertically compressed staff.
   (let* ((bss-inverse (/ 1 (cn-get-base-staff-space grob)))
          (thick (ly:grob-property grob 'beam-thickness))
          (len-frac (ly:grob-property grob 'length-fraction))
          (space (if (number? len-frac) len-frac 1)))

     ;; TODO: the 1.1 adjustment below was just visually estimated
     (ly:grob-set-property! grob 'length-fraction (* space 1.1 bss-inverse))
     (ly:grob-set-property! grob 'beam-thickness (* thick bss-inverse))
     ))


%--- LEDGER LINES ----------------

% Ledger line recipes for Clairnote DN and SN
% Usually: cycle = octave = 12
%
% '(staff-positions-per-cycle
%   ((ledger-position-in-a-cycle further-add nearer-drop)
%    ...))
%
% further-add is like lilypond's ledger-extra, for adding
% extra ledgers when they are this far (or less) beyond the note
% (reasonable vals: 1, 2, 5, 6).
%
% nearer-drop can be #f or a number and is for (optionally) not
% drawing ledgers further than this from the note, in the
% direction of the nearest staff line (reasonable vals: 2, 5).

% Default, gradual, conservative.
#(define cn-dn-ledgers-gradual
   '(12 ((4 2 5)
         (8 2 #f)
         (12 2 #f))))

% Jumps to two ledger lines immediately,
% and omits c ledger line quickly.
#(define cn-dn-ledgers-less-gradual
   '(12 ((4 2 2)
         (8 2 #f)
         (12 5 #f))))

% Doesn't omit the C ledger line.
#(define cn-dn-ledgers-keep-c-ledgers
   '(12 ((4 2 #f)
         (8 2 #f)
         (12 2 #f))))

% Default, gradual, conservative.
#(define cn-sn-ledgers-gradual
   '(12 ((2 0 0)
         (4 2 5)
         (6 0 0)
         (8 2 #f)
         (10 0 0)
         (12 2 #f))))

% Jumps to two ledger lines immediately,
% and omits c ledger line quickly.
#(define cn-sn-ledgers-less-gradual
   '(12 ((2 0 0)
         (4 2 2)
         (6 0 0)
         (8 2 #f)
         (10 0 0)
         (12 5 #f))))

% Doesn't omit the C ledger line.
#(define cn-sn-ledgers-keep-c-ledgers
   '(12 ((2 0 0)
         (4 2 #f)
         (6 0 0)
         (8 2 #f)
         (10 0 0)
         (12 2 #f))))

#(define (cn-ledger-pattern dist staff-symbol)
   ;; Produces the ledger line pattern for a given note.
   ;; dist is distance of note from closest staff line.

   ;; A cycle is generally an octave, so cycle-size is
   ;; 12 (staff positions per octave) and cycle-count
   ;; is the number of octaves we are dealing with.
   (let*
    ((recipe (ly:grob-property staff-symbol 'cn-ledger-recipe cn-dn-ledgers-gradual))
     (cycle-size (list-ref recipe 0))
     (configs (list-ref recipe 1))
     (cycle-count (+ 1 (quotient dist cycle-size)))
     (config-to-ledgers
      (lambda (config)
        (let*
         ((ledger-posn (list-ref config 0))
          (further-add (list-ref config 1))
          (nearer-drop (list-ref config 2))
          (furthest (+ dist further-add))
          (nearest (if nearer-drop (- dist nearer-drop) 0))
          ;; Generate the list of ledgers in descending order.
          (ledgers (reverse (iota cycle-count ledger-posn cycle-size)))
          (in-range (lambda (l) (and (<= l furthest)
                                     (>= l nearest)))))
         (filter in-range ledgers))))
     (ledger-lists (map config-to-ledgers configs))

     ;; When there is an accidental sign on a note, LilyPond may
     ;; shorten the furthest ledger, the first in the list.
     ;; So we merge into one list, keeping descending order
     (ledger-list (fold (lambda (lst result) (merge lst result >))
                    '() ledger-lists))
     ;; But if the note is on a ledger, move that ledger to the
     ;; front of the list, so that ledger will be shortened.
     (ledger-list2 (if (memv dist ledger-list)
                       (cons dist (delv dist ledger-list))
                       ledger-list)))
    ledger-list2))

#(define cn-ledger-positions
   ;; A function that takes a StaffSymbol grob and a vertical
   ;; position of a note head and returns a list of ledger line positions,
   ;; based on StaffSymbol.cn-ledger-recipe."
   '(lambda (staff-symbol pos)
      (let*
       ((lines (ly:grob-property staff-symbol 'line-positions '(-8 -4 4 8)))

        (nearest-line
         (fold (lambda (line prev)
                 (if (< (abs (- line pos)) (abs (- prev pos)))
                     line
                     prev))
           (car lines)
           (cdr lines)))

        (diff (- pos nearest-line))
        (dist (abs diff))
        (dir (if (negative? diff) -1 1))

        ;; get generic ledger positions and then transform them so
        ;; they are relative to nearest-line and in the right direction
        (ledgers0 (cn-ledger-pattern dist staff-symbol))
        (ledgers1 (map (lambda (n) (+ nearest-line (* dir n)))
                    ledgers0))

        ;; remove any ledgers that would fall on staff lines
        (ledgers2 (filter (lambda (n) (not (member n lines)))
                          ledgers1)))
       ledgers2)))


%--- ARTICULATIONS (SCRIPT GROBS) ----------------

#(define (cn-script-y-offset-callback grob default-value)
   ;; Script grobs (articulations) collide with ledgers that
   ;; are further from the staff than the note head, so we
   ;; have to adjust their vertical position.
   (let*
    ((direction (ly:grob-property grob 'direction))
     (note-head (ly:grob-parent grob X))
     (nh-pos (ly:grob-staff-position note-head))

     (staff-symbol (ly:grob-object grob 'staff-symbol))
     (ledger-function (eval cn-ledger-positions
                        (interaction-environment)))
     (ledger-posns (ledger-function staff-symbol nh-pos))

     (max-or-min (if (> direction 0) max min))
     (ledger-pos (reduce max-or-min 0 ledger-posns))
     (diff (- (abs ledger-pos) (abs nh-pos)))
     (adjust (if (> diff 0)
                 (* direction (- diff 1))
                 0))
     (staff-space (ly:grob-property staff-symbol 'staff-space))
     (note-space (* 0.5 staff-space))
     (final-adjust (* adjust note-space)))
    (+ default-value final-adjust)))


%--- USER: EXTENDING STAVES & DIFFERENT OCTAVE SPANS ----------------

#(define (cn-get-new-staff-positions posns base-positions going-up going-down)

   (define recurser (lambda (proc posns extension n)
                      (if (<= n 0)
                          posns
                          (recurser proc (proc posns extension) extension (- n 1)))))

   (define (extend-up posns extension)
     (let ((furthest (reduce max '() posns)))
       (append posns (map (lambda (ext) (+ furthest ext)) extension))))

   (define (extend-down posns extension)
     (let ((furthest (reduce min '() posns)))
       (append (map (lambda (ext) (- furthest ext)) extension) posns)))

   (let*
    ((max-bp (reduce max '() base-positions))
     (min-bp (reduce min '() base-positions))
     ;; the number of empty positions between staves from one octave to the next
     ;; 8 for Clairnote
     (gap (+ min-bp (- 12 max-bp)))

     ;; relative locations of a new octave of staff lines,
     ;; as if 0 is the the furthest current staff line.  '(8 12) for Clairnote
     (extension (map (lambda (bp) (+ bp gap (- min-bp))) base-positions))
     (extension-length (length extension))

     (posns-up
      (cond
       ((positive? going-up) (recurser extend-up posns extension going-up))
       ((negative? going-up)
        (if (> (length posns) extension-length)
            (drop-right (sort posns <) extension-length)
            (begin
             (ly:warning "\\cnUnextendStaffUp failed, not enough staff to unextend")
             posns)))
       (else posns)))

     (posns-down
      (cond
       ((positive? going-down) (recurser extend-down posns-up extension going-down))
       ((negative? going-down)
        (if (> (length posns) extension-length)
            (drop (sort posns <) extension-length)
            (begin
             (ly:warning "\\cnUnextendStaffDown failed, not enough staff to unextend")
             posns)))
       (else posns-up))))

    posns-down))

#(define cnStaffExtender
   (define-music-function
    (reset going-up going-down)
    (boolean? integer? integer?)
    #{
      \context Staff \applyContext
      #(lambda (context)
         (if (not (eqv? 'TradStaff (ly:context-name context)))
             (let*
              ((grob-def (ly:context-grob-definition context 'StaffSymbol))
               (current-lines (ly:assoc-get 'line-positions grob-def '(-8 -4 4 8)))
               ;; base is '(-8 -4) or '(-2 2) for Clairnote
               (base-lines (ly:context-property context 'cnBaseStaffLines))
               (posns (if reset base-lines current-lines))
               (new-posns (cn-get-new-staff-positions posns base-lines going-up going-down)))
              (ly:context-pushpop-property context 'StaffSymbol 'line-positions new-posns))))
      \stopStaff
      \startStaff
    #}))

#(define cnExtendStaffUp #{ \cnStaffExtender ##f 1 0 #})
#(define cnExtendStaffDown #{ \cnStaffExtender ##f 0 1 #})
#(define cnUnextendStaffUp #{ \cnStaffExtender ##f -1 0 #})
#(define cnUnextendStaffDown #{ \cnStaffExtender ##f 0 -1 #})

#(define cnStaffOctaveSpan
   (define-music-function (octaves) (positive-integer?)
     ;; odd octaves: extended the same amount up and down (from 1)
     ;; even octaves: extended up one more than they are down
     (let*
      ((odd-octs (odd? octaves))
       (base-lines (if odd-octs '(-2 2) '(-8 -4)))
       (n (/ (1- octaves) 2))
       (upwards (if odd-octs n (ceiling n)))
       (downwards (if odd-octs n (floor n))))
      #{
        \set Staff.cnStaffOctaves = #octaves
        \override Staff.StaffSymbol.cn-staff-octaves = #octaves
        \set Staff.cnBaseStaffLines = #base-lines
        \override Staff.StaffSymbol.ledger-positions = #base-lines
        \cnStaffExtender ##t #upwards #downwards
      #})))

#(define cnClefPositionShift
   (define-music-function (octaves) (integer?)
     #{
       \set Staff.cnClefShift = #octaves
       \override Staff.StaffSymbol.cn-clef-shift = #octaves
       \stopStaff
       \startStaff
     #}))


%--- USER: ALTERNATE STAVES (EXPERIMENTAL) ----------------

#(define cnFiveLineStaff
   #{
     \cnStaffOctaveSpan 2
     \override Staff.StaffSymbol.line-positions = #'(-8 -4 0 4 8)
   #})

#(define cnFourLineStaff
   #{
     \cnStaffOctaveSpan 2
     \override Staff.StaffSymbol.line-positions = #'(-8 -4 0 4)
   #})


%--- USER: SET STAFF COMPRESSION ----------------

%% must be used before \magnifyStaff for both to work
#(define cnStaffCompression
   (define-music-function (ss) (number?)
     ;; 0.75 is the default Clairnote staff-space (ss). An ss arg of
     ;; 1 gives an uncompressed staff. 7/12 gives a staff with
     ;; same size octave as traditional
     (let*
      ((trad-octave (/ (round (* 10000 (exact->inexact (* 12/7 ss)))) 10000))
       (notehead-overlap (+ 0.5 (- 0.5 (/ ss 2)))))
      (ly:message
       "Clairnote: custom staff compression of ~a will produce octaves ~a times the size of octaves in traditional notation; adjacent note heads (a semitone apart) will overlap by about ~a of their height."
       ss trad-octave notehead-overlap)
      #{
        \override Staff.StaffSymbol.cn-base-staff-space = #ss
        \override Staff.StaffSymbol.staff-space = #ss
      #})))


%--- USER: CUSTOMIZE NOTEADS ----------------


#(define (cn-set-notehead-style! stencil stem-attachment rotation)
   #{
     \override Staff.NoteHead.stencil = #stencil
     \override Staff.NoteHead.stem-attachment = #stem-attachment
     \override Staff.NoteHead.rotation = #rotation
   #})

#(define cnNoteheadStyle
   (define-music-function (style) (string?)
     (cond

      ((string=? "funksol" style)
       (cn-set-notehead-style!
        ;; 1.4 width-scale results in approx. width of standard LilyPond noteheads.
        (cn-make-note-head-stencil-callback
         cn-funksol-note-head-stencil
         cn-white-note?
         1.35 1)
        (cn-make-stem-attachment-callback '(1 . 0.2) '(1 . 0.2))
        #f))

      ((string=? "lilypond" style)
       (cn-set-notehead-style!
        (cn-make-note-head-stencil-callback
         cn-lilypond-note-head-stencil
         cn-white-note?
         1 1)
        ;; needed because of rotation and white note horizontal scaling
        (cn-make-stem-attachment-callback '(1.04 . 0.3) '(1.06 . 0.3))
        ;; black notes can be rotated as far as -27,
        ;; but -18 also works for white notes, currently -9
        (cn-make-note-head-rotation-callback '(-9 0 0))))

      (else
       (if (not (string=? "default" style))
           (ly:warning
            "unrecognized style ~s used with \\cnNoteheadStyle, using default instead."
            style))
       (cn-set-notehead-style!
        cn-default-note-head-stencil-callback
        ly:note-head::calc-stem-attachment
        #f))
      )))


%--- CUSTOM PROPERTIES ----------------

% Define custom context properties and grob properties.

#(let*
  ;; translator-property-description function
  ;; from "scm/define-context-properties.scm" (modified)
  ((context-prop
    (lambda (symbol type?)
      (set-object-property! symbol 'translation-type? type?)
      (set-object-property! symbol 'translation-doc "custom context property")
      (set! all-translation-properties (cons symbol all-translation-properties))
      symbol))

   ;; define-grob-property function
   ;; from "scm/define-grob-properties.scm" (modified)
   (grob-prop
    (lambda (symbol type?)
      (set-object-property! symbol 'backend-type? type?)
      (set-object-property! symbol 'backend-doc "custom grob property")
      symbol)))

  ;; For Staff contexts or StaffSymbol grobs unless otherwise noted.
  ;; Some values need to be accessed by both custom engravers and grob
  ;; callbacks so they are kept in both grob and context properties.

  ;; For accidental signs, stores a version of localAlterations
  ;; keyed by semitone instead of by (octave . notename)
  (context-prop 'cnSemiAlterations list?)

  ;; For accidental signs, stores alterations keyed by
  ;; (octave . notename).  Needed for looking up alterations to
  ;; calculate semitones for invalidated entries in localAlterations.
  (context-prop 'cnAlterations list?)

  ;; Stores the base staff line positions used for extending the staff
  ;; up or down. See cnExtendStaff function.
  (context-prop 'cnBaseStaffLines list?)

  ;; Indicates number of octaves the staff spans, lets us use
  ;; different clef settings so stems always flip at center of staff.
  (context-prop 'cnStaffOctaves positive-integer?)
  (grob-prop 'cn-staff-octaves positive-integer?)

  ;; For moving clef position up or down by one or more octaves.
  (context-prop 'cnClefShift integer?)
  (grob-prop 'cn-clef-shift integer?)

  ;; For Clef grobs, makes clef transposition accessible.
  (grob-prop 'cn-clef-transposition integer?)

  ;; Base staff-space for the vertical compression of the Clairnote staff.
  ;; Actual staff-space may differ with \magnifyStaff, etc.
  ;; Affects stem and beam size, time sig, key sig position, etc.
  (grob-prop 'cn-base-staff-space positive?)

  ;; Used for repeat sign dots.
  (grob-prop 'cn-is-clairnote-staff boolean?)

  ;; For KeySignature grobs, stores the tonic note of the key.
  ;; The 'tonic context property turned into a grob property.
  (grob-prop 'cn-tonic ly:pitch?)

  ;; For Stem grobs, for double stems for half notes.
  (grob-prop 'cn-double-stem-spacing number?)
  (grob-prop 'cn-double-stem-width-scale non-zero?)

  ;; Used to produce ledger line pattern.
  (grob-prop 'cn-ledger-recipe list?))


%--- STAFF CONTEXT DEFINITION ----------------

% These variables are set below on initialization.
clairnoteTypeName = ""
clairnoteTypeUrl = ""

\layout {
  % Copy standard settings of Staff and RhythmicStaff contexts
  % to custom contexts named TradStaff and TradRhythmicStaff.
  \context {
    \Staff
    \name TradStaff
    \alias Staff
    % custom grob property
    \override StaffSymbol.cn-is-clairnote-staff = ##f
  }
  \inherit-acceptability "TradStaff" "Staff"

  \context {
    \RhythmicStaff
    \name TradRhythmicStaff
    \alias RhythmicStaff
  }
  \inherit-acceptability "TradRhythmicStaff" "RhythmicStaff"

  \context {
    \Score
    % prevents barlines at start of single (2-octave) system from being shown
    \override SystemStartBar.collapse-height = #9
  }

  % customize Staff context to make it a Clairnote staff
  \context {
    \Staff

    % CONTEXT PROPERTIES
    % traditional clef settings are immediately converted to
    % clairnote settings by custom clef engraver
    clefGlyph = "clefs.G"
    clefPosition = -2
    middleCClefPosition = -6
    clefTransposition = 0
    middleCPosition = -12

    staffLineLayoutFunction = #ly:pitch-semitones
    printKeyCancellation = ##f
    \numericTimeSignature

    cnBaseStaffLines = #'(-8 -4)
    cnStaffOctaves = #2
    cnClefShift = #0

    % accidental styles set three context properties:
    % extraNatural, autoAccidentals, and autoCautionaries
    \accidentalStyle "clairnote-default"

    % GROB PROPERTIES
    \override StaffSymbol.cn-staff-octaves = #2
    \override StaffSymbol.cn-clef-shift = #0
    \override StaffSymbol.line-positions = #'(-8 -4 4 8)

    % staff-space reflects vertical compression of Clairnote staff.
    % Default of 0.75 makes the Clairnote octave 1.28571428571429
    % times the size of the traditional octave (3/4 * 12/7 = 9/7).
    % Adjacent note heads overlap by 0.625 (5/8).
    \override StaffSymbol.staff-space = #0.75

    % Custom grob property that stores the base staff-space, encoding
    % the vertical compression of the Clairnote staff. It may differ from
    % the actual staff-space which is scaled by \magnifyStaff etc.
    % Stem and beam size, time sig and key sig position depend on it.
    \override StaffSymbol.cn-base-staff-space = #0.75

    \override Stem.no-stem-extend = ##t

    \override Beam.before-line-breaking = #cn-beam-grob-callback

    \override Accidental.horizontal-skylines = #'()
    \override Accidental.vertical-skylines = #'()
    \override Accidental.stencil = #cn-accidental-grob-callback
    \override AccidentalCautionary.stencil = #cn-accidental-grob-callback
    \override AccidentalSuggestion.stencil = #cn-accidental-grob-callback
    \override AmbitusAccidental.stencil = #cn-accidental-grob-callback
    \override TrillPitchAccidental.stencil = #cn-accidental-grob-callback

    \override KeySignature.horizontal-skylines = #'()
    \override KeySignature.stencil = #cn-key-signature-grob-callback
    \override KeyCancellation.horizontal-skylines = #'()
    \override KeyCancellation.stencil =#cn-key-signature-grob-callback

    \override TimeSignature.before-line-breaking = #cn-time-signature-grob-callback

    % TODO: whole note ledger lines are a bit too wide
    \override LedgerLineSpanner.length-fraction = 0.45
    \override LedgerLineSpanner.minimum-length-fraction = 0.35

    \override Script.Y-offset =
    #(grob-transformer 'Y-offset cn-script-y-offset-callback)

    \override Clef.stencil = #cn-clef-stencil-callback
    \override CueClef.stencil = #cn-clef-stencil-callback
    \override CueEndClef.stencil = #cn-clef-stencil-callback
    \override ClefModifier.stencil = ##f

    \override Stem.note-collision-threshold = 2
    \override NoteCollision.note-collision-threshold = 2

    \override StaffSymbol.ledger-positions-function = #cn-ledger-positions

    % ENGRAVERS
    % There is also the customized Span_stem_engraver (added in LilyPond 2.19.??)
    % which does not need to be consisted here.
    \consists \Cn_clef_ottava_engraver
    \consists \Cn_key_signature_engraver
  }

  \context {
    \RhythmicStaff
    \numericTimeSignature
    \override StaffSymbol.cn-base-staff-space = #1
  }
}

% Function to customize the Staff context to make it
% a Clairnote DN (dual noteheads) staff.
initClairnoteDN =
#(define-scheme-function () ()
   (set! cn-white-note?
         (lambda (grob)
           (odd? (cn-notehead-semitone grob))))

   (set! cn-default-note-head-stencil-callback
         (cn-make-note-head-stencil-callback
          cn-default-note-head-stencil
          cn-white-note?
          1 1))
   (set! Span_stem_engraver Cn_span_stem_engraver)
   (set! clairnoteTypeName "Clairnote DN")
   (set! clairnoteTypeUrl "http://clairnote.org/dn/")
   #{
     \layout {
       \context {
         \Staff
         \override NoteHead.stencil = \cn-default-note-head-stencil-callback
         \override AmbitusNoteHead.stencil = \cn-default-note-head-stencil-callback
         \override TrillPitchGroup.stencil = \cn-default-note-head-stencil-callback

         \override Stem.cn-double-stem-spacing = #3.5
         \override Stem.cn-double-stem-width-scale = #1.5
         \override Stem.before-line-breaking = #(cn-make-stem-grob-callback #t)

         % adjust x-axis dots position to not collide with double-stemmed half notes
         \override Dots.extra-offset = #(cn-make-dots-callback #f)

         \override StaffSymbol.cn-ledger-recipe = #cn-dn-ledgers-gradual
       }

       \context {
         \RhythmicStaff

         \override NoteHead.stencil =
         #(cn-make-note-head-stencil-callback
           cn-default-note-head-stencil
           ;; never draw white notes on RhythmicStaff
           (lambda (g) #f)
           1 1)

         \override Stem.cn-double-stem-spacing = #3.5
         \override Stem.cn-double-stem-width-scale = #1.5
         \override Stem.before-line-breaking = #(cn-make-stem-grob-callback #t)

         % adjust x-axis dots position to not collide with double-stemmed half notes
         \override Dots.extra-offset = #(cn-make-dots-callback #t)
       }

       % Special context for both SN and DN at once, like so:
       %
       % clairnote-type = dn
       % \include "clairnote.ly"  % creates StaffClairnoteDN context
       % \initClairnoteSN         % makes default Staff context SN
       %
       \context {
         \Staff
         \name StaffClairnoteDN
         \alias Staff
       }
       \inherit-acceptability "StaffClairnoteDN" "Staff"
     }
   #})


% Function to customize the Staff context to make it
% a Clairnote SN (single/standard noteheads) staff.
initClairnoteSN =
#(define-scheme-function () ()
   (set! cn-white-note?
         (lambda (grob)
           (<= (ly:grob-property grob 'duration-log) 1)))

   (set! cn-default-note-head-stencil-callback
         (cn-make-note-head-stencil-callback
          cn-default-note-head-stencil
          cn-white-note?
          1 1))
   (set! Span_stem_engraver LilyPond_span_stem_engraver)
   (set! clairnoteTypeName "Clairnote SN")
   (set! clairnoteTypeUrl "http://clairnote.org/sn/")
   #{
     \layout {
       \context {
         \Staff
         \override NoteHead.stencil = \cn-default-note-head-stencil-callback
         \override AmbitusNoteHead.stencil = \cn-default-note-head-stencil-callback
         \override TrillPitchGroup.stencil = \cn-default-note-head-stencil-callback

         \override Stem.before-line-breaking = #(cn-make-stem-grob-callback #f)

         \override StaffSymbol.cn-ledger-recipe = #cn-sn-ledgers-gradual
       }

       \context {
         \RhythmicStaff
         \override NoteHead.stencil = \cn-default-note-head-stencil-callback
         \override Stem.before-line-breaking = #(cn-make-stem-grob-callback #f)
       }
     }
   #})

% Let parent contexts accept TradStaff and TradRhythmicStaff
% in midi output.
\midi {
  \context {
    \Staff
    cnBaseStaffLines = #'(-8 -4)
  }

  \context {
    \Staff
    \name TradStaff
    \alias Staff
  }
  \inherit-acceptability "TradStaff" "Staff"

  \context {
    \RhythmicStaff
    \name TradRhythmicStaff
    \alias RhythmicStaff
  }
  \inherit-acceptability "TradRhythmicStaff" "RhythmicStaff"

  \context {
    \Staff
    \name StaffClairnoteDN
    \alias Staff
  }
  \inherit-acceptability "StaffClairnoteDN" "Staff"
}

initClairnoteType =
#(define-scheme-function () ()
   ;; Allows setting the Clairnote type via the commandline by
   ;; including a file that contains e.g. clairnote-type = sn
   (cond
    ((or (not (defined? 'clairnote-type))
         (string= clairnote-type "sn")
         (string= clairnote-type "default"))
     #{ \initClairnoteSN #})

    ((string= clairnote-type "dn")
     #{ \initClairnoteDN #})

    (else
     (ly:warning
      "unrecognized clairnote-type ~s, using default instead."
      clairnote-type)
     #{ \initClairnoteSN #})))

\initClairnoteType
