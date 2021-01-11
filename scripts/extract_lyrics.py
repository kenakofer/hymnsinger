#!/usr/bin/env python3
import sys

def output_lyrics(all_lines):
    current_verse = None
    chorus_mode = False
    remove_quotes = False
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
            print()
        elif line.startswith('%% END CHORUS'):
            chorus_mode = False
            print()
        elif current_verse and line.strip().startswith("}"):
            current_verse = None
            chorus_mode = False
            print()
        elif current_verse:
            prefix = "  " if chorus_mode else "" 
            print(prefix + join_verse_line(line, remove_quotes))

def join_verse_line(line, remove_quotes):
    stripped = line.strip()
    if remove_quotes:
        stripped = stripped[1:-1].replace('\\"','"')
    words = stripped.replace("_","").split()
    while "--" in words:
        index = words.index("--")
        words[index-1:index+2] = [words[index-1] + words[index+1]]
    return " ".join(words)


if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        output_lyrics(
            f.readlines()
        )
