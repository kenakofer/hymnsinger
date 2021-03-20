#!/usr/bin/env python3
import sys
import os

meter_words = [
    "CM",
    "CMD"
    "D",
    "LM",
    "SM",
    "extended",
    "irregular",
    "with",
    "refrain"
]

def get_tags(all_lines):
    for i, line in enumerate(all_lines):
        line = line.strip()
        listed_tags = []
        if line.replace(" ", "").startswith('tags="'):
            tag_string = line[line.index('"')+1:-1]
            listed_tags = tag_string.split()
            break
    return listed_tags + get_computed_tags(all_lines)

def get_computed_tags(all_lines):
    computed_tags = []
    if has_chord_symbols(all_lines):
        computed_tags.append("chords")
    return computed_tags

def has_chord_symbols(all_lines):
    for line in all_lines:
        if line.strip().replace(" ","").startswith("songChords=\chords"):
            return True
    return False

def get_title(all_lines):
    for line in all_lines:
        search_for = "\\titleText"
        if search_for in line:
            index = line.index(search_for) + len(search_for) + 1
            line = line[index:].strip()
            return line[1:-1]

def get_stanza_count(all_lines):
    for line in all_lines:
        search_for = "verseCount ="
        if search_for in line:
            index = line.index(search_for) + len(search_for) + 1
            line = line[index:].strip()
            return line

def get_tune_and_meter(all_lines):
    for line in all_lines:
        search_for = "meter = \\smallText"
        if search_for in line:
            index = line.index(search_for) + len(search_for) + 1
            line = line[index:].strip()
            tune_and_meter = line[1:-1] # Strip quotes
            tune_words = tune_and_meter.split()
            meter_words = [tune_words.pop()]
            while ismeterword(tune_words[-1]):
                meter_words.insert(0, tune_words.pop())
            return (" ".join(tune_words), " ".join(meter_words))

def ismeterword(word):
    if word in meter_words:
        return True
    return any(char.isdigit() for char in word)

def get_date_added(all_lines):
    for line in all_lines:
        search_for = "dateAdded ="
        if search_for in line:
            index = line.index(search_for) + len(search_for) + 1
            line = line[index:].strip()
            datestring = line[1:-1].replace("-","/") # Strip quotes
            return datestring

def get_tag_html(tag):
    return '<a class="taglink" href="#">'+tag+'</a>'

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
        if line.startswith("verseCount"):
            pass
        elif line.startswith("verse") and not line.endswith("}"):
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


def output_table_row(song_file_base, song_title, lyrics, tune, meter, stanza_count, tags, date_added, output_file):
    with open(output_file, 'a') as f:
        f.write("<tr><td class='hymn-name-box'><a href=\"{{ site.baseurl }}/listing/"+song_file_base+".html\">")
        f.write(song_title)
        f.write("</a>")
        f.write("</td><td class='tune-box'>")
        f.write(tune)
        f.write("</td><td class='meter-box'>")
        f.write(meter)
        f.write("</td><td class='lyric-box'><div>")
        f.write(lyrics)
        f.write("</div></td><td class='stanzas-box'>")
        f.write(stanza_count + ".")
        f.write("</td><td class='tags-box'><div>")
        for tag in tags:
            f.write(get_tag_html(tag))
        f.write("</div></td>")
        f.write("<td class='date-added-box'>")
        f.write(date_added)
        f.write("</td>")
        f.write("</tr>")

def output_header_info(song_file_base, song_title, lyrics, tags, output_file):
    with open(output_file, 'a') as f:
        f.write("song_file: "+song_file_base)
        f.write("\n")
        f.write('title: "'+song_title+'"')
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
        for l in lines:
            search = '\include "../../shared_tunes/'
            if l.startswith(search):
                included_path = "lilypond/shared_tunes/" + l[len(search):].strip()[:-1]
                include_lines = open(included_path, 'r').readlines()
                lines = include_lines + lines
                break
        all_lyrics = get_lyrics(lines)
        all_tags = get_tags(lines)
        song_title = get_title(lines)
        tune, meter = get_tune_and_meter(lines)
        stanza_count = get_stanza_count(lines)
    date_added = get_date_added(lines)
    for output_file in index_files_to_append_to:
        output_table_row(song_file_base, song_title, all_lyrics, tune, meter, stanza_count, all_tags, date_added, output_file)

    song_markdown_file = "docs/listing/"+song_file_base+".md"
    output_header_info(song_file_base, song_title, all_lyrics, all_tags, song_markdown_file)



