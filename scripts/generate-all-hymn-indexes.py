import sys
import os
import json

METER_WORDS = [
    "CM",
    "CMD",
    "D",
    "LM",
    "SM",
    "extended",
    "irregular",
    "with",
    "alleluias",
    "refrain"
]

TUNE_TEXT_FILEPATH = "docs/_data/tune-text-pairs.json"
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
        if line.strip().replace(" ","").startswith("songChords="):
            return True
    return False

def get_key(all_lines):
    search_for = "hymnKey=\key"
    key_string = "C major"
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
            key_string = line.strip()
    return key_string


def get_exclude_from_index(all_lines):
    search_for_true = "exclude_from_index=##t"
    search_for_false = "exclude_from_index=##f"
    exclude_from_index = False
    for line in all_lines:
        line = line.replace(" ", "")
        if line.startswith(search_for_true):
            exclude_from_index = True
        elif line.startswith(search_for_false):
            exclude_from_index = False
    return exclude_from_index

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

def get_has_chords(all_lines):
    # The ukulele books are only engraved for songs that define chords, so the
    # site needs to know which songs have them - a tab whose PNG was never
    # built is a broken image, not an empty one.
    #
    # all_lines already has any shared-tunes include prepended by the caller,
    # which matters: about half the corpus inherits its chords from a shared
    # tune rather than declaring them in the song file. Checking the song file
    # alone would call those songs chordless and hide a tab that does exist.
    for line in all_lines:
        if line.startswith("songChords") or line.startswith("chordSymbols"):
            return True
    return False

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

def extract_from_source(all_lines, search_for):
    if isinstance(search_for, list):
        for s in search_for:
            result = extract_from_source(all_lines, s)
            if result:
                return result
        return None
    # Collapse runs of whitespace before matching. The patterns are written
    # by hand and the spacing in a .ly is not meaningful, so a stray double
    # space on either side should not decide whether a song gets a page:
    # 'composer = \twoLineSmallText  \markup {' carried one for a while and
    # silently failed every song using the single-spaced form.
    search_for = " ".join(search_for.split())
    for raw_line in all_lines:
        line = " ".join(raw_line.split())
        if line.startswith(search_for):
            index = line.index(search_for) + len(search_for)
            line = line[index:]
            line = line.replace('"', '')
            line = line.replace('{', '')
            line = line.replace('}', '')
            line = line.strip()
            # Check and remove any words in line that start with \
            words = line.split()
            words = [w for w in words if not w.startswith("\\")]
            return " ".join(words)
    return None

def get_composer_info(all_lines):
    composer = extract_from_source(all_lines, [
        'composer = \\smallText "Music:',
        'composer = \\twoLineSmallText "Music:',
        'composer = \\smallText \\markup { "Music:',
        'composer = \\twoLineSmallText \\markup { "Music:',
    ])
    if not composer:
        raise Exception("Composer not found")

    arranger = extract_from_source(all_lines, [
        'arranger = \\smallText ',
        'arranger = \\twoLineSmallText '
    ])
    if arranger:
        arranger = ";\n" + arranger
    else:
        arranger = ""

    return composer + arranger

def get_poet_info(all_lines):
    poet = extract_from_source(all_lines, [
        'poet = \\smallText "Text:',
        'poet = \\twoLineSmallText "Text:',
        'poet = \\smallText \\markup { "Text:',
        'poet = \\twoLineSmallText \\markup { "Text:',
    ])
    if not poet:
        raise Exception("Poet not found")
    return poet

def ismeterword(word):
    if word in METER_WORDS:
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

# Songs spell the repeated section both ways: 32 files say CHORUS, 5 say
# REFRAIN. Only CHORUS used to be recognised, so REFRAIN markers fell through
# to the lyric branch and printed as a bare "REFRAIN" / "END REFRAIN" line.
# Accept either word rather than forcing one spelling on the sources.
CHORUS_WORDS = ('CHORUS', 'REFRAIN')

def is_chorus_marker(line, prefix=''):
    if not line.startswith('%'):
        return False
    body = line.lstrip('%').strip().upper()
    if prefix:
        if not body.startswith(prefix):
            return False
        body = body[len(prefix):].strip()
    elif body.startswith('END'):
        return False
    # The marker has to be the WHOLE comment, not merely start with the word.
    # Prose comments mention these words in passing - my-hope-is-built has a
    # header note reading "The page also prints "Refrain" over m10", and a
    # prefix match on that turned chorus_mode on before verseA even began,
    # indenting the second line of verse 1 as though it were the chorus.
    return body.strip('"\' .:-') in CHORUS_WORDS

def get_lyrics(all_lines):
    current_verse = None
    chorus_mode = False
    remove_quotes = False
    is_extra = False
    lyrics = ""
    for unstripped_line in all_lines:
        line = unstripped_line.strip()
        if line.startswith("verseCount"):
            pass
        elif line.startswith("extra_verses ="):
            is_extra = True
        elif line.startswith("verse") and not line.endswith("}"):
            current_verse = True
            remove_quotes = False
        elif line.endswith("LYRICS-START"):
            current_verse = True
            remove_quotes = True
        elif line.startswith("\\") and not line.startswith("\\l "):
            pass
        elif is_chorus_marker(line, 'END'):
            chorus_mode = False
            lyrics+="\n"
        elif is_chorus_marker(line):
            chorus_mode = True
            lyrics+="\n"
        elif line.startswith('%'):
            # Any other comment inside a verse block is editorial - a note
            # about why a \markup or \set is there, why a source typo was
            # kept, and so on. It is not sung, so it must not reach the page
            # or the SEO description. This has to be a blanket skip: the
            # earlier code only knew the two CHORUS markers, so every other
            # comment fell through to the "elif current_verse" branch below,
            # where join_verse_line quietly stripped the leading %% and the
            # \commands and emitted the remaining prose as lyrics. That is
            # how "4verse.ily passes 1 as the laterLabel..." ended up printed
            # as a line of oh-have-you-not-heard.
            pass
        elif current_verse and unstripped_line.startswith("}"):
            current_verse = None
            chorus_mode = False
            lyrics+="\n"
        elif current_verse and is_extra and line.startswith("}"):
            current_verse = None
            chorus_mode = False
            lyrics+="\n"
        elif line.startswith("}"):
            pass
        elif current_verse:
            prefix = "  " if chorus_mode else ""
            line = prefix + join_verse_line(line, remove_quotes)
            if not line.isspace():
                lyrics+=line + "\n"
    while "\n\n\n" in lyrics:
        lyrics = lyrics.replace("\n\n\n", "\n\n")
    return lyrics.strip() + "\n"

def join_verse_line(line, remove_quotes):
    stripped = line.strip().replace('*', '')
    if remove_quotes and stripped.startswith('"') and stripped.endswith('"'):
        stripped = stripped[1:-1].replace('\\"','"')

    words = stripped.replace("_","").replace("~"," ").split()

    # Filter out lilypond tokens %% and \command
    words = [w for w in words if not w.startswith("%%") and not w.startswith("\\")]

    # Remove quotes and asterisks on individual words
    for i in range(len(words)):
        if words[i][0] == '"' and words[i][-1] == '"':
            words[i] = words[i][1:-1]
        words[i] = words[i].replace('"','') # Any " in the source is syntactic. Get rid!
        words[i] = words[i].replace("''",'"') # And now we can turn the '' into a proper ", no longer syntactic


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
    lyrics_string = lyrics[:150].replace("\n", " ").replace('"', '\\"')
    return 'View, play, and download the PDF sheet music, slideshow, and audio. Lyrics: '+lyrics_string+'... '+tag_string

def get_image(song_file_base):
    return "/local-lilypond-outputs/"+song_file_base+"-trad.png"

def output_header_info(song_file_base, exclude_from_index, song_title, lyrics, tags, output_file):
    with open(output_file, 'w') as f:
        f.write("---")
        f.write("\n")
        f.write("layout: song-page")
        f.write("\n")
        f.write("song_file: "+song_file_base)
        f.write("\n")
        f.write('title: "'+song_title+'"')
        f.write("\n")
        f.write('description: "'+get_description(lyrics, tags)+'"')
        f.write("\n")
        f.write("image: "+get_image(song_file_base))
        f.write("\n")
        if exclude_from_index:
            f.write("exclude_from_index: true")
            f.write("\n")
        f.write("---")
        f.write("\n\n")
        f.write("{% include choice-and-music.html %}")


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
    song_markdown_file = sys.argv[2]
    song_file_base = os.path.basename(song_markdown_file)
    song_file_base = song_file_base[:song_file_base.index(".")]
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for l in lines:
            search = '\include "../../shared-tunes/'
            if l.startswith(search):
                included_path = "lilypond/shared-tunes/" + l[len(search):].strip()[:-1]
                include_lines = open(included_path, 'r').readlines()
                lines = include_lines + lines
                break
        tune, meter = get_tune_and_meter(lines)
        song_data = {
            "song_file": song_file_base,
            "exclude_from_index": get_exclude_from_index(lines),
            "title": get_title(lines),
            "tune": tune,
            "meter": meter,
            "stanza_count": get_stanza_count(lines),
            "composer": get_composer_info(lines),
            "poet": get_poet_info(lines),
            "key": get_key(lines),
            "date_added": get_date_added(lines),
            "tags": get_tags(lines),
            "has_chords": get_has_chords(lines),
            "lyrics": get_lyrics(lines),
            "image": get_image(song_file_base)
        }
        song_data["description"] = get_description(song_data["lyrics"], song_data["tags"])

        add_tune_text_pair(song_data['tune'], song_data['title'], song_data['song_file'])
        song_data["songs_with_same_tune"] = get_songs_with_same_tune(song_data["tune"], song_data["title"])

        output_header_info(song_data['song_file'], song_data['exclude_from_index'], song_data['title'], song_data['lyrics'], song_data['tags'], song_markdown_file)
        add_song_json(song_data)
