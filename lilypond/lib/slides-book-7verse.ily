\book {
  \include "slides-book-common.ily"
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseA printonly)
      \header { breakbefore = ##t }
    }
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseB printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseC printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseD printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseE printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseF printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse {\soprano} {\alto} {\tenor} {\bass} #'(verseG printonly)
    }
    \empty_header
  }
}
