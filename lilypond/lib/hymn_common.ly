pa = \partcombineApart
pt = \partcombineAutomatic

hymnKey = \key c \major
hymnTime = \time 4/4
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/4)
hymnBeatStructure = \set Timing.beatStructure = 1,1,1,1
hymnBeamExceptions = \set Timing.beamExceptions = #'()

globalParts = {
  \hymnKey
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
}

globalLyrics = {
          \override LyricHyphen.minimum-distance = #1.0 % Ensure hyphens are visible
          \set fontSize = #-1
          \override StanzaNumber #'font-name = #"FreeSerif"
          \override LyricText #'font-name = #"FreeSerif"
          \override InstrumentName #'font-name = #"FreeSerif"
          \override InstrumentName #'X-offset = #2
          %% Not sure if this does anything, but it was in lilypond's template
          \override VerticalAxisGroup #'staff-affinity = #CENTER

}
globalLyrics =
#(define-music-function
  (parser location firstLabel laterLabel)
  (string? string?)
  #{
    {
          \override LyricHyphen.minimum-distance = #1.0 % Ensure hyphens are visible
          \set fontSize = #-1
          \override StanzaNumber #'font-name = #"FreeSerif"
          \override LyricText #'font-name = #"FreeSerif"
          \override InstrumentName #'font-name = #"FreeSerif"
          \override InstrumentName #'X-offset = #2.5
          \override InstrumentName #'font-size = #-1
          \set stanza = #firstLabel
          \set shortVocalName = #laterLabel
}
  #})

smallText =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup{
        \override #'(font-name . "Linux Biolinum")
        \fontsize #-2
        #text
      }
    #})
  
 titleText =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup{
        \override #'(font-name . "Linux Biolinum")
        \fontsize #1
        #text
      }
    #})
  
  tagline =
  #(define-scheme-function
    (parser location) ()
    #{
      \smallText \markup {
        \with-url
        #"http://lilypond.org"
        \line {
          "Engraved using LilyPond"
          $(lilypond-version)
          \char ##x2014
          "http://lilypond.org"
        }
      }
    #})
  
  fillClairScore =
  #(define-music-function
    (parser location topA topB bottomA bottomB)
    (ly:music? ly:music? ly:music? ly:music?)
    #{
      <<
        \new Staff = "top" \with {
          \cnNoteheadStyle "funksol"
        }
        <<

          \new Voice \with {
          } << \partcombine #'(2 . 9) $topA $topB >>
          \all_verses
        >>
        \new Staff = "bottom" \with {
          \cnNoteheadStyle "funksol"
        }<<
          \new Voice \with {
          } { \clef bass << \partcombine #'(2 . 9) $bottomA $bottomB >> }
        >>
      >>
    #})
  
   fillTradScore =
  #(define-music-function
    (parser location topA topB bottomA bottomB)
    (ly:music? ly:music? ly:music? ly:music?)
    #{
      <<
        \new TradStaff = "top"
        <<

          \new Voice \with {
            
          } << \partcombine #'(2 . 9) $topA $topB >>
          \all_verses
        >>
        \new TradStaff = "bottom" <<
          \new Voice \with {
            
          } { \clef bass << \partcombine #'(2 . 9) $bottomA $bottomB >> }
        >>
      >>
    #})



\paper {
  indent = 0
}


\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
  }
  \context {
    \Voice
    \consists "Melody_engraver"
    \override Stem #'neutral-direction = #'()
  }
}