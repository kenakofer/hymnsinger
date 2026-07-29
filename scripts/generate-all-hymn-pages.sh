#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

find lilypond/songs -type f -iname "*.ly" -print0 | sort -z | while IFS= read -r -d $'\0' file; do
    # Skip files 
    if [[ "$file" == *-midi.ly ]] || [[ "$file" == *-print.ly ]] || [[ "$file" == *-slides.ly ]]; then
        continue
    fi

    BASE=`basename "$file"`
    BASE="${BASE%%.*}"

    OUTPUT="docs/listing/$BASE.md"

    # Make the hymn page
    echo "-->Generating $OUTPUT"

    # Add to every relevant index
    python3 $SCRIPT_DIR/generate-all-hymn-indexes.py $file $OUTPUT

    # Check the return status and conditionally exit with error
    if [ $? -ne 0 ]; then
        echo "Error generating hymn page for $file"
        exit 1
    fi
done
