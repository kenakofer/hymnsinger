#!/bin/bash
# I'm not sure why the PDFs output are so large, but it may be the biolinum
# font is packaged in there

find ./lilypond/songs -type f -iname "*.ly" -print0 | while IFS= read -r -d $'\0' file; do
    BASE=`basename "${file%.*}"` # This only strips the final ly, not any earlier "extension"
    OUTPUT_DIR="outputs/"
    INPUT=$file
    MIDI_OUTPUT="$OUTPUT_DIR$BASE.midi"
    if [ -e "$MIDI_OUTPUT" ] && [ "$MIDI_OUTPUT" -nt "$INPUT" ] ; then
        echo "     ---- $BASE.midi exists and is up to date."
        #echo "     ---- We'll assume the other outputs are good as well."
    else
        echo
        echo "     -->"
        echo "     --> Generating outputs (*.pdf, *.midi, *.png) for "
        echo "     --> $BASE.ly"
        echo "     -->"
        lilypond -s -o $OUTPUT_DIR $INPUT
        lilypond -s -o $OUTPUT_DIR -fpng -dresolution=150 $INPUT
    fi
done;
