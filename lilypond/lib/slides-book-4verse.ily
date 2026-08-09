\book {
  \include "slides-book-common.ily"
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseA printonly)
      \header { breakbefore = ##t }
      \slidesMidVerse
    }
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseB printonly)
      \slidesMidVerse
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseC printonly)
      \slidesMidVerse
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseD printonly)
    }
    \empty_header
  }
}
