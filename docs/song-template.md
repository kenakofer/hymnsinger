---
layout: song_page
tags: hymn accessible listed
song_file: REPLACE_WITH_FILENAME_BASE
---

<table id="score-variants">
<tr>
<td>
<button id="traditional" onclick="changeImage('trad');">Traditional Score</button>
</td><td>
<button id="shapenote" onclick="changeImage('shapenote');">Shape Note Score</button>
</td><td>
<button id="clairnote" onclick="changeImage('clairnote');">Clairnote Score</button>
</td>
</tr>
<tr>
<td>
(<a href="https://github.com/kenanbit/hymn-hosting/releases/latest/download/{{ page.song_file }}-trad.pdf">PDF</a>)
</td><td>
(<a href="https://github.com/kenanbit/hymn-hosting/releases/latest/download/{{ page.song_file }}-shapenote.pdf">PDF</a>)
</td><td>
(<a href="https://github.com/kenanbit/hymn-hosting/releases/latest/download/{{ page.song_file }}-clairnote.pdf">PDF</a>)
</td>
</tr>
</table>

![Song image](https://github.com/kenanbit/hymn-hosting/releases/latest/download/{{ page.song_file }}-trad.png){: #music_image }
