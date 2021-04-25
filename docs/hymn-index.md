---
title: Complete Index
description: A complete searchable list of every song, hymn, or musical work provided without restriction on this site. Click on a song to view or download the full sheet music, or listen to the audio playback.
layout: default
---

{% include data-table.html %}

# Complete Index

<div id='toggle-vis-panel'>
Toggle:
<a class="toggle-vis" data-column="0" href="#">Song</a> |
<a class="toggle-vis" data-column="1" href="#">Tune</a> |
<a class="toggle-vis off" data-column="2" href="#">Other Titles</a> |
<a class="toggle-vis off" data-column="3" href="#">Key</a> |
<a class="toggle-vis off" data-column="4" href="#">Meter</a> |
<a class="toggle-vis off" data-column="5" href="#">Composer</a> |
<a class="toggle-vis" data-column="6" href="#">Lyrics</a> |
<a class="toggle-vis off" data-column="7" href="#"># Stanzas</a> |
<a class="toggle-vis off" data-column="8" href="#">Poet</a> |
<a class="toggle-vis" data-column="9" href="#">Tags</a> |
<a class="toggle-vis" data-column="10" href="#">Date Added</a>
</div>

<table id='song-table' cellspacing='0' width='100%'><thead>
<th>Song</th>
<th>Tune</th>
<th>Other Titles</th>
<th>Key</th>
<th>Meter</th>
<th>Composer</th>
<th>Lyrics</th>
<th>#</th>
<th>Poet</th>
<th>Tags</th>
<th>Added</th>
</thead>
{% for song_hash in site.data.songs %}
{% assign song = song_hash[1] %}
<tr>
  <td class='hymn-name-box'><a href="{{ site.baseurl }}/listing/{{ song.song_file }}.html">{{ song.title }}</a></td>
  <td class='tune-box'>{{ song.tune }}</td>
  <td class='same-tune-box'>
    {% for other in song.songs_with_same_tune %}
      {% if other.i %}
        <span class="internal"><a href="{{ site.baseurl }}/listing/{{ other.i }}.html">{{ other.s }}</a></span>
      {% elsif other.e %}
        <span class="external"><a class="external" target="_blank" href="{{ other.e }}">{{ other.s }}</a></span>
      {% else %}
        <span class="nolink">{{ other.s }}</span>
      {% endif %}
    {% endfor %}
  </td>
  <td class='key-box'>{{ song.key }}</td>
  <td class='meter-box'>{{ song.meter }}</td>
  <td class='composer-box'>{{ song.composer }}</td>
  <td class='lyric-box'><div>{{ song.lyrics }}</div></td>
  <td class='stanzas-box'>{{ song.stanza_count }}</td>
  <td class='poet-box'>{{ song.poet }}</td>
  <td class='tags-box'><div>
    {% for tag in song.tags %}
      <a class="taglink" href="#">{{ tag }}</a>
    {% endfor %}
  </div></td>
  <td class='date-added-box'>{{ song.date_added }}</td>
</tr>
{% endfor %}
</table>
