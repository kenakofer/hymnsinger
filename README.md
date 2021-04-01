## Hymn Singer

This is a project to make or take hymns with permissive copyright status, typeset them with lilypond in a variety of formats, and serve them online in a friendly and usable github pages site. It has a long ways to go yet.

### Features of the site include:
 - Easy browsing of the full song selection, including lyrics
 - An interface for simultaneously viewing and playing the song
     - Ability to change volume on a per-part basis
 - Multiple formats available
 - Full mobile support (issues with android firefox at the moment)
 - One can add to the site by simply adding a new lilypond file

### Running the website locally:
 - See github pages documentation on [running a site locally](https://docs.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll)
 - Before you run `bundle install`, navigate into `hymn-singer/docs`, because the Gemfile is there.
 - If `bundle install` complains about `Gemfile.lock` in the same directory, delete it.
 - After you `bundle exec jekyll serve` successfully, you can see the site at <http://127.0.0.1:4000> or something similar.

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
  - Programatic key change? Would require either
    - Generating all the desired key changes up front (+/- 3 half steps?)
    - Using a custom lilybin setup on server or AWS lambda, or some other serverside way to re-parse lilypond files. This would be far more difficult, but also allow the user tons of flexibility down the line.
  - Add vscode configuration section/page
  - Consider reaching out to people
  - Configurable space around lyrics
  - Figure out how to understand/clean up extra_lyrics columns
  - Include song index data in pages somehow (js?) then DRY on indexes
  - Store full index in JSON?
  - ' versus ’ in lyrics extraction
  - Figure out what the meters mean for consistency
  - Song versus Tune columns
  - Upgrade to lilypond 2.21
    - Swing added (Wade in the water
  - Less space between two staves in clairnotes
  - More compact spacing in general?
  - \paper {
      system-system-spacing = #'((basic-distance . 0.1) (padding . 0))
      ragged-last-bottom = ##f
      ragged-bottom = ##f
    }
  - Phrasing slurs \( \) are not dashed after partcombine
  - Enter multiple lines of lyrics above staff
  - Need to fix linux css on song page:
    - Button text too large?
    - Maybe allow larger center column?
    - Contrast on sliders is bad
  - Autofocus the index page search bar
  - Add "Alternate Lyrics" column
    - Tricky, because it's a many-to-many relationship.
    - Json associations, both automatic for songs on the site, and manual
    - External links to copyrighted lyrics
  - Powerpoint generation
    - New book with reduced height paper to output many large landscape PNGs
    - Somehow only include 1 verse, in large font?
  - Add og: values to hymn.singer.ga index page for better sharability
    - Need to make a logo maybe?
