\book {
  \include "slides_book_common.ily"
  \bookpart {
    \score {
      \scoreWithVerse #'(verseA printonly)
      \header { breakbefore = ##t }
    }
  }
}
