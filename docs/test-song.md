---
layout: song_page
song_file: come_thou_long_expected_jesus
---

## Test song

We'll see how well this works...

### {{ page.song_file }}

{{ site.url }}

<button id="traditional" onclick="changeImage('trad');">Traditional Score</button>
<button id="shapenote" onclick="changeImage('shapenote');">Shape Note Score</button>
<button id="clairnote" onclick="changeImage('clairnote');">Clairnote Score</button>

![Song image](https://github.com/kenanbit/hymn-hosting/releases/latest/download/{{ page.song_file }}-trad.png){: #music_image }
