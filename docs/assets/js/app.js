var MidiPlayer = MidiPlayer;
var loadFile, Player, loadArrayBuffer;
var AudioContext = window.AudioContext || window.webkitAudioContext || false;
var ac = new AudioContext || new webkitAudioContext;

var changeTempo = function(tempo) {
        was_playing = Player.isPlaying()
        Player.pause();
	Player.tempo = tempo;
        document.getElementById('tempo-input').value = tempo;
        document.getElementById('tempo-display').innerHTML = tempo + ' BPM';
        if (was_playing)
            Player.play();
}

window.addEventListener('keydown', function(e) {
  if(e.keyCode == 32 && e.target == document.body) {
    e.preventDefault();
    click_play()
  }
});

document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);

    // ?lead is an old link and must keep meaning the plain sheet, so it sets
    // the frets toggle off rather than falling through to the guitar default.
    if (urlParams.has("lead")) {
        changeFrets('lead');
    }
    // ?guitar / ?uke select the chord tab with that instrument's diagrams. On a
    // song with no chords neither book was engraved, so the link falls back to
    // the plain sheet rather than requesting a missing image.
    if (urlParams.has("guitar") || urlParams.has("uke")) {
        if (window.hasChords)
            changeFrets(urlParams.has("guitar") ? 'guitar' : 'uke');
        else
            changeImage('lead');
    }
    // ?roman is its own tab now rather than a frets setting, but the old links
    // are the same string and must keep landing on the same engraving.
    if (urlParams.has("roman")) {
        if (window.hasChords) {
            document.getElementById('roman').checked = true;
            changeImage('roman');
        } else {
            changeImage('lead');
        }
    }
    if (urlParams.has("shapenote")) {
        document.getElementById('shapenote').checked = true;
        changeImage('shapenote');
    }
    if (urlParams.has("4shapenote")) {
        document.getElementById('4shapenote').checked = true;
        changeImage('4shapenote');
    }
    if (urlParams.has("clairnote")) {
        document.getElementById('clairnote').checked = true;
        changeImage('clairnote');
    }
    if (urlParams.has("slides")) {
        document.getElementById('slides').checked = true;
        changeImage('slides');
    }
    // The transposed views, e.g. ?trad-up1 or ?guitar-dn2. Kept as valueless
    // params to match the notation links above.
    //
    // The chord books name a book, not a tab: ?guitar-up1 means the chord tab
    // with guitar frets, up a semitone. Each is checked against the same
    // suffix table so a new transposable book only needs adding to this list.
    ['trad', 'lead', 'guitar', 'uke'].forEach(function (book) {
        Object.keys(TRANSPOSE_SUFFIX).forEach(function (steps) {
            if (steps == "0") return;
            if (!urlParams.has(book + TRANSPOSE_SUFFIX[steps])) return;
            if (book == 'trad') {
                document.getElementById('trad').checked = true;
                window.currentVariant = 'trad';
            } else {
                // Chord books share the one tab; the book picks the frets.
                if (!window.hasChords && book != 'lead') return;
                document.getElementById('lead').checked = true;
                window.currentVariant = 'lead';
                window.currentFrets = book;
            }
            window.currentTranspose = parseInt(steps, 10);
            renderScore();
        });
    });

    // Sync the controls to whatever state the params left us in - including
    // the common case of no params at all, which lands on the traditional tab
    // and runs none of the branches above.
    //
    // Without this the frets toggle keeps whatever its markup said until the
    // first click: it ships visible, so a plain page load showed three
    // fretboard buttons over a four-part score they do not apply to.
    renderScore();
}, false);

var click_play = function() {
    Player.isPlaying() ? pause() : play();
}

var play = function() {
    ac.resume(); // Needed for safari, which doesn't allow audio to play on page load, only on UI events
	Player.play();
	syncPlayButtons('Pause');
}

var pause = function() {
	Player.pause();
	syncPlayButtons('Play');
	// The follow runs off its own clock between note events, so without this
	// it carries on scrolling against a song that has stopped.
	if (typeof scrollFollowStop == 'function') scrollFollowStop();
}

var stop = function() {
	Player.stop();
	// Player.stop() emits no events, so the bars and the buttons it should
	// have reset are set here instead.
	var bar = document.getElementById('sheet-bar');
	if (bar) bar.style.width = '2%';
	syncPlayButtons('Play');
	syncStopButtons(true);
	// The playhead is back at the start, so the page should be too - otherwise
	// pressing stop leaves the view halfway down a song that is no longer
	// playing there.
	if (typeof scrollFollowToStart == 'function') scrollFollowToStart();
}
var channel_to_velocity = {
    1: 200,
    2: 90,
    3: 105,
    4: 120
}
var note_playing_on_channel = {
    1: 0
}

//Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/MusyngKite/acoustic_guitar_nylon-mp3.js').then(function (instrument) {

// Ogg does not work in safari for some reason, so we'll stick with mp3 for now.
//Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/FluidR3_GM/acoustic_grand_piano-ogg.js').then(function (instrument) {
Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/FluidR3_GM/acoustic_grand_piano-mp3.js').then(function (instrument) {

	setUpPlayer = function(buffer) {
		Player = new MidiPlayer.Player(function(event) {
                        //console.log(event);
			if (event.name == 'Note on') {
                            my_velocity = channel_to_velocity[event.channel]
                            note_index = event.channel +' '+ event.noteName;
                            if (event.velocity == 0) {
                                if (note_playing_on_channel[note_index])
                                    note_playing_on_channel[note_index].stop(ac.currentTime);
                                note_playing_on_channel[note_index] = 0;
                            } else {
                                note_playing_on_channel[note_index] = instrument.play(event.noteName, ac.currentTime, {gain:my_velocity/100})
                            }
			}

			document.getElementById('tempo-display').innerHTML = Player.tempo + ' BPM';
			var done = 100 - (.98 * Player.getSongPercentRemaining());
			var pct = done + '%';
			// Follow the music, when asked to.
			//
			// Position comes from the tick counter, not from the seconds
			// helpers: getSongTimeRemaining rounds to whole seconds, so the
			// fraction it implies only moves in one-second quanta, and the
			// rounding goes up as often as down. Feeding that to the follower
			// made it lurch back and forth by half a second's worth of page on
			// every note. Ticks are exact.
			if (typeof scrollFollowProgress == 'function') {
				var totalTicks = Player.totalTicks;
				var doneTicks = Player.getCurrentTick();
				var totalSecs = Player.getSongTime();
				// Whole seconds are precise enough to decide "about to loop",
				// which is all this is used for.
				var leftSecs = Player.getSongTimeRemaining();
				if (totalTicks > 0 && totalSecs > 0)
					scrollFollowProgress(doneTicks / totalTicks,
					                     totalSecs * (1 - doneTicks / totalTicks));
				// Loop restarts only once the song has ended, so the trip back
				// to the top has to be started before that or it lands after
				// the repeat's first note.
				if (document.getElementById('loop-checkbox').checked)
					scrollFollowLoopAhead(leftSecs);
			}
			// One transport on both layouts: the sheet head, which is
			// the phone's peeking dock and the desktop sidebar's top row.
			var bar = document.getElementById('sheet-bar');
			if (bar) bar.style.width = pct;
			// 2% is the bar's own resting width, so anything above it means
			// the playhead has left the start and "back to start" has a job.
			syncStopButtons(done <= 2);
		});

		Player.loadArrayBuffer(buffer);

		document.getElementById('sheet-play').removeAttribute('disabled');

		//play();
	}


    var oReq = new XMLHttpRequest();
    oReq.open("GET", window.midi_url, true);
    oReq.responseType = "arraybuffer";
    oReq.onload = function(oEvent) {
      window.midi_buffer = oReq.response;
      setUpPlayer(window.midi_buffer);
      changeTempo(Player.tempo);
    };
    oReq.send();
});
