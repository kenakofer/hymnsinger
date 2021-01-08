---
layout: song_page
tags: hymn accessible listed
song_file: REPLACE_WITH_FILENAME_BASE
---

<table id="score-variants">
<tr>
<td>
<input type="radio" id="traditional" name="variant-radio" onclick="changeImage('trad');">
<label for="traditional">Traditional Score</label>
</td><td>
<input type="radio" id="shapenote" name="variant-radio" onclick="changeImage('shapenote');">
<label for="shapenote">Shapenote Score</label>
</td><td>
<input type="radio" id="clairnote" name="variant-radio" onclick="changeImage('clairnote');">
<label for="clairnote">Clairnote Score</label>
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

![Song image](https://github.com/kenanbit/hymn-hosting/releases/latest/download/{{ page.song_file }}-trad.png){: #music-image }
