%% Plain lead sheet: melody and chord symbols, no fretboard diagrams. Emitted
%% at the printed key plus the same four transpositions the trad and fret
%% books offer (-lead, -lead-up1, -lead-up2, -lead-dn1, -lead-dn2).
%%
%% The site presents this and the two fret books as one "Chords" tab with a
%% frets toggle, so all three families need the same set of pitches behind
%% them - switching frets off must not silently drop you back to the printed
%% key.
%%
%% Unlike the fret books, this one is emitted for every song, chords or not:
%% without chords it is still a usable melody-only sheet, and it is what the
%% Leadsheet tab has always shown.
\include "transpose-common.ily"

%% Built as a string and re-parsed for the same reason transposed-books.ily
%% does it: \bookOutputSuffix is a parse-time setting on the enclosing \book,
%% and a \book is not a music expression, so it cannot come from a Scheme loop
%% over book objects.
%%
%% capoOnly is stripped from the transposed books only. At the printed key the
%% capo line is still correct and has always been shown here; once the music
%% moves, the fret it names no longer matches the key it was chosen for.
#(define (ht-lead-book suffix shift)
   (format #f "
\\book {
  \\prescore_text
  \\bookOutputSuffix \"~a\" \\score {
    \\removeWithTag #'(midionly slidesOnly~a)
    ~a
    \\fillTradLeadSheetScore
      { \\removeWithTag #'(midionly slidesOnly) \\soprano }
      \\songChords
      \\tradLeadSheetStaffZoom
  }
  \\postscore_text
  \\extra_verses
}
"
           suffix
           (if (= shift 0) "" " capoOnly")
           (if (= shift 0)
               ""
               (format #f "\\transpose \\htTransposeFrom \\hymnKey \\htTransposeTo \\hymnKey #~a"
                       shift))))

#(for-each
  (lambda (spec)
    (let ((suffix (if (string=? (car spec) "")
                      "lead"
                      (string-append "lead" (car spec)))))
      (if (ht-book? suffix)
          (ly:parser-include-string (ht-lead-book suffix (cdr spec))))))
  '(("" . 0) ("-up1" . 1) ("-up2" . 2) ("-dn1" . -1) ("-dn2" . -2)))
