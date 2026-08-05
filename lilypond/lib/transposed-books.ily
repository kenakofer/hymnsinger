%% Traditional notation at four transpositions, for singers who need the tune
%% a semitone or two off the printed key. Each book is the trad book with
%% \transpose wrapped around it and the capo line removed.
%%
%% The pitch pair comes from \htTransposeFrom / \htTransposeTo, which read
%% \hymnKey and pick the target spelling with the fewest accidentals. See
%% transpose-common.ily for why the spelling cannot just be hard-coded.
\include "transpose-common.ily"

%% The four books differ only in output suffix and semitone shift, so the
%% source is built once as a template and fed to the parser per shift. It used
%% to be four copy-pasted blocks; that was fine until -dht-books arrived and
%% each one needed its own gate, at which point the duplication was four
%% places to keep in step instead of one.
%%
%% \bookOutputSuffix is a parse-time setting on the enclosing \book, which is
%% why this is string generation rather than a Scheme loop over \book objects.
#(define (ht-transposed-book suffix shift)
   (format #f "
\\book {
  \\prescore_text
  \\bookOutputSuffix \"~a\" \\score {
    \\removeWithTag #'(midionly slidesOnly capoOnly)
    \\transpose \\htTransposeFrom \\hymnKey \\htTransposeTo \\hymnKey #~a
    \\fillTradScore
      { \\removeWithTag #'(midionly slidesOnly) \\soprano }
      { \\removeWithTag #'(midionly slidesOnly) \\alto }
      { \\removeWithTag #'(midionly slidesOnly) \\tenor }
      { \\removeWithTag #'(midionly slidesOnly) \\bass }
      \\songChords
      \\tradStaffZoom
  }
  \\postscore_text
  \\extra_verses
}
" suffix shift))

#(for-each
  (lambda (spec)
    (if (ht-book? (car spec))
        (ly:parser-include-string
         (ht-transposed-book (car spec) (cdr spec)))))
  '(("trad-up1" . 1) ("trad-up2" . 2) ("trad-dn1" . -1) ("trad-dn2" . -2)))
