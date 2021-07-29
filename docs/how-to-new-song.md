---
---

# Creating a new song


If you haven't already, set up [Frescobaldi + Lilypond](contributing) or [Visual Studio Code + Lilypond](vscode).

If you haven't already, go [learn the basics of Lilypond](https://lilypond.org/doc/v2.20/Documentation/learning/simple-notation). It will make doing basic things much less painful.

### Copy the template

To create a song called "My Song":
* Run the script `scripts/new_song_from_template.sh my_song`. This just copies the a template file into a new file at `lilypond/songs/my_song/my_song.ly`.
* Or manually: create a new directory `my_song` in `lilypond/songs/`, and copy `lilypond/hymn_template/hymn_template.ly` to `my_song/my_song.ly`.

### Modify the template
The first things you'll do after creating the new song file:
* Remove the included `shared_tune` (unless you just want to provide new lyrics to an existing tune)
* Fill out everything in the `%% TUNE INFO`, and `%% SONG INFO` sections, e.g. change "Title of the song" to "My Song"
* Add some notes to soprano, alto, tenor, and bass
* Add some lyrics in `verseA-verseF`
* Make weird special-case tweaks (Scroll down to appendix)
* Check your work frequently by saving/re-engraving!

The `\include` files do a lot of setup and formatting, such that song file can simply give info, notes, lyrics, and chords, and all the difficult formatting and multiple outputs should just work.

### Adding your new song to the website

[Email it](mailto:kbitikofer@gmail.com) or use a Github pull request.

### Appendix: How do I do [weird special-case thing?]

Here are a list of common Lilypond tasks that are easy to forget, and an example song that does it well:

| Task      | Example song |
| ----------- | ----------- |
| Italic lyrics | Wakantanka |
| Single staff | Wakantanka |
| Dotted slur (lyrics ignore) | Wakantanka |
| Shared tune between several songs | All praise to thee, my God, using the shared tune Tallis Canon |
| Canon / Round | Tallis Canon |
| Double column lyrics at the end | Religion fit to last |
| Single column lyrics at the end | We shall overcome |
| Alternating Leader/All or Unison/Harmony | When Israel was in Egypt's land |
| Chorus / Refrain lines condensed to one line without ruining the lyrics extractor | All creatures worship God most high |
| Fermatas (up and down facing) | All creatures worship God most high |
| Alternate title | All creatures worship God most high |
| Score zoomed to fit on one page (both traditional notation and clairscore) | All creatures worship God most high |
| Two lyrics languages in the staff | Heilig, Heilig, Heilig |
| Custom lyric labels on certain lines | Heilig, Heilig, Heilig |
| Different lyrics for each of 2 staffs | Warm Summer Sun |
| One part in a staff resting while the other sings | O come all ye faithful |
| Different lyrics for the same staff (e.g. soprano v. alto) | When peace like a river |
| Double staff switch to single staff in same song | La paz de la tierra |
| Lyrics skip note without using slurs | Once in royal David's city |
| Chant style (half bars, hidden note flags, tweaks noteheads/beaming) | O come, O come Immanuel |
| Add symmetrical padding to verses | The Lord Bless you and keep you |
| Line Lyrics Stanza above the soprano staff | The Lord Bless you and keep you |
| Different note/duration midi vs. print (e.g. for fermatas) | Teach me thy truth |
| Capo chords / Chords on multiple lines | O wizened eyes resplendent |
| Vertical space padding using white-out chords | O wizened eyes resplendent |