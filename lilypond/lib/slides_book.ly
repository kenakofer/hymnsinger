\book {
  %% Make a landscape 16:9 aspect. We make the lyrics appear larger by making
  %% the paper size small, and choosing a small zoom later, so that lyrics are relatively larger
  #(set! paper-alist (cons '("my size" . (cons (* 6 in) (* 3.375 in))) paper-alist))
  \paper {
    #(set-paper-size "my size")
    indent = 0
    ragged-bottom = ##t
    top-margin = #10
    left-margin = #4
    right-margin = #4
  }

  \prescore_text
  \bookOutputSuffix "slides" \score {
    \header {
      breakbefore = ##t
    }
    \removeWithTag #'midionly
    \fillTradScore
      { \removeWithTag #'midionly \soprano }
      { \removeWithTag #'midionly \alto }
      { \removeWithTag #'midionly \tenor }
      { \removeWithTag #'midionly \bass }
      {}
      #.6
  }
  \postscore_text
}
