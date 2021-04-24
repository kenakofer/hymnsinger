#!/usr/bin/env python3
import sys
import os
import json

meter_words = [
    "CM",
    "CMD"
    "D",
    "LM",
    "SM",
    "extended",
    "irregular",
    "with",
    "alleluias",
    "refrain"
]

TUNE_TEXT_FILEPATH = "docs/_data/tune_text_pairs.json"
SONG_DATA_DIR = "docs/_data/songs/"

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

def get_key(all_lines):
    search_for = "hymnKey=\key"
    for line in all_lines:
        line = line.replace(" ", "")
        if line.startswith(search_for):
            index = line.index(search_for) + len(search_for)
            line = line[index:].replace("\\", " ")
            line = line[0].upper() + line[1:]
            if line[1] == "f":
                line = line[0] + "-flat" + line[2:]
            if line[1] == "s":
                line = line[0] + "-sharp" + line[2:]
            return line
    return "C major"

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

def get_composer_info(all_lines):
    composer_search_for = 'composer = \\smallText "Music:'
    arranger_search_for = "arranger = \\smallText"
    composer = ""
    arranger = ""
    for line in all_lines:
        if line.startswith(composer_search_for):
            index = line.index(composer_search_for) + len(composer_search_for) + 1
            line = line[index:].strip()
            composer = line[:-1] # Strip trailing quote
        if line.startswith(arranger_search_for):
            index = line.index(arranger_search_for) + len(arranger_search_for) + 1
            line = line[index:].strip()
            arranger = ";\n" + line[1:-1] # Strip trailing quote
    return composer + arranger

def get_poet_info(all_lines):
    search_for = 'poet = \\smallText "Text:'
    two_line_search_for = 'poet = \\twoLineSmallText "Text:'
    for line in all_lines:
        if line.startswith(search_for):
            index = line.index(search_for) + len(search_for) + 1
            line = line[index:].strip()
            return line[:-1] # Strip trailing quote
        if line.startswith(two_line_search_for):
            index = line.index(two_line_search_for) + len(two_line_search_for) + 1
            line = line[index:].strip()
            return line.replace('"', '')
    raise Exception("Poet not found")

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
        elif line.startswith("\\") and not line.startswith("\\l "):
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

    words = stripped.replace("_","").replace("~"," ").split()
    if "%%" in words:
        words.remove("%%")
    if "\\l" in words:
        words.remove("\\l")
    # Remove quotes and asterisks on individual words
    for i in range(len(words)):
        if words[i][0] == '"' and words[i][-1] == '"':
            words[i] = words[i][1:-1]

    while "--" in words:
        index = words.index("--")
        words[index-1:index+2] = [words[index-1] + words[index+1]]
    return " ".join(words)

def add_song_json(data):
    output_file = SONG_DATA_DIR + data['song_file'] + ".json"
    with open(output_file, 'w') as f:
        f.write(json.dumps(data, indent=2))

def get_description(lyrics, tags):
    tag_string = " ".join(tags)
    lyrics_string = lyrics[:150].replace("\n", " ")
    return 'View, play, and download the PDF sheet music, slideshow, and audio. Lyrics: '+lyrics_string+'... '+tag_string

def get_image(song_file_base):
    return "https://github.com/kenanbit/hymn-singer/releases/latest/download/"+song_file_base+"-trad.png"

def output_header_info(song_file_base, song_title, lyrics, tags, output_file):
    with open(output_file, 'a') as f:
        f.write("song_file: "+song_file_base)
        f.write("\n")
        f.write('title: "'+song_title+'"')
        f.write("\n")
        f.write('description: "'+get_description(lyrics, tags)'"')
        f.write("\n")
        f.write("image: "+get_image(song_file_base))
        f.write("\n")
        f.write("---")
        f.write("\n\n")
        f.write("{% include choice_and_music.html %}")


def get_songs_with_same_tune(tune, song_title):
    data = json.load(open(TUNE_TEXT_FILEPATH, "r"))
    data = [d for d in data if d['t'] == tune and d['s'] != song_title]
    return data

def add_tune_text_pair(tune, song_title, song_file_base):
    record = {
        "t":tune,
        "s":song_title,
        "i":song_file_base
    }
    incomplete_record = {
        "t":tune,
        "s":song_title
    }

    data = json.load(open(TUNE_TEXT_FILEPATH, "r"))

    if data and not record in data:
        if incomplete_record in data:
            data.remove(incomplete_record)
        data.append(record)
        data.sort(key=lambda l: l['t'])
        write_out_tune_text_json(data)

def write_out_tune_text_json(data):
    with open(TUNE_TEXT_FILEPATH, "w") as f:
        f.write("[\n")
        for i, d in enumerate(data):
            f.write(json.dumps(d))
            if i < len(data) - 1:
                f.write(",")
            f.write("\n")
        f.write("]")

if __name__ == "__main__":
    file_path = sys.argv[1]
    song_file_base = os.path.basename(file_path)
    song_file_base = song_file_base[:song_file_base.index(".")]
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for l in lines:
            search = '\include "../../shared_tunes/'
            if l.startswith(search):
                included_path = "lilypond/shared_tunes/" + l[len(search):].strip()[:-1]
                include_lines = open(included_path, 'r').readlines()
                lines = include_lines + lines
                break
        tune, meter = get_tune_and_meter(lines)
        song_data = {
            "song_file": song_file_base,
            "title": get_title(lines),
            "tune": tune,
            "meter": meter,
            "stanza_count": get_stanza_count(lines),
            "composer": get_composer_info(lines),
            "poet": get_poet_info(lines),
            "key": get_key(lines),
            "date_added": get_date_added(lines),
            "tags": get_tags(lines),
            "lyrics": get_lyrics(lines),
            "image": get_image(song_file_base)
        }
        song_data["description"] = get_description(song_data["lyrics"], song_data["tags"])

        add_tune_text_pair(song_data['tune'], song_data['title'], song_data['song_file'])
        song_data["songs_with_same_tune"] = get_songs_with_same_tune(song_data["tune"], song_data["title"])

        song_markdown_file = "docs/listing/"+song_file_base+".md"
        output_header_info(song_data['song_file'], song_data['title'], song_data['lyrics'], song_data['tags'], song_markdown_file)
        add_song_json(song_data)
