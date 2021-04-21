\language "english"
\include "clairnote.ily"
\include "left_align_lyrics.ily"
\include "global_chord_symbols.ily"
#(ly:set-option 'midi-extension "midi")

pa = \partcombineApart
pt = \partcombineAutomatic

globalLyrics =
#(define-music-function
  (parser location firstLabel laterLabel)
  (string? string?)
  #{
    {
          \override LyricHyphen.minimum-distance = #1.0 % Ensure hyphens are visible
          \set fontSize = #-1
          \override LyricText.font-family = #'roman
          \override InstrumentName.font-family = #'roman
          \override InstrumentName.font-series = #'regular
          \override InstrumentName #'X-offset = #2.5
          \override InstrumentName #'font-size = #-1
          \override StanzaNumber.font-family = #'roman
          \override StanzaNumber.font-series = #'bold
          \set stanza = #firstLabel
          \SO { \set shortVocalName = #laterLabel }
          \override VerticalAxisGroup #'staff-affinity = #CENTER
}
  #})

showVerseNumberAtLineStart =
#(define-music-function
  (parser location label xoffset)
  (string? number?)
  #{
    {
      \override InstrumentName #'X-offset = #xoffset
      \set shortVocalName = #label
    }
  #})

hideVerseNumberAtLineStart = {
  \override InstrumentName #'X-offset = #2.5
  \set shortVocalName = ""
}

public_domain_notice =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup{
        %\override #'(font-name . "Linux Biolinum")
        \override #'(font-series . "regular")
        \lower #1
        \fontsize #-4 {
        "The typesetter"
        \bold #text
        "has waived all copyright and related rights to this work, dedicating it to the"
        \bold "public domain"
        "to the extent possible under law."
        }
      }
    #})

public_domain_notice_two_lines =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup{

        %\override #'(font-name . "Linux Biolinum")
        \override #'(font-series . "regular")
        \lower #1
        \fontsize #-4 {
          \center-column {
            \line {
              "The typesetter"
              \bold #text
              "has waived all copyright and related rights to this work,"
            }
            \line {
              "dedicating it to the"
              \bold "public domain"
              "to the extent possible under law."
            }
          }
        }
      }
    #})

smallText =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup{
        %\override #'(font-name . "Linux Biolinum")
        \override #'(font-series . "regular")
        \fontsize #-2
        #text
      }
    #})

 twoLineSmallText =
  #(define-scheme-function
    (parser location textA textB)
    (markup? markup?)
    #{
      \markup{
        \override #'(baseline-skip . 2)
        \column {
          %\override #'(font-name . "Linux Biolinum")
          \fontsize #-2
          \line { #textA }
          \fontsize #-2
          \line { #textB }
        }
      }
    #})

 twoLineSmallTextRight =
  #(define-scheme-function
    (parser location textA textB)
    (markup? markup?)
    #{
      \markup{
        \override #'(baseline-skip . 2)
        \right-column {
          %\override #'(font-name . "Linux Biolinum")
          \fontsize #-2
          \line { #textA }
          \fontsize #-2
          \line { #textB }
        }
      }
    #})

prescoreText =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup {
        \override #'(font-series . "regular")
        \fontsize #0
        \lower #12.5
        #text
      }
    #})

postscoreText =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup {
        \override #'(font-series . "regular")
        \fontsize #-1
        \raise #0
        #text
      }
    #})

 titleText =
  #(define-scheme-function
    (parser location text)
    (markup?)
    #{
      \markup{
        %\override #'(font-name . "Linux Biolinum")
        \fontsize #1
        #text
      }
    #})

date = #(strftime "%Y-%m-%d" (localtime (current-time)))

  tagline =
  #(define-scheme-function
    (parser location) ()
    #{
      \markup {
        \override #'(font-series . "regular")
        \fontsize #-4
        \with-url
        #"https://hymn-singer.com/"
        \line {
          "Engraver: LilyPond"
          $(lilypond-version)
          \char ##x2014
          "Added to"
          \bold "https://hymn-singer.com"
          "on"
          \dateAdded
          ", updated"
          \date
        }
      }
    #})

S = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'slidesOnly { $exp } #})
SA = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseA slidesOnly) { $exp } #})
SB = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseB slidesOnly) { $exp } #})
SC = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseC slidesOnly) { $exp } #})
SD = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseD slidesOnly) { $exp } #})
SE = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseE slidesOnly) { $exp } #})
SF = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseF slidesOnly) { $exp } #})
SG = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseG slidesOnly) { $exp } #})

SO = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'slidesOmit { $exp } #})

dropLyricsSmall = {
  \SO {
    \override LyricText.extra-offset = #'(0 . -0.5)
    \override LyricHyphen.extra-offset = #'(0 . -0.5)
    \override LyricExtender.extra-offset = #'(0 . -0.5)
    \override StanzaNumber.extra-offset = #'(0 . -0.5)
    \override InstrumentName.extra-offset = #'(0 . -0.5)
    \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #2
  }
}

dropLyricsMedium = {
  \SO {
    \override LyricText.extra-offset = #'(0 . -1)
    \override LyricHyphen.extra-offset = #'(0 . -1)
    \override LyricExtender.extra-offset = #'(0 . -1)
    \override StanzaNumber.extra-offset = #'(0 . -1)
    \override InstrumentName.extra-offset = #'(0 . -1)
    \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #2
  }
}

dropLyricsLarge = {
  \SO {
    \override LyricText.extra-offset = #'(0 . -2)
    \override LyricHyphen.extra-offset = #'(0 . -2)
    \override LyricExtender.extra-offset = #'(0 . -2)
    \override StanzaNumber.extra-offset = #'(0 . -2)
    \override InstrumentName.extra-offset = #'(0 . -2)
    \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #2
  }
}

m =
  #(define-music-function
    (parser location play show)
    (ly:music? ly:music?)
    #{
      \tag #'midionly { $play }
      \tag #'printonly { $show }
    #}
  )

fillClairScore =
  #(define-music-function
    (parser location topA topB bottomA bottomB)
    (ly:music? ly:music? ly:music? ly:music?)
    #{
      <<
        \new Lyrics = "topVerse" \with {
          % lyrics above a staff should have this override
          \override VerticalAxisGroup.staff-affinity = #DOWN
        }
        \new Staff = "top" \with {
          \cnNoteheadStyle "funksol"
          printPartCombineTexts = ##f
          \magnifyStaff \clairStaffZoom
          \RemoveAllEmptyStaves
        }
        <<
          \new Voice \with {
          } << \partcombine #'(2 . 20) $topA $topB >>
          \removeWithTag #'slidesOnly \all_verses
        >>
        \new Staff = "bottom" \with {
          \cnNoteheadStyle "funksol"
          printPartCombineTexts = ##f
          \magnifyStaff \clairStaffZoom
          \RemoveAllEmptyStaves
        }<<
          \new Voice \with {
          } { \clef bass << \partcombine #'(2 . 20) $bottomA $bottomB >> }
          \bottom_verses
          \top_verse
        >>
      >>
    #})

fillClairScoreSingleStaff =
  #(define-music-function
    (parser location topA topB bottomA bottomB)
    (ly:music? ly:music? ly:music? ly:music?)
    #{
      <<
        \new Staff = "top" \with {
          \cnNoteheadStyle "funksol"
          printPartCombineTexts = ##f
          \magnifyStaff \clairStaffZoom
          \RemoveAllEmptyStaves
        }
        <<

          \new Voice \with {
          } << \partcombine #'(2 . 20) $topA $topB $bottomA $bottomB >>
          \removeWithTag #'slidesOnly \all_verses
        >>
      >>
    #})

fillTradScore =
  #(define-music-function
    (parser location topA topB bottomA bottomB songChords zoomLevel)
    (ly:music? ly:music? ly:music? ly:music? ly:music? number?)
    #{
      <<
        \removeWithTag #'midionly
        $songChords
        \new Lyrics = "topVerse" \with {
          % lyrics above a staff should have this override
          \override VerticalAxisGroup.staff-affinity = #DOWN
        }
        \new TradStaff = "top" \with {
          printPartCombineTexts = ##f
          \magnifyStaff $zoomLevel
          \RemoveAllEmptyStaves
        }
        <<
          \new Voice \with {

          } << \partcombine #'(2 . 20) $topA $topB >>
          \removeWithTag #'slidesOnly \all_verses
        >>
        \new TradStaff = "bottom" \with {
          printPartCombineTexts = ##f
          \magnifyStaff $zoomLevel
          \RemoveAllEmptyStaves
        } <<
          \new Voice \with {

          } { \clef bass << \partcombine #'(2 . 20) $bottomA $bottomB >> }
          \bottom_verses
          \top_verse
        >>
      >>
    #})

fillTradScoreSingleStaff =
  #(define-music-function
    (parser location topA topB bottomA bottomB songChords)
    (ly:music? ly:music? ly:music? ly:music? ly:music?)
    #{
      <<
        $songChords
        \new TradStaff = "top" \with {
          printPartCombineTexts = ##f
          \magnifyStaff \tradStaffZoom
          \RemoveAllEmptyStaves
        }
        <<
          \new Voice \with {

          } << \partcombine #'(2 . 20) $topA $topB $bottomA $bottomB >>
          \removeWithTag #'slidesOnly \all_verses
        >>
      >>
    #})

fillSlidesScore =
  #(define-music-function
    (parser location topA topB bottomA bottomB songChords zoomLevel whichVerse)
    (ly:music? ly:music? ly:music? ly:music? ly:music? number? pair?)
    #{
      <<
        \removeWithTag #'midionly
        $songChords
        \new Lyrics = "topVerse" \with {
          % lyrics above a staff should have this override
          \override VerticalAxisGroup.staff-affinity = #DOWN
        }
        \new TradStaff = "top" \with {
          printPartCombineTexts = ##f
          \magnifyStaff $zoomLevel
          \RemoveAllEmptyStaves
        }
        <<
          \new Voice \with {

          } << \partcombine #'(2 . 20) $topA $topB >>
          \keepWithTag $whichVerse \all_verses
        >>
        \new TradStaff = "bottom" \with {
          printPartCombineTexts = ##f
          \magnifyStaff $zoomLevel
          \RemoveAllEmptyStaves
        } <<
          \new Voice \with {

          } { \clef bass << \partcombine #'(2 . 20) $bottomA $bottomB >> }
          \bottom_verses
          \top_verse
        >>
      >>
    #})

scoreWithVerse =
  #(define-music-function
    (parser location whichVerse)
    (pair?)
    #{
      <<
      \removeWithTag #'midionly
      \fillSlidesScore
        { \removeWithTag #'midionly \soprano }
        { \removeWithTag #'midionly \alto }
        { \removeWithTag #'midionly \tenor }
        { \removeWithTag #'midionly \bass }
        {}
        #.8
        $whichVerse
        >>
    #})

\paper {
  indent = 0
}

\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
    \override ChordName #'font-size = #.5
  }
  \context {
    \Voice
    \consists "Melody_engraver"
    \override Stem #'neutral-direction = #'()
  }
  ragged-right = ##f
  \context {
    \Lyrics
    \override LyricText.X-offset = #X-offset-callback
  }
  \context {
    \Score
    \consists #Lyric_text_align_engraver
  }
}

empty_header = \header {
  title = ##f
  subtitle = ##f
  composer = ##f
  arranger = ##f
  poet = ##f
  meter = ##f
  tagline = ##f
  piece = ##f
  copyright = ##f
}

%% Defaults for tune variables
composer = \smallText "Music: Who wrote the music, year"
meter = \smallText "TUNE NAME meter"
hymnKey = \key c \major
hymnTime = \time 4/4
quarternoteTempo = 120
songChords = { }
%% These usually don't need to be changed
hymnBaseMoment = \set Timing.baseMoment = #(ly:make-moment 1/4)
hymnBeatStructure = \set Timing.beatStructure = 1,1,1,1
hymnBeamExceptions = \set Timing.beamExceptions = #'()


%% Defaults for song variables
title = \titleText "You have not set a title"
subtitle = ""
arranger = ""
poet = \smallText "Text: Who wrote the text, year"
verseCount = 2
tags = "english christian 4part"
%% These usually don't need to be changed
prescore_text = {}
postscore_text = {}
extra_verses = {}
top_verse = {}
bottom_verses = {}
tradStaffZoom = #1
clairStaffZoom = #1
shapeStaffZoom = #1.1 %% A bit larger by default to help see the shapes