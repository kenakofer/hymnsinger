---
---

# Contributing using Lilypond + Frescobaldi

All the songs on the site are written using Lilypond, which is a way to describe a musical score using code. Frescobaldi is an easy-to-use GUI (graphical user interface) for Lilypond.

(For more advanced users, see the [Lilypond + Visual Studio Code setup](vscode))

### Installing

You will need:
 - If on Windows, you'll probably want [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
 - [Lilypond](http://lilypond.org/download.html), the program that turns a file of code: `my_song.ly` into outputs `my_song.pdf` and `my_song.midi`. Hymn Singer currently uses 2.20.0, and the newer versions may be fine.
 - [Frescobaldi](https://frescobaldi.org/download), the easiest way to get started with Lilypond on Linux, Mac, or Windows.
 - (optional) [Git](https://git-scm.com/downloads)

### Clone the git repository

You're going to copy this entire website, including all the songs, to your computer.
- If you're comfortable with git: `git clone https://github.com/kenanbit/hymn-singer.git`
- Otherwise, go to <https://github.com/kenanbit/hymn-singer> Click the big green download button. You can download a zip and unzip it.

### Getting a song to engrave correctly

To "engrave" (meaning turn the `.ly` file into `.pdf` and `.midi` outputs):
- Open Frescobaldi
- Open the source code (the `.ly` file) for one of the songs. For example, "Angels we have heard on high" is at `lilypond/songs/angels_we_have_heard_on_high/angels_we_have_heard_on_high.ly`
- Hit the lilypad button to engrave. It should look something like this:
![Frescobaldi screenshot](assets/img/frescobaldi-screenshot.png)
- If the notation looks strange to you, you need to use the dropdown menu next to the engrave button to select a different PDF file to view. (One of them is traditional notation, one uses shape-note heads, and one uses Clairnote notation. You get three for the price of one!)
- Find and replace "Kenan Schaefkofer" with your name, and re-engrave to see the change. Now _you_ are the one doing the typesetting and (hopefully) making your contributions free for all!

### Leverage your individual creative energies

Experiment by changing things!
- Maybe change the title, or some of the lyrics and see if your changes show up in the PDF.
- Change some note letters in the `soprano = `, `alto = `, etc. For example, maybe change the first `a4` to `gs4` to change the soprano's first quarter note from `A` to `G#`.
- Then go [learn the basics of Lilypond](https://lilypond.org/doc/v2.20/Documentation/learning/simple-notation)

### Audio playback

If you want to _hear_ the music, you will need to install a program to play `.midi` files:
 - Linux instructions: <https://github.com/frescobaldi/frescobaldi/wiki/MIDI-playback-on-Linux>
 - Mac instructions: <https://github.com/frescobaldi/frescobaldi/wiki/MIDI-playback-on-Mac-OS-X>

Then, with the synthesizer application running, go into Frescobaldi's settings and change the MIDI output device to the synthesizer.

### Creating a new song

If you haven't already, go [learn the basics of Lilypond](https://lilypond.org/doc/v2.20/Documentation/learning/simple-notation). It will make doing basic things much less painful.

To create a song called "My Song":
* Run the script `scripts/new_song_from_template.sh my_song`. This just copies the a template file into a new file at `lilypond/songs/my_song/my_song.ly`.
* Or manually: create a new directory `my_song` in `lilypond/songs/`, and copy `lilypond/hymn_template/hymn_template.ly` to `my_song/my_song.ly`.

The first thing you'll do after creating the new song file:
* Remove the included `shared_tune` (unless you just want to provide new lyrics to an existing tune)
* Fill out everything in the `TUNE INFO`, and `SONG INFO`
* Add some notes to soprano, alto, tenor, and bass
* Add some lyrics in verseA-verseF
* Make weird special-case tweaks (Scroll down to appendix)
* Check your work frequently by saving/re-engraving!

The `\include` files do a lot of setup and formatting, such that song file can simply give info, notes, lyrics, and chords, and all the difficult formatting and multiple outputs should just work.

### Adding your new song to the website

Email it to me or use a Github PR.

TODO: add more details.

### Appendix: Ok, but what if I want to do [weird special-case thing?]

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