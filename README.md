## Hymn Singer

This is a project to make or take hymns with permissive copyright status, typeset them with LilyPond in a variety of formats, and serve them online in a friendly and usable github pages site.

### Features of the site include:
 - Easy browsing and searching of the full song selection, including lyrics
 - A browser interface for simultaneously viewing and playing the song
     - Ability to change volume on a per-part basis
 - Multiple formats available:
     - PDFs and PNGs for several notation styles,
     - a slideshow in ODF and PDF
     - MIDI and MP3
 - Full mobile support (issues with android firefox at the moment)
 - One can add to the site by simply adding a new lilypond file

### Running the website locally:
 - See github pages documentation on [running a site locally](https://docs.github.com/en/github/working-with-github-pages/testing-your-github-pages-site-locally-with-jekyll)
 - Before you run `bundle install`, navigate into `hymnsinger/docs`, because the Gemfile is there.
 - If `bundle install` complains about `Gemfile.lock` in the same directory, delete it.
 - After you `bundle exec jekyll serve` successfully, you can see the site at <http://127.0.0.1:4000> or something similar.

### Possible TODOs:
  - Add verses to break forth
  - Differentiate fonts png versus pdf?
  - Stem default directions down/up?
  - Midiplayer tweaks:
    - Add master volume slider
    - Add pitch change slider
    - Add Instrument change option
  - Play sample on the index page?
  - Screenshot on home page showing e.g. amazing grace old and new.
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
  - Phrasing slurs \( \) are not dashed after partCombine
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
  - The quest for LY -> JS musical representation. Best bet at this point is probably to get JPV's code working and start trying to extend the effort
    - Issues with lilypond-export:
      - Key sig missing
      - Slurs missing
      - Syllable hyphens missing
  - Audiveris (FOSS Musical OCR) as part of workflow? It can go from image -> musicxml (not sure about quality). MusicXML -> LY would need to be good though...

  - Can't zoom on phone
  - Don't search after every character press
  - Remove page numbers (page 2 onwards)
  - Add public domain graphic?
  - Final note off of midi not triggering in browser(js issue, the midi itself is fine I think)
  - Add more Christmas tags
  - separate out meter and tune variables in template
  - Auto scroll down page while playing?
  - Remove redundant Em from hymn of breaking strain