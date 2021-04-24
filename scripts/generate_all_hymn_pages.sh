#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

find lilypond/songs -type f -iname "*.ly" -print0 | sort -z | while IFS= read -r -d $'\0' file; do
    BASE=`basename "$file"`
    echo "-->Generating JSON from $BASE"
    $SCRIPT_DIR/generate_all_hymn_indexes.py $file
done
