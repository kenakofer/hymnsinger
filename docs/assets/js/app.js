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

var click_play = function() {
    Player.isPlaying() ? pause() : play();
}

var play = function() {
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
    1: 150,
    2: 90,
    3: 105,
    4: 120
}
var note_playing_on_channel = {
    1: 0
}

//Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/MusyngKite/acoustic_guitar_nylon-mp3.js').then(function (instrument) {
Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/FluidR3_GM/acoustic_grand_piano-ogg.js').then(function (instrument) {

	loadArrayBuffer = function(buffer) {
		Player = new MidiPlayer.Player(function(event) {
                        //console.log(event);
			if (event.name == 'Note on') {
                            my_velocity = channel_to_velocity[event.channel]
                            note_index = event.channel +' '+ event.noteName;
                            if (event.velocity == 0) {
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
      loadArrayBuffer(window.midi_buffer);
      changeTempo(Player.tempo);
    };
    oReq.send();
});
