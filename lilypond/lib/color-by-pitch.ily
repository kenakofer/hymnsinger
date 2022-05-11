\language "english"
\version "2.20.0"
%%http://lsr.di.unimi.it/LSR/Item?id=890

% Two lines commented out below to allow submission to LSR
% Credits: code by Pierre Perol-Schneider and Paul Morris

%% http://lsr.di.unimi.it/LSR/Item?id=890
%% see also : http://lilypond.1069038.n5.nabble.com/LSR-Colored-notes-with-black-outlines-enhancement-td173243.html

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LSR workaround:
#(set! paper-alist (cons '("snippet" . (cons (* 230 mm) (* 170 mm))) paper-alist))
\paper {
  #(set-paper-size "snippet")
  tagline = ##f
}
\markup\vspace #.5
%#(set-global-staff-size 30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

coloredNoteHeads =
#(lambda (color-outline line-width offset)
   ;; @var{color-outline} is a boolean for whether
   ;; the outline is colored (#t) or the note head (#f).
   ;; @var{line-width} is a number, the width of
   ;; the outline, 7 is a good default.
   (lambda (grob)
     (let* ((fsz  (ly:grob-property grob 'font-size 0.0))

            (mult (magstep fsz))
            (stl empty-stencil)
            (dur-log (ly:grob-property grob 'duration-log))
            (pch (ly:event-property (event-cause grob) 'pitch))
            (pchWithOffset (modulo (- (ly:pitch-semitones pch) offset) 12))
            (nnm (ly:pitch-notename pch))
            (alt (ly:pitch-alteration pch))
            (clr (case pchWithOffset
                   ((0) (rgb-color .95 0 0))
                   ((1) (rgb-color 1 .5 .2))
                   ((2) (rgb-color .9 .6 0))
                   ((3) (rgb-color 1 1 .2))
                   ((4) (rgb-color .9 .9 0))
                   ((5) (rgb-color .5 .9 .2))
                   ((6) (rgb-color .2 1 .5))
                   ((7) (rgb-color 0 .8 .8))
                   ((8) (rgb-color 0 1 1))
                   ((9) (rgb-color 0 .5 1))
                   ((10) (rgb-color .8 .7 1))
                   ((11) (rgb-color .8 .2 .9))

                  ;;((1) (x11-color 'bisque))
                   ;;((2) (x11-color 'orange))
                   ;;((3) (x11-color 'orange))
                   ;;((4) yellow)
                   ;;((5) yellow)
                   ;;((6) green)
                   ;;((7) blue)
                   ;;((8) blue)
                   ;;((9) (x11-color 'purple))
                   ;;((10) (x11-color 'purple))
                   ;;((11) (x11-color 'brown))
                   ;;((12) (x11-color 'brown))
                   (else black)))
            (outline-clr (if color-outline clr black))
            (note-clr (if color-outline black clr)))

     (set! stl
           (cond
            ;; quarter notes and smaller
            ((> dur-log 1)
             (grob-interpret-markup grob
                #{
                  \markup {
                    \combine
                    \with-color #outline-clr
                    \path #(/ line-width 10)
                     #'((moveto   0.000  -0.200)
                        (curveto  0.000  -0.420   0.180  -0.542   0.420  -0.542)
                        (curveto  0.800  -0.542   1.318  -0.210   1.318   0.200)
                        (curveto  1.318   0.420   1.140   0.542   0.890   0.542)
                        (curveto  0.510   0.542   0.000   0.210   0.000  -0.200)
                        (closepath))
                    \translate #(cons (* 0.0002 line-width) 0)
                    \with-color #note-clr
                    \override #'(filled . #t)
                    \path #0.001
                    #'((moveto   0.000  -0.200)
                       (curveto  0.000  -0.420   0.180  -0.542   0.420  -0.542)
                       (curveto  0.800  -0.542   1.318  -0.210   1.318   0.200)
                       (curveto  1.318   0.420   1.140   0.542   0.890   0.542)
                       (curveto  0.510   0.542   0.000   0.210   0.000  -0.200)
                       (closepath))
                  }
                #}
               ))
            ;; half notes
            ((= dur-log 1)
             (grob-interpret-markup grob
               #{
                 \markup {
                    \combine
                    \with-color #outline-clr
                    \path #(/ line-width 10)
                    #'((moveto    0.000  -0.250)
                       (moveto    0.110  -0.270)
                       (curveto   0.110  -0.380   0.210  -0.435   0.280  -0.435)
                       (curveto   0.370  -0.435   0.600  -0.300   0.850  -0.135)
                       (curveto   1.100   0.030   1.273   0.140   1.273   0.270)
                       (curveto   1.273   0.350   1.200   0.440   1.090   0.440)
                       (curveto   1.040   0.440   0.850   0.350   0.600   0.185)
                       (curveto   0.200  -0.080   0.110  -0.150   0.110  -0.270)
                       (closepath)
                       (moveto    0.000  -0.250)
                       (curveto   0.000  -0.200   0.060   0.210   0.350   0.365)
                       (curveto   0.510   0.460   0.700   0.545   1.050   0.545)
                       (curveto   1.200   0.545   1.380   0.500   1.380   0.270)
                       (curveto   1.380   0.120   1.290  -0.140   1.120  -0.300)
                       (curveto   0.870  -0.500   0.520  -0.542   0.320  -0.542)
                       (curveto   0.200  -0.542   0.000  -0.530   0.000  -0.250)
                       (closepath))
                    \translate #(cons (* 0.0002 line-width) 0)
                    \with-color #note-clr
                    \override #'(filled . #t)
                    \path #0.001
                    #'((moveto    0.000  -0.250)
                       (lineto    0.110  -0.270)
                       (curveto   0.110  -0.380   0.210  -0.435   0.280  -0.435)
                       (curveto   0.370  -0.435   0.600  -0.300   0.850  -0.135)
                       (curveto   1.100   0.030   1.273   0.140   1.273   0.270)
                       (curveto   1.273   0.350   1.200   0.440   1.090   0.440)
                       (curveto   1.040   0.440   0.850   0.350   0.600   0.185)
                       (curveto   0.200  -0.080   0.110  -0.150   0.110  -0.270)
                       (lineto    0.000  -0.250)
                       (curveto   0.000  -0.200   0.060   0.210   0.350   0.365)
                       (curveto   0.510   0.460   0.700   0.545   1.050   0.545)
                       (curveto   1.200   0.545   1.380   0.500   1.380   0.270)
                       (curveto   1.380   0.120   1.290  -0.140   1.120  -0.300)
                       (curveto   0.870  -0.500   0.520  -0.542   0.320  -0.542)
                       (curveto   0.200  -0.542   0.000  -0.530   0.000  -0.250)
                       (closepath))
                  }
               #}
               ))
            ;; whole notes
            ((= dur-log 0)
             (grob-interpret-markup grob
              #{
                \markup {
                  \combine
                  \with-color #outline-clr
                  \path #(/ line-width 10)
                  #'((moveto    0.660  -0.190)
                     (curveto   0.540   0.000   0.560   0.310   0.710   0.415)
                     (curveto   0.900   0.530   1.210   0.410   1.330   0.210)
                     (curveto   1.450   0.030   1.460  -0.300   1.290  -0.410)
                     (curveto   1.100  -0.530   0.790  -0.410   0.660  -0.190)
                     (closepath)
                     (moveto    0.000   0.000)
                     (curveto   0.000  -0.350   0.549  -0.545   1.000  -0.545)
                     (curveto   1.450  -0.545   2.000  -0.340   2.000   0.000)
                     (curveto   2.000   0.350   1.470   0.545   1.000   0.545)
                     (curveto   0.530   0.545   0.000   0.350   0.000   0.000)
                     (closepath))
                  \translate #(cons (* 0.0002 line-width) 0)
                  \with-color #note-clr
                  \override #'(filled . #t)
                  \path #0.001
                    #'((moveto    0.000   0.000)
                       (lineto    0.660  -0.190)
                       (curveto   0.540   0.000   0.560   0.310   0.710   0.415)
                       (curveto   0.900   0.530   1.210   0.410   1.330   0.210)
                       (curveto   1.450   0.030   1.460  -0.300   1.290  -0.410)
                       (curveto   1.100  -0.530   0.790  -0.410   0.660  -0.190)
                       (lineto    0.000   0.000)
                       (curveto   0.000  -0.350   0.549  -0.545   1.000  -0.545)
                       (curveto   1.450  -0.545   2.000  -0.340   2.000   0.000)
                       (curveto   2.000   0.350   1.470   0.545   1.000   0.545)
                       (curveto   0.530   0.545   0.000   0.350   0.000   0.000)
                       (closepath))
                }
              #}
               ))
            ;; breve notes
            ((< dur-log 0)
             (grob-interpret-markup grob
               #{
                  \markup {
                    \combine
                    \with-color #outline-clr
                    \path #(/ line-width 10)
                    #'((moveto    0.560   0.100)
                       (curveto   0.560   0.270  0.630   0.460   0.850   0.460)
                       (curveto   1.140   0.460  1.385   0.220   1.385  -0.100)
                       (curveto   1.385  -0.300  1.300  -0.455   1.110  -0.455)
                       (curveto   0.810  -0.455  0.560  -0.220   0.560   0.100)
                       (closepath)
                       (moveto  -0.160   0.000)
                       (lineto   -0.160  -0.610)
                       (curveto  -0.160  -0.657 -0.122  -0.700  -0.075  -0.700)
                       (curveto  -0.028  -0.700  0.010  -0.657   0.010  -0.610)
                       (lineto    0.010  -0.090)
                       (curveto   0.080  -0.350  0.510  -0.540   0.975  -0.540)
                       (curveto   1.480  -0.540  1.850  -0.350   1.940  -0.090)
                       (lineto    1.940  -0.610)
                       (curveto   1.940  -0.657  1.980  -0.700   2.025  -0.700)
                       (curveto   2.070  -0.700  2.110  -0.657   2.115  -0.610)
                       (lineto    2.115   0.610)
                       (curveto   2.115   0.657  2.070   0.700   2.025   0.700)
                       (curveto   1.980   0.700  1.940   0.657   1.940   0.610)
                       (lineto    1.940   0.090)
                       (curveto   1.850   0.370  1.430   0.545   0.975   0.545)
                       (curveto   0.520   0.550  0.070   0.350   0.010   0.090)
                       (lineto    0.010   0.610)
                       (curveto   0.010   0.657 -0.028   0.700  -0.075   0.700)
                       (curveto  -0.122   0.700 -0.160   0.657  -0.160   0.610)
                       (lineto   -0.160   0.100)
                       (closepath))
                   \translate #(cons (* 0.0002 line-width) 0)
                   \with-color #note-clr
                   \override #'(filled . #t)
                   \path #0.001
                    #'((moveto   -0.160   0.000)
                       (lineto    0.560   0.100)
                       (curveto   0.560   0.270  0.630   0.460   0.850   0.460)
                       (curveto   1.140   0.460  1.385   0.220   1.385  -0.100)
                       (curveto   1.385  -0.300  1.300  -0.455   1.110  -0.455)
                       (curveto   0.810  -0.455  0.560  -0.220   0.560   0.100)
                       (lineto   -0.160   0.000)
                       (lineto   -0.160  -0.610)
                       (curveto  -0.160  -0.657 -0.122  -0.700  -0.075  -0.700)
                       (curveto  -0.028  -0.700  0.010  -0.657   0.010  -0.610)
                       (lineto    0.010  -0.090)
                       (curveto   0.080  -0.350  0.510  -0.540   0.975  -0.540)
                       (curveto   1.480  -0.540  1.850  -0.350   1.940  -0.090)
                       (lineto    1.940  -0.610)
                       (curveto   1.940  -0.657  1.980  -0.700   2.025  -0.700)
                       (curveto   2.070  -0.700  2.110  -0.657   2.115  -0.610)
                       (lineto    2.115   0.610)
                       (curveto   2.115   0.657  2.070   0.700   2.025   0.700)
                       (curveto   1.980   0.700  1.940   0.657   1.940   0.610)
                       (lineto    1.940   0.090)
                       (curveto   1.850   0.370  1.430   0.545   0.975   0.545)
                       (curveto   0.520   0.550  0.070   0.350   0.010   0.090)
                       (lineto    0.010   0.610)
                       (curveto   0.010   0.657 -0.028   0.700  -0.075   0.700)
                       (curveto  -0.122   0.700 -0.160   0.657  -0.160   0.610)
                       (lineto   -0.160   0.100)
                       (closepath))
                  }
               #}
               ))
            ))

     (set! (ly:grob-property grob 'stencil)
           (ly:stencil-scale stl mult mult)))))

%%%% USAGE EXAMPLE %%%%

music =
\relative f' {
  \key c \major
  c4 d e f
  g4 a b c
  d2 e f2 g
  a1 b c
  c,,16 cs d ds e f fs g gs a as b c
}
bottom =
\relative f' {
  c4 c c d8 e
  f8 g a4 b c
  d2 e f2 g
  a1 b c
}

\markup\italic "Thin (#1) outlines:"
\new Staff
\with {
  \override NoteHead.layer = #2
  \override NoteHead.before-line-breaking = #(coloredNoteHeads #f 2 0)
}
{ \partCombine #'(2 . 9) \music \bottom }

%%% LSR workaround
\markup\vspace #.5
