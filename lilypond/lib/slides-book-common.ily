\bookOutputSuffix "slides"

%% Lyrics a step up from the printed books' -1. See ht:lyric-font-size in
%% hymn-common.ily for why the size travels through the lyric music rather
%% than through a \layout on \Lyrics.
%%
%% Set here, inside \book. The songs include their Nverse.ily - which expands
%% \globalLyrics - before they include this file, so this cannot be a plain
%% variable the music substitutes at parse time; ht:lyric-font-size is read by
%% an \applyContext when the music is interpreted, which happens after this
%% line has run. The printed books are laid out from their own \include above
%% and never see the new value.
#(set! ht:lyric-font-size 0.6)

%% Per-song spacing, same hook the notation books use. It sits here rather than
%% in each slides-book-Nverse.ily because this file is the one they all share,
%% and it is inside the \book, so the \layout reaches every \bookpart.
%%
%% Most songs will want ("slides" . #f) in \spacing_overrides_by_book: a deck
%% paginates one system per slide, so margin added for a printed page usually
%% just costs a slide here.
#(let ((sp (ht-spacing-for "slides")))
   (if sp
       (begin
         (ly:parser-define! 'ht-this-book-spacing sp)
         (ly:parser-include-string
              "\\layout { $ht-this-book-spacing \\context { \\Score \\remove \"Bar_number_engraver\" } }"))))

%% Make a landscape 16:9 aspect. We make the lyrics appear larger by making
%% the paper size small, and choosing a small zoom later, so that lyrics are relatively larger
#(set! paper-alist (cons '("my size" . (cons (* 7 in) (* 3.9375 in))) paper-alist))
\paper {
  #(set-paper-size "my size")
  indent = 0
  ragged-bottom = ##t
  top-margin = #12
  left-margin = #3
  right-margin = #3
  print-page-number = ##f
}
\header{
  copyright = \public_domain_notice_two_lines \typesetter
}