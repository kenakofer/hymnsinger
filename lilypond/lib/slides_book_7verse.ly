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
  \bookpart {
    \score {
      \scoreWithVerse #'verseC
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'verseD
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'verseE
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'verseF
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'verseG
    }
    \empty_header
  }
}
