#!/bin/bash

# Set up the listing index first

LISTFILE="docs/hymn-index.md"
echo "---" > $LISTFILE
echo "title: Hymn Host Index" >> $LISTFILE
echo "layout: default" >> $LISTFILE
echo "---" >> $LISTFILE


find lilypond/songs -type f -iname "*.ly" -print0 | while IFS= read -r -d $'\0' file; do
    BASE=`basename "$file"`
    BASE="${BASE%%.*}"
    SPACE_BASE=`echo "$BASE" | sed 's/_/ /g'`

    DIR=`dirname "$file"`"/"
    INPUT='docs/song-template.md'
    OUTPUT="docs/listing/$BASE.md"


    echo "-->Generating $OUTPUT from $INPUT"
    cp $INPUT $OUTPUT
    # Replace all instances of REPLACE_WITH_FILENAME_BASE with the file's basename
    sed -i '' 's/REPLACE_WITH_FILENAME_BASE/'$BASE'/g' $OUTPUT
    # Replace all instances of [SPACE_NAME] with the file's spaced basename
    #sed -i -e 's/\[SPACE_NAME\]/'"$SPACE_BASE"'/g' $OUTPUT

    # Add to hymn index
    echo " - [$SPACE_BASE](listing/$BASE.html)" >> $LISTFILE
done
