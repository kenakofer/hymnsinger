#!/usr/bin/env python3
import sys
import os

def get_tags(all_lines):
    for i, line in enumerate(all_lines):
        line = line.strip()
        if line.replace(" ", "").startswith('tags="'):
            tag_string = line[line.index('"')+1:-1]
            tags = tag_string.split()
            return tags

def get_tag_html(tag):
    return '<a class="taglink" href="{{ site.baseurl }}/tags/'+tag+'.html">'+tag+'</a>'

if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        get_tags(f.readlines())

def get_lyrics(all_lines):
    current_verse = None
    chorus_mode = False
    remove_quotes = False
    lyrics = ""
    for i, line in enumerate(all_lines):
        line = line.strip()
        if line.startswith("verse") and not line.endswith("}"):
            current_verse = True
            remove_quotes = False
        elif line.endswith("LYRICS-START"):
            current_verse = True
            remove_quotes = True
        elif line.startswith('%% CHORUS'):
            chorus_mode = True
            lyrics+="\n"
        elif line.startswith('%% END CHORUS'):
            chorus_mode = False
            lyrics+="\n"
        elif current_verse and line.strip().startswith("}"):
            current_verse = None
            chorus_mode = False
            lyrics+="\n"
        elif current_verse:
            prefix = "  " if chorus_mode else "" 
            lyrics+=prefix + join_verse_line(line, remove_quotes) + "\n"
    return lyrics

def join_verse_line(line, remove_quotes):
    stripped = line.strip()
    if remove_quotes:
        stripped = stripped[1:-1].replace('\\"','"')
    words = stripped.replace("_","").split()
    while "--" in words:
        index = words.index("--")
        words[index-1:index+2] = [words[index-1] + words[index+1]]
    return " ".join(words)


def output_table_row(song_file_base, lyrics, tags, output_file):
    with open(output_file, 'a') as f:
        f.write("<tr><td class='hymn-name-box'><a href=\"listing/"+song_file_base+".html\">")
        song_title = " ".join(map(lambda w: w[0].upper() + w[1:], song_file_base.split("_")))
        f.write(song_title)
        f.write("</a></td><td class='lyric-box'>")
        f.write(lyrics)
        f.write("</td><td class='tags-box'>")
        for tag in tags:
            f.write(get_tag_html(tag))
        f.write("</td></tr>")


if __name__ == "__main__":
    file_path = sys.argv[1]
    song_file_base = os.path.basename(file_path)
    song_file_base = song_file_base[:song_file_base.index(".")]
    files_to_append_to = ["docs/hymn-index.md"]
    with open(file_path, 'r') as f:
        lines = f.readlines()
        all_lyrics = get_lyrics(lines)
        all_tags = get_tags(lines)
    for tag in all_tags:
        files_to_append_to.append("docs/tags/"+tag+".md")
    for output_file in files_to_append_to:
        output_table_row(song_file_base, all_lyrics, all_tags, output_file)

