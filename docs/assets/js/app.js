var MidiPlayer = MidiPlayer;
var loadFile, Player, loadArrayBuffer;
var AudioContext = window.AudioContext || window.webkitAudioContext || false; 
var ac = new AudioContext || new webkitAudioContext;

var changeTempo = function(tempo) {
	Player.tempo = tempo;
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
    1: 130,
    2: 50,
    3: 0,
    4: 100
}

Soundfont.instrument(ac, 'https://raw.githubusercontent.com/gleitz/midi-js-soundfonts/gh-pages/MusyngKite/acoustic_guitar_nylon-mp3.js').then(function (instrument) {
	document.getElementById('select-file').style.display = 'block';

	loadFile = function() {
		var file    = document.querySelector('input[type=file]').files[0];
		var reader  = new FileReader();
		if (file) reader.readAsArrayBuffer(file);

		reader.addEventListener("load", function () {
			Player = new MidiPlayer.Player(function(event) {
				if (event.name == 'Note on') {
                                        my_velocity = channel_to_velocity[event.channel]
                                        if (event.velocity == 0)
                                            my_velocity = 0;
                                        instrument.play(event.noteName, ac.currentTime, {gain:my_velocity/100}).stop(ac.currentTime + 0.5)
                                        //instrument.play(event.noteName, ac.currentTime, {gain:event.velocity/100});
                                        //console.log(event);
					//document.querySelector('#track-' + event.track + ' code').innerHTML = JSON.stringify(event);
				}

				document.getElementById('tempo-display').innerHTML = Player.tempo;
				document.getElementById('play-bar').style.width = 100 - Player.getSongPercentRemaining() + '%';
			});

			Player.loadArrayBuffer(reader.result);
			
			document.getElementById('play-button').removeAttribute('disabled');

			play();
		}, false);
	}

	loadArrayBuffer = function(buffer) {
		Player = new MidiPlayer.Player(function(event) {
			if (event.name == 'Note on' && event.velocity > 0) {
				instrument.play(event.noteName, ac.currentTime, {gain:event.velocity/100});
                                        console.log(event);
				//console.log(event);
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
    };
    oReq.send();
});
