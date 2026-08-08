\language "english"
\include "clairnote.ily"
\include "left-align-lyrics.ily"
\include "global-chord-symbols.ily"
\include "vertical-spacing.ily"
#(ly:set-option 'midi-extension "midi")

pa = \partCombineApart
pt = \partCombineAutomatic
bb = { \bar "" \break }

%% La-based shape notes. \globalParts calls \relativeMajorShapes just after
%% \hymnKey; it does nothing until a book sets hs-active-shapes, so every other
%% output leaves note heads alone. Both shape books share this one code path --
%% the rotation is the same, only the glyph vector differs.
#(define hs-active-shapes #f)

%% 7-shape (Aiken) and 4-shape (Southern Harmony) glyph sets, both in the
%% thin-notehead style. Written major-first: slot N is scale degree N of the
%% major scale, which \relativeMajorShapes then rotates onto the actual tonic.
shapeNoteBaseStyles = ##(doThin reThin miThin faThin sol laThin tiThin)
fourShapeNoteBaseStyles = ##(faThin sol laThin faThin sol laThin miThin)

#(define (hs-signature-fifths alterations)
   "Net sharps (positive) or flats (negative) in the key signature."
   (inexact->exact
     (* 2 (fold (lambda (entry acc) (+ acc (cdr entry))) 0 alterations))))

#(define (hs-rotate-vector vec n)
   (let* ((len (vector-length vec))
          (out (make-vector len)))
     (let loop ((i 0))
       (if (< i len)
           (begin
             (vector-set! out i (vector-ref vec (modulo (+ i n) len)))
             (loop (1+ i)))))
     out))

%% Key the shapes to the relative major, so minor tunes read la-do-re-mi rather
%% than do-re-mi-fa. LilyPond's shapeNoteStyles always counts up from the tonic,
%% and its stock \*HeadsMinor variants only cover minor; deriving the rotation
%% from the printed key signature covers the church modes too.
relativeMajorShapes = \applyContext
  #(lambda (ctx)
     (if (vector? hs-active-shapes)
         (let ((tonic (ly:context-property ctx 'tonic))
               (alterations (ly:context-property ctx 'keyAlterations '())))
           (if (ly:pitch? tonic)
               ;; Each step around the circle of fifths moves the major tonic
               ;; four diatonic steps, so the signature names the relative major.
               (let* ((major-degree
                        (modulo (* 4 (hs-signature-fifths alterations)) 7))
                      (offset
                        (modulo (- (ly:pitch-notename tonic) major-degree) 7)))
                 ;; Indexed by distance above the tonic, so slot 0 is the
                 ;; tonic's own shape -- 'la' for a minor key.
                 ;; Set it on the Staff, not this Voice: \partCombine spawns
                 ;; several voices (shared/one/two/solo) and only one of them
                 ;; runs this music, so a Voice-local set leaves the divergent
                 ;; passages do-based.
                 (ly:context-set-property!
                   (ly:context-find ctx 'Staff) 'shapeNoteStyles
                   (hs-rotate-vector hs-active-shapes offset)))))))

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
    
setBeamPos =
% warning, the distance won't be consistent in the clairenotes
#(define-music-function
  (left right)
  (number? number?)
  "Manually set beam position for next group."
  #{
    \once \override Beam.positions = #(cons left right)
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

  tagline =
  #(define-scheme-function
    (parser location) ()
    #{
      %% The engraver footer is the one part of this file that must NOT be
      %% shared with main. Only public-main's songs are served from
      %% hymnsinger.com, so only they may name it. main deliberately
      %% dropped the URL in dc45b2f8: its site is private and carries 13
      %% copyrighted songs, and a PDF that points at hymnsinger.com would
      %% imply they can be found there.
      %%
      %% Everything else in this file should stay in step with main. When
      %% porting a change across, port around this block.
      \markup {
        \override #'(font-series . "regular")
        \fontsize #-4
        \with-url
        #"https://hymnsinger.com/"
        \line {
          "Engraver: LilyPond"
          $(lilypond-version)
          \char ##x2014
          "Added to"
          \bold "https://hymnsinger.com"
          "on"
          \dateAdded
        }
      }
    #})

\tagGroup #'(slidesOnly verseA verseB verseC verseD verseE verseF verseG verseH slidesOmit midionly printonly capoOnly)
S = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'slidesOnly { $exp } #})
SA = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseA slidesOnly) { $exp } #})
SB = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseB slidesOnly) { $exp } #})
SC = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseC slidesOnly) { $exp } #})
SD = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseD slidesOnly) { $exp } #})
SE = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseE slidesOnly) { $exp } #})
SF = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseF slidesOnly) { $exp } #})
SG = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseG slidesOnly) { $exp } #})
SH = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'(verseH slidesOnly) { $exp } #})

SO = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'slidesOmit { $exp } #})

%% Wraps the "Capo N:" chord line. The transposed trad books strip it: the
%% capo number was chosen to suit the printed key, so carrying it onto a
%% chart in a different key would assert a fret nobody picked.
CP = #(define-music-function (parser location exp) (ly:music?) #{ \tag #'capoOnly { $exp } #})

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
          } << \partCombine #'(2 . 20) $topA $topB >>
          \removeWithTag #'slidesOnly \all_verses
        >>
        \new Staff = "bottom" \with {
          \cnNoteheadStyle "funksol"
          printPartCombineTexts = ##f
          \magnifyStaff \clairStaffZoom
          \RemoveAllEmptyStaves
        }<<
          \new Voice \with {
          } { \clef bass << \partCombine #'(2 . 20) $bottomA $bottomB >> }
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
          } << \partCombine #'(2 . 20) $topA $topB $bottomA $bottomB >>
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

          } << \partCombine #'(2 . 20) $topA $topB >>
          \removeWithTag #'slidesOnly \all_verses
        >>
        \new TradStaff = "bottom" \with {
          printPartCombineTexts = ##f
          \magnifyStaff $zoomLevel
          \RemoveAllEmptyStaves
        } <<
          \new Voice \with {

          } { \clef bass << \partCombine #'(2 . 20) $bottomA $bottomB >> }
          \bottom_verses
          \top_verse
        >>
      >>
    #})

fillTradLeadSheetScore =
  #(define-music-function
    (parser location topA songChords zoomLevel)
    (ly:music? ly:music? number?)
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

          } << $topA >>
          \removeWithTag #'slidesOnly \all_verses
        >>
      >>
    #})


%% Lead sheet with a fretboard diagram row under the chord symbols.
%%
%% Same shape as \fillTradLeadSheetScore, plus a FretBoards context. The
%% tuning is a parameter rather than baked in so a guitar book can reuse this
%% verbatim - the only per-instrument facts are the tuning vector and which
%% predefined-*-fretboards.ly the book included.
%%
%% $chordMusic is the raw \chordmode music, NOT the \songChords context
%% expression the other books take: FretBoards has to read chord events
%% itself, and handing it an already-built ChordNames renders nothing. See
%% fret-books.ily for how the two forms are told apart.
%%
%% $fingerCode is the fret-diagram-details finger-code: 'below-string prints
%% a fingering number under each string, 'none omits them. Per-instrument
%% because the two behave differently at this size - four strings have room
%% for the numbers, six do not, and on guitar the row of digits reads as
%% clutter under diagrams that are already dense.
fillFretLeadSheetScore =
  #(define-music-function
    (parser location topA chordMusic tuning fingerCode zoomLevel)
    (ly:music? ly:music? list? symbol? number?)
    #{
      <<
        \removeWithTag #'midionly
        \new ChordNames {
          \globalChordSymbols
          $chordMusic
        }
        \new FretBoards \with {
          stringTunings = #tuning
          \override FretBoard.fret-diagram-details.finger-code = #fingerCode
        } {
          %% Only diagram a chord where the symbol above it changes; a
          %% diagram under every beat is unreadable and repeats itself.
          \set chordChanges = ##t
          $chordMusic
        }
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

          } << $topA >>
          \removeWithTag #'slidesOnly \all_verses
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

          } << \partCombine #'(2 . 20) $topA $topB $bottomA $bottomB >>
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

          } << \partCombine #'(2 . 20) $topA $topB >>
          \keepWithTag $whichVerse \all_verses
        >>
        \new TradStaff = "bottom" \with {
          printPartCombineTexts = ##f
          \magnifyStaff $zoomLevel
          \RemoveAllEmptyStaves
        } <<
          \new Voice \with {

          } { \clef bass << \partCombine #'(2 . 20) $bottomA $bottomB >> }
          \keepWithTag $whichVerse \bottom_verses
          \keepWithTag $whichVerse \top_verse
        >>
      >>
    #})

scoreWithVerse =
  #(define-music-function
    (parser location topA topB bottomA bottomB whichVerse)
    (ly:music? ly:music? ly:music? ly:music? pair?)
    #{
      <<
      \removeWithTag #'midionly
      \fillSlidesScore
        { \keepWithTag $whichVerse $topA }
        { \keepWithTag $whichVerse $topB }
        { \keepWithTag $whichVerse $bottomA }
        { \keepWithTag $whichVerse $bottomB }
        {}
        $slidesStaffZoom
        $whichVerse
        >>
    #})

%% Landmark positions for the song pages to hang UI on - where the key
%% signature is, where the music ends. Off unless -dht-landmarks=<file> names
%% somewhere to write them; generate-all-outputs.sh turns it on.
\include "keysig-position.ily"

\paper {
  indent = 0
  %% Always installed; it returns immediately unless -dht-landmarks is set.
  page-post-process = #ht:page-post-process
}

\layout {
  \context {
    \Score
    \remove "Bar_number_engraver"
    \override ChordName #'font-size = #.5
    %% These callbacks return '() and only stash a reference, so they cost
    %% nothing when -dht-landmarks is off - ht:report does the work, and it is
    %% only reached under the option.
    \override Clef.after-line-breaking = #ht:grab-clef
    \override KeySignature.after-line-breaking = #ht:grab-keysig
    \override StaffSymbol.after-line-breaking = #ht:grab-staff
    \override BarLine.after-line-breaking = #ht:grab-bar
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
  \context {
    \ChordNames
    \consists "Instrument_name_engraver"
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
%% The raw \chordmode music, when a song keeps it separate from \songChords.
%%
%% Most songs write the chords straight into \songChords and stop there. The
%% few that need a capo line build \songChords out of several \new ChordNames
%% blocks instead, and keep the underlying music here so those blocks can each
%% reference it. The fret books need the raw music - a built ChordNames
%% context renders no diagrams - so they prefer this when the song defines it
%% and fall back to \songChords when it does not. Empty by default, which is
%% the signal for "this song uses the plain form".
chordSymbols = { }
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
tradLeadSheetStaffZoom = #1
clairStaffZoom = #1
slidesStaffZoom = #0.8
shapeStaffZoom = #1.1 %% A bit larger by default to help see the shapes

