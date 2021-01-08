#!/usr/bin/env python3
import sys

def output_lyrics(all_lines):
    current_verse = None
    chorus_mode = False
    for i, line in enumerate(all_lines):
        line = line.strip()
        if line.startswith("verse") and not line.endswith("}"):
            current_verse = line[5]
        elif line.startswith('%% CHORUS'):
            chorus_mode = True
            print()
        elif line.startswith('%% END CHORUS'):
            chorus_mode = False
            print()
        elif current_verse and line.startswith("}"):
            current_verse = None
            chorus_mode = False
            print()
        elif current_verse:
            prefix = "  " if chorus_mode else "" 
            print(prefix + join_verse_line(line))

def join_verse_line(line):
    words = line.strip().replace("_","").split()
    while "--" in words:
        index = words.index("--")
        words[index-1:index+2] = [words[index-1] + words[index+1]]
    return " ".join(words)


if __name__ == "__main__":
    with open(sys.argv[1], 'r') as f:
        output_lyrics(
            f.readlines()
        )
