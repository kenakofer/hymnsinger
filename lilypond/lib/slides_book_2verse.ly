\book {
  \include "slides_book_common.ly"
  \bookpart {
    \score {
      \scoreWithVerse #'verseA
      \header { breakbefore = ##t }
    }
  }
  \bookpart {
    \score {
      \scoreWithVerse #'verseB
    }
    \empty_header
  }
}
