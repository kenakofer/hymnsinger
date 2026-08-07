\version "2.24.0"

% Label art for the part-volume sliders: a grand staff carrying the SA chord
% on the treble stave and the TB chord on the bass. Rendered rather than drawn
% by hand so the clefs and note heads are the same glyphs as the scores.
\header { tagline = ##f }

\paper {
  indent = 0
  % Just wide enough for clef + chord. Any wider and the staff lines run on
  % past the notes, which reads as an empty bar rather than a label.
  line-width = 22\mm
  oddHeaderMarkup = ##f
  evenHeaderMarkup = ##f
  oddFooterMarkup = ##f
  evenFooterMarkup = ##f
  page-breaking = #ly:one-line-breaking
}

\score {
  \new PianoStaff <<
    \set PianoStaff.systemStartDelimiter = #'SystemStartBrace
    \new Staff <<
      \clef treble
      % Soprano over alto: the pair the top two sliders control.
      { \override Staff.TimeSignature.stencil = ##f
        \omit Staff.BarLine
        \once \override Score.NonMusicalPaperColumn.padding = #2 <c' a'>1 }
    >>
    \new Staff <<
      \clef bass
      % Tenor over bass.
      { \override Staff.TimeSignature.stencil = ##f
        \omit Staff.BarLine
        <e c'>1 }
    >>
  >>
  \layout {
    % Bigger relative to the line width, so the glyphs survive being drawn
    % ~40px wide in the sidebar.
    #(layout-set-staff-size 26)
    \context { \Score
      \override SpacingSpanner.strict-note-spacing = ##t
      proportionalNotationDuration = #(ly:make-moment 1/4)
    }
    \context { \PianoStaff
      \override StaffGrouper.staff-staff-spacing.basic-distance = #10
      \override StaffGrouper.staff-staff-spacing.padding = #1
    }
  }
}

% Rebuild the SVG inlined in _layouts/song-page.html with:
%   lilypond -dbackend=svg -dcrop -o out part-volume-grandstaff.ly
% then strip from out.cropped.svg: the point-and-click <a> wrappers, the tspan
% <style> block, and the mm width/height (keep the viewBox, so CSS sizes it).
% -dcrop trims to the ink, so line-width does not change the result - the
% aspect ratio comes from the brace, the clefs and the chord spacing.
