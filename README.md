## Hymn Singer

This is a project to make or take hymns with permissive copyright status, typeset them with lilypond in a variety of formats, and serve them online in a friendly and usable github pages site. It has a long ways to go yet.

### Features of the site include:
 - Easy browsing of the full hymn selection, including lyrics
 - An interface for simultaneously viewing and playing the hymn
     - Ability to change volume on a per-part basis
 - Multiple formats available
 - Full mobile support (issues with android firefox at the moment)
 - I can add to the site by simply adding a new lilypond file

### Possible TODOs:
  - Differentiate fonts png versus pdf?
  - Email lilypond list regarding shape notes + partsCombine
  - Stem default directions down/up?
  - CSS tweaks:
    - Fix large/small screen differences
  - Midiplayer tweaks:
    - Figure out if dragging through the file is possible
    - Loop play?
    - Add master volume slider
    - Add pitch change slider
    - Add Instrument change option
    - Add expandable advanced panel, place most things inside to avoid clutter
  - Find in page doesn't work on mobile, maybe just suggest using find in page? Or use a better library
  - Play sample on the index page?
  - Screenshot on home page showing e.g. amazing grace old and new.
  - Sort index page somehow
  - Programatic key change? Would require either
    - Generating all the desired key changes up front (+/- 3 half steps?)
    - Using a custom lilybin setup on server or AWS lambda, or some other serverside way to re-parse lilypond files. This would be far more difficult, but also allow the user tons of flexibility down the line.
  - Change names: tune variables, copyright, tags to form: "text:site arranged:other winter"
  - Add vscode configuration section/page
  - Fix footer on short pages like death
  - Add title to Tag pages.
  - Add count to index and tag pages
  - Add stats page:
    - Total number of songs
    - Total number of tunes used
  - Consider reaching out to people



