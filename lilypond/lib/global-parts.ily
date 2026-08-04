%% These use the values specified before this file's import
globalParts = {
  \hymnKey
  %% Must follow \hymnKey: it reads the key that line just established.
  %% A no-op in every book except the shapenote one (see shapenote-book.ily).
  \relativeMajorShapes
  \hymnTime
  \hymnBaseMoment
  \hymnBeatStructure
  \hymnBeamExceptions
  \numericTimeSignature
  \phrasingSlurDashed
  \override Score.RehearsalMark.break-visibility = #end-of-line-visible
  \override Score.RehearsalMark.self-alignment-X = #RIGHT
}