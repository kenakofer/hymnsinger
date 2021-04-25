\book {
  \include "slides_book_common.ily"
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
  \bookpart {
    \score {
      \scoreWithVerse #'(verseC printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'(verseD printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'(verseE printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'(verseF printonly)
    }
    \empty_header
  }
  \bookpart {
    \score {
      \scoreWithVerse #'(verseG printonly)
    }
    \empty_header
  }
}
