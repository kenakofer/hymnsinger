all_verses = <<
  \new NullVoice = "soprano" {\removeWithTag #'midionly \soprano}
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
>>