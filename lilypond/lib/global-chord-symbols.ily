chExceptionMusic = {
  <c f g>-\markup { "sus" }
  <c e g bf>-\markup { "7" }
  <c ef gf>-\markup { "dim" }
  <c ef gf bff>-\markup { "dim7" }
  <c ef g bf>-\markup { "m7" }
  <c e g b>-\markup { "maj7" }
}

chExceptions = #( append
  ( sequential-music-to-chord-exceptions chExceptionMusic #t)
  ignatzekExceptions)

globalChordSymbols = {
  \set chordChanges = ##t
  \set chordNameExceptions = #chExceptions
}