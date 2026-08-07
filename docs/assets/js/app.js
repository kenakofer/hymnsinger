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
    document.getElementById('play-bar-background').addEventListener("click", function(event){
        var percentage = (event.clientX-this.offsetLeft) / this.offsetWidth * 100;
        Player.skipToPercent(percentage);
    });

    // Show the advanced playback settings iff the window is wide enough for the
    // wide css and the height is tall enough to not show a scroll bar with the
    // panel open
    if (window.innerWidth >= 961 && window.innerHeight >= 754) {
        document.getElementById('playback-settings').open = true;
    }

    const urlParams = new URLSearchParams(window.location.search);

    // ?lead is an old link and must keep meaning the plain sheet, so it sets
    // the frets toggle off rather than falling through to the guitar default.
    if (urlParams.has("lead")) {
        changeFrets('lead');
    }
    // ?guitar / ?uke select the chord tab with that instrument's diagrams, and
    // ?roman the numeral spelling. On a song with no chords none of those
    // books were engraved, so the link falls back to the plain sheet rather
    // than requesting a missing image.
    if (urlParams.has("guitar") || urlParams.has("uke") || urlParams.has("roman")) {
        if (window.hasChords)
            changeFrets(urlParams.has("guitar") ? 'guitar'
                        : urlParams.has("uke") ? 'uke' : 'roman');
        else
            changeImage('lead');
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
	document.getElementById('play-button').innerHTML = 'Pause';
}

var pause = function() {
	Player.pause();
	document.getElementById('play-button').innerHTML = 'Play';
}

var stop = function() {
	Player.stop();
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
			document.getElementById('play-bar').style.width = 100 - (.98 * Player.getSongPercentRemaining()) + '%';
		});

		Player.loadArrayBuffer(buffer);

		document.getElementById('play-button').removeAttribute('disabled');

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
