chExceptionMusic = {
  <c f g>-\markup { "sus" }
  <c e g bf>-\markup { "7" }
}

chExceptions = #( append
  ( sequential-music-to-chord-exceptions chExceptionMusic #t)
  ignatzekExceptions)

globalChordSymbols = {
  \set chordChanges = ##t
  \set chordNameExceptions = #chExceptions
}