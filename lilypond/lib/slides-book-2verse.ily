\book {
  \include "slides-book-common.ily"
  \bookpart {
    \score {
      \scoreWithVerse #'(verseA printonly)
      \header { breakbefore = ##t }
    }
  }
  \bookpart {
    \score {
      \scoreWithVerse #'(verseB printonly)
    }
    \empty_header
  }
}
