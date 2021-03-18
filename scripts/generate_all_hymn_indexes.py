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

def get_title(all_lines):
    for line in all_lines:
        search_for = "\\titleText"
        if search_for in line:
            index = line.index(search_for) + len(search_for) + 1
            line = line[index:].strip()
            return line[1:-1]


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
    for line in all_lines:
        line = line.strip()
        if line.startswith("verse") and not line.endswith("}"):
            current_verse = True
            remove_quotes = False
        elif line.endswith("LYRICS-START"):
            current_verse = True
            remove_quotes = True
        elif line.startswith("\\"):
            pass
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
            line = prefix + join_verse_line(line, remove_quotes)
            if not line.isspace():
                lyrics+=prefix + join_verse_line(line, remove_quotes) + "\n"
    while "\n\n\n" in lyrics:
        lyrics = lyrics.replace("\n\n\n", "\n\n")
    return lyrics.strip() + "\n"

def join_verse_line(line, remove_quotes):
    stripped = line.strip().replace('*', '')
    if remove_quotes and stripped.startswith('"') and stripped.endswith('"'):
        stripped = stripped[1:-1].replace('\\"','"')

    words = stripped.replace("_","").split()
    if "%%" in words:
        words.remove("%%")
    # Remove quotes and asterisks on individual words
    for i in range(len(words)):
        if words[i][0] == '"' and words[i][-1] == '"':
            words[i] = words[i][1:-1]

    while "--" in words:
        index = words.index("--")
        words[index-1:index+2] = [words[index-1] + words[index+1]]
    return " ".join(words)


def output_table_row(song_file_base, song_title, lyrics, tags, output_file):
    with open(output_file, 'a') as f:
        f.write("<tr><td class='hymn-name-box'><a href=\"{{ site.baseurl }}/listing/"+song_file_base+".html\">")
        f.write(song_title)
        f.write("</a></td><td class='lyric-box'>")
        f.write(lyrics)
        f.write("</td><td class='tags-box'>")
        for tag in tags:
            f.write(get_tag_html(tag))
        f.write("</td></tr>")

def output_header_info(song_file_base, song_title, lyrics, tags, output_file):
    with open(output_file, 'a') as f:
        f.write("song_file: "+song_file_base)
        f.write("\n")
        f.write("title: "+song_title)
        f.write("\n")
        tag_string = " ".join(tags)
        lyrics_string = lyrics[:150].replace("\n", " ")
        f.write('description: "'+lyrics_string+'... '+tag_string+'"')
        f.write("\n")
        f.write("image: https://github.com/kenanbit/hymn-singer/releases/latest/download/"+song_file_base+"-trad.png")
        f.write("\n")
        f.write("---")
        f.write("\n\n")
        f.write("{% include choice_and_music.html %}")

if __name__ == "__main__":
    file_path = sys.argv[1]
    song_file_base = os.path.basename(file_path)
    song_file_base = song_file_base[:song_file_base.index(".")]
    index_files_to_append_to = ["docs/hymn-index.md"]
    with open(file_path, 'r') as f:
        lines = f.readlines()
        all_lyrics = get_lyrics(lines)
        all_tags = get_tags(lines)
        song_title = get_title(lines)
    for tag in all_tags:
        index_files_to_append_to.append("docs/tags/"+tag+".md")
    for output_file in index_files_to_append_to:
        output_table_row(song_file_base, song_title, all_lyrics, all_tags, output_file)

    song_markdown_file = "docs/listing/"+song_file_base+".md"
    output_header_info(song_file_base, song_title, all_lyrics, all_tags, song_markdown_file)



