\bookOutputSuffix "slides"
%% Make a landscape 16:9 aspect. We make the lyrics appear larger by making
%% the paper size small, and choosing a small zoom later, so that lyrics are relatively larger
#(set! paper-alist (cons '("my size" . (cons (* 7 in) (* 3.9375 in))) paper-alist))
\paper {
  #(set-paper-size "my size")
  indent = 0
  ragged-bottom = ##t
  top-margin = #10
  left-margin = #3
  right-margin = #3
  print-page-number = ##f
}
\header{
  copyright = \public_domain_notice_two_lines \typesetter
}