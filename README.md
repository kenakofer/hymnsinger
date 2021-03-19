## Hymn Singer

This is a project to make or take hymns with permissive copyright status, typeset them with lilypond in a variety of formats, and serve them online in a friendly and usable github pages site. It has a long ways to go yet.

### Features of the site include:
 - Easy browsing of the full song selection, including lyrics
 - An interface for simultaneously viewing and playing the song
     - Ability to change volume on a per-part basis
 - Multiple formats available
 - Full mobile support (issues with android firefox at the moment)
 - I can add to the site by simply adding a new lilypond file

### Possible TODOs:
  - Differentiate fonts png versus pdf?
  - Stem default directions down/up?
  - Midiplayer tweaks:
    - Add master volume slider
    - Add pitch change slider
    - Add Instrument change option
    - Add expandable advanced panel, place most things inside to avoid clutter
  - Play sample on the index page?
  - Screenshot on home page showing e.g. amazing grace old and new.
  - Sort index page somehow
  - Programatic key change? Would require either
    - Generating all the desired key changes up front (+/- 3 half steps?)
    - Using a custom lilybin setup on server or AWS lambda, or some other serverside way to re-parse lilypond files. This would be far more difficult, but also allow the user tons of flexibility down the line.
  - Change names: tune variables, copyright, tags to form: "text:site arranged:other winter"
  - Add vscode configuration section/page
  - Add count to index and tag pages
  - Add stats page:
    - Total number of songs
    - Total number of tunes used
  - Consider reaching out to people
  - Make shape notes bigger
  - Less space between two staves in clairnotes
  - More space below lyrics
  - Figure out how to understand/clean up extra_lyrics columns
  - Correct tags on song page markdown
  - Include song index data in pages somehow (js?) then DRY on indexes
  - try to use JS to pull out search params?
  - Store full index in JSON?
  - Remove "~" from lyrics extraction
  - ' versus ’ in lyrics extraction
  - Extract TUNE, music, text data
  - Figure out what the meters mean for consistency
  - Fix tis a gift
