#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

find lilypond/songs -type f -iname "*.ly" -print0 | sort -z | while IFS= read -r -d $'\0' file; do
    BASE=`basename "$file"`
    BASE="${BASE%%.*}"

    INPUT='docs/song-template.md'
    OUTPUT="docs/listing/$BASE.md"

    # Make the hymn page
    echo "-->Generating $OUTPUT from $INPUT"
    cp $INPUT $OUTPUT

    # Add to every relevant index
    $SCRIPT_DIR/generate_all_hymn_indexes.py $file
done
