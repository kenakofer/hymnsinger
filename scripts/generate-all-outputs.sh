#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

find ./lilypond/songs -type f -iname "*.ly" -print0 | sort -z | while IFS= read -r -d $'\0' file; do
    BASE=`basename "${file%.*}"` # This only strips the final ly, not any earlier "extension"
    OUTPUT_DIR="docs/local-lilypond-outputs/"
    INPUT=$file
    MIDI_OUTPUT="$OUTPUT_DIR$BASE.midi"
    MP3_OUTPUT="$OUTPUT_DIR$BASE.mp3"
    if [ -e "$MP3_OUTPUT" ] && [ "$MP3_OUTPUT" -nt "$INPUT" ] ; then
        echo "     ---- $BASE.mp3 exists and is up to date."
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
        for TYPE in -trad -clairnote -shapenote -lead; do
            if [ -e "$OUTPUT_DIR$BASE$TYPE-page3.png" ] ; then # 3 page case
                convert -append "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" "$OUTPUT_DIR$BASE$TYPE-page3.png" -strip "$OUTPUT_DIR$BASE$TYPE.png" &&
                rm "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" "$OUTPUT_DIR$BASE$TYPE-page3.png" ||
                echo "Failed to merge images for $BASE"
            else
                if [ -e "$OUTPUT_DIR$BASE$TYPE-page2.png" ] ; then # 2 page case
                    convert -append "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" -strip "$OUTPUT_DIR$BASE$TYPE.png" &&
                    rm "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" ||
                    echo "Failed to merge images for $BASE"
                fi
            fi
            mogrify -colorspace gray +dither -posterize 2 "$OUTPUT_DIR$BASE$TYPE*.png"
        done

        # We use 3 colors instead of 2 for slides since the image is smaller
        echo "     --> (Building ODP)"
        mogrify -colorspace gray +dither -posterize 3 "$OUTPUT_DIR$BASE-slides*.png"
        $SCRIPT_DIR/build-odp-presentation-from-images.sh "$BASE"


        echo "     --> (Midi to MP3)"
        # Timidity should be configured to use YDP Grand Piano soundfont, available for download at http://freepats.zenvoid.org/Piano/acoustic-grand-piano.html
        timidity --quiet --quiet $MIDI_OUTPUT -Ow -o - | ffmpeg -loglevel error -y -i - -acodec libmp3lame -ab 64k $MP3_OUTPUT

        echo "     --> Done."
    fi
done;
