var MidiPlayer = MidiPlayer;
var loadFile, Player, loadArrayBuffer;
var AudioContext = window.AudioContext || window.webkitAudioContext || false; 
var ac = new AudioContext || new webkitAudioContext;

var changeTempo = function(tempo) {
	Player.tempo = tempo;
        document.getElementById('tempo-input').value = tempo;
        document.getElementById('tempo-display').innerHTML = tempo;
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
	document.getElementById('play-button').innerHTML = 'Play';
}
var channel_to_velocity = {
    1: 110,
    2: 60,
    3: 70,
    4: 80
}
var note_playing_on_channel = {
    1: 0
}

//Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/MusyngKite/acoustic_guitar_nylon-mp3.js').then(function (instrument) {
Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/MusyngKite/acoustic_grand_piano-mp3.js').then(function (instrument) {

	loadArrayBuffer = function(buffer) {
		Player = new MidiPlayer.Player(function(event) {
                        //console.log(event);
			if (event.name == 'Note on') {
                            my_velocity = channel_to_velocity[event.channel]
                            if (event.velocity == 0) {
                                note_playing_on_channel[event.channel].stop(ac.currentTime);
                                note_playing_on_channel[event.channel] = 0;
                            } else {
                                note_playing_on_channel[event.channel] = instrument.play(event.noteName, ac.currentTime, {gain:my_velocity/100})
                            }
			}

			document.getElementById('tempo-display').innerHTML = Player.tempo;
			document.getElementById('play-bar').style.width = 100 - Player.getSongPercentRemaining() + '%';
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
