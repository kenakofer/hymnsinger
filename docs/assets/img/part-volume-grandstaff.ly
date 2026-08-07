\version "2.24.0"

% Label art for the part-volume sliders: a grand staff with the four voices
% the sliders control, in the stem directions the scores use - soprano and
% tenor up, alto and bass down. Rendered rather than drawn by hand so the
% glyphs are the same Emmentaler ones the engravings use.
\header { tagline = ##f }

\paper {
  indent = 0
  line-width = 22\mm
  oddHeaderMarkup = ##f
  evenHeaderMarkup = ##f
  oddFooterMarkup = ##f
  evenFooterMarkup = ##f
  page-breaking = #ly:one-line-breaking
}

% Two voices per staff rather than a chord: a chord gets one shared stem, and
% the stem directions are the whole point - they are what says which note is
% which voice.
grandStaffLabel = \new PianoStaff <<
  \set PianoStaff.systemStartDelimiter = #'SystemStartBrace
  \new Staff <<
    \clef treble
    \override Staff.TimeSignature.stencil = ##f
    \omit Staff.BarLine
    \new Voice { \voiceOne c''2 }
    \new Voice { \voiceTwo a'2 }
  >>
  \new Staff <<
    \clef bass
    \override Staff.TimeSignature.stencil = ##f
    \omit Staff.BarLine
    \new Voice { \voiceOne g2 }
    \new Voice { \voiceTwo c2 }
  >>
>>

\score {
  \grandStaffLabel
  \layout {
    % Bigger relative to the line width, so the glyphs survive being drawn
    % ~40px wide in the sidebar.
    #(layout-set-staff-size 26)
    \context { \Score
      \override SpacingSpanner.strict-note-spacing = ##t
      % Keeps the heads clear of the clef, which they otherwise touch.
      \override NonMusicalPaperColumn.padding = #1.5
      % Matches the half notes, so the staff stops just past them instead of
      % reserving the rest of a measure it never draws.
      proportionalNotationDuration = #(ly:make-moment 1/2)
    }
    \context { \PianoStaff
      % Wide gap between the staves: the label sits in a narrow column beside
      % the sliders, so it wants to be taller than wide, and the air between
      % the staves is what separates SA from TB at a glance.
      \override StaffGrouper.staff-staff-spacing.basic-distance = #18
      \override StaffGrouper.staff-staff-spacing.padding = #1
    }
  }
}

% Rebuild the SVG inlined in _layouts/song-page.html with:
%   lilypond -dbackend=svg -dcrop -o out part-volume-grandstaff.ly
% then strip from out.cropped.svg: the point-and-click <a> wrappers, the tspan
% <style> block, and the mm width/height (keep the viewBox, so CSS sizes it).
% Check the exit status: a failed run leaves the previous .cropped.svg in place,
% so a stale file reads as "that override did nothing".
