\book {
  \include "slides_book_common.ly"
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
