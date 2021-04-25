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
 - Before you run `bundle install`, navigate into `hymnsinger/docs`, because the Gemfile is there.
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
  - Add windows configuration section/page
  - Consider reaching out to people
  - Configurable space around lyrics
  - Figure out how to understand/clean up extra_lyrics columns
  - ' versus ’ in lyrics extraction
  - Figure out what the meters mean for consistency
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
  - Autofocus the index page search bar
  - Add og: values to hymnsinger.com index page for better sharability
  - Fix caps/underscore variables
  - Slides issues:
    - Prevent dropLyricsSmall etc. (o come o come)
    - Tagline missing on >1 verse songs
    - Fix the lord bless you and keep you
  - Fix lyric extraction for custom slides lyrics (all creatures worship god most high)
  - \m is confusingly overloaded: Once in royal uses for melisma, others use for midionly
  - Finish filling out other titles column
  - Look into Contributing to Mutopia
  - Perhaps they would even like to have an in-browser playback?
  - Mutopia sheet music has a nice footer too. Copy?
  - Check out Mutopia source
  - Google SEO/analytics
  - Push state on search term with ?s="search term", so back button keeps search
  - The quest for LY -> JS musical representation:
    - Possibility 1: Through MusicXML
      - Very poor support through ly, which doesn't process scheme _at all_
        - \dispalyLilyMusic to produce a flat ly representation?
      - Possibility of longer path: LY -> Guile 2 SXML -> XML -> MusicXML
      - Possibility of python-ly xml-export-init.ly script as a starting point, since that _does_ actually use lilypond
      - Possible con: Harder to associate playing notes to written notes for live highlighting?
      - Possible con: Harder for non-standard notations
      - Keep an eye on https://github.com/openlilylib/lilypond-export
    - Possibility 2: Through MEI
      -