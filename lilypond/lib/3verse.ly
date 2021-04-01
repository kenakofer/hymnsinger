all_verses = <<
  \new NullVoice = "soprano" \soprano
  \tag #'verseA { \new Lyrics  \lyricsto soprano  { \globalLyrics "1" "" \verseA } }
  \tag #'verseB { \new Lyrics  \lyricsto soprano  { \globalLyrics "2" "" \verseB } }
  \tag #'verseC { \new Lyrics  \lyricsto soprano  { \globalLyrics "3" "" \verseC } }
>>