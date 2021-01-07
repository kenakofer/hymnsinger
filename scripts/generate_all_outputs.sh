#!/bin/bash
# I'm not sure why the PDFs output are so large, but it may be the biolinum
# font is packaged in there

find ./lilypond/songs -type f -iname "*.ly" -print0 | while IFS= read -r -d $'\0' file; do
    BASE=`basename "${file%.*}"` # This only strips the final ly, not any earlier "extension"
    OUTPUT_DIR="docs/local_lilypond_outputs/"
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
        # Point and click bloats the file size, makes every note into a "link",
        # and the file size larger. We disable for the pdfs
        lilypond -s -o $OUTPUT_DIR -dno-point-and-click $INPUT 
        lilypond -s -o $OUTPUT_DIR -fpng -dresolution=150 $INPUT
    fi
done;
