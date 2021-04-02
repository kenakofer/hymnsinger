#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

find ./lilypond/songs -type f -iname "*.ly" -print0 | sort -z | while IFS= read -r -d $'\0' file; do
    BASE=`basename "${file%.*}"` # This only strips the final ly, not any earlier "extension"
    OUTPUT_DIR="docs/local_lilypond_outputs/"
    INPUT=$file
    MIDI_OUTPUT="$OUTPUT_DIR$BASE.midi"
    if [ -e "$MIDI_OUTPUT" ] && [ "$MIDI_OUTPUT" -nt "$INPUT" ] ; then
        echo "     ---- $BASE.midi exists and is up to date."
        #echo "     ---- We'll assume the other outputs are good as well."
    else
        echo
        echo "     --> Generating outputs for $BASE.ly"
        # Point and click bloats the file size, makes every note into a "link",
        # and the file size larger. We disable for the pdfs
        echo "     --> (PDF, MIDI)"
        lilypond -s -o $OUTPUT_DIR -dno-point-and-click $INPUT
        echo "     --> (PNG)"
        lilypond -s -o $OUTPUT_DIR -fpng -dresolution=400 $INPUT
        #echo "     --> (SVG)"
        #lilypond -s -o $OUTPUT_DIR -dno-point-and-click -dbackend=svg $INPUT

        # If it was a multi-page score, the images should be vertically joined
        echo "     --> (Optimizing PNGs)"
        for TYPE in -trad -clairnote -shapenote; do
            if [ -e "$OUTPUT_DIR$BASE$TYPE-page2.png" ] ; then
                convert -append "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" -strip "$OUTPUT_DIR$BASE$TYPE.png" &&
                rm "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" ||
                echo "Failed to merge images for $BASE"
            fi
            mogrify -colorspace gray +dither -posterize 2 "$OUTPUT_DIR$BASE$TYPE*.png"
        done

        # We use 3 colors instead of 2 for slides since the image is smaller
        echo "     --> (Building ODP)"
        mogrify -colorspace gray +dither -posterize 3 "$OUTPUT_DIR$BASE-slides*.png"

        $SCRIPT_DIR/build_odp_presentation_from_images.sh "$BASE"

        echo "     --> Done."
    fi
done;
