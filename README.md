## Hymn Hosting

This is a project to make or take hymns with permissive copyright status, typeset them with lilypond in a variety of formats, and serve them online in a friendly and usable github pages site. It has a long ways to go yet.

### Features of the site should include:
 - Easy browsing of the full hymn selection
 - An interface for simultaneously viewing and playing the hymn
     - Links to editing the Lilypond source
     - Ability to change volume on a per-part basis
 - Add new songs easily
 - Multiple formats supported

### Current directions:
 - Fix large PDF sizes, probably font inclusion issue
     - Size with biolinum: "339K Jan  5 11:45 H008_Brethren,_we_have_met_to_worship-clairnote.pdf_"
       Size without: 338K
       Siz without any fonts: 226K
       still too big
       Siz with `lilypond -dgs-never-embed-fonts H008_Brethren,_we_have_met_to_worship.ly': 188K
       Size with `lilypond -dgs-never-embed-fonts -dno-point-and-click H008_Brethren,_we_have_met_to_worship.ly`: 24K
       Same, but with free-serif re-enabled: 137K
       free-serif switched to roman: 61K
       Looks terrible, how long has that been happening?
       `lilypond -dno-point-and-click H008_Brethren,_we_have_met_to_worship.ly` with just roman looks fine at 62K
       Check

 - Differentiate fonts png versus pdf?
   Change text locations
 - Solve crackling in sound-font-player audio in Firefox
 - Better piano soundfont
 - Email lilypond list regarding shape notes + partsCombine
 - Typeset more hymns/tunes
    - Amazing grace tune, possibly with the alternative "Truth" lyrics
    - Melody of slowly turning (Make your own harmonization and lyrics, even though the originals are so good...)
 - Lyrics export
   Stem default directions down/up?
   CSS tweaks:
    - Fix large/small screen differences
      Make song page background white to match pdf
   Midiplayer tweaks:
      Show tempo on file load
      Don't reset tempo on play start (inhibit tempo event)
      Don't start playing on tempo change
      Change stop to restart
      Figure out if dragging through the file is possible
      Fix play/pause indication
      Loop play?
      Add master volume slider
      Add pitch change slider
      Add Instrument change option
      Add expandable advanced panel, place most things inside
