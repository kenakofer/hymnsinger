#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Set up indexes for each tag first
while read line; do
    for tag in $line; do
        TAGFILE="$SCRIPT_DIR/../docs/tags/$tag.md"
        echo "---" > $TAGFILE
        echo "title: Songs tagged $tag" >> $TAGFILE
        echo "layout: default" >> $TAGFILE
        echo "---" >> $TAGFILE
        echo "# Tag: $tag" >> $TAGFILE
        echo "<table><tr><th>Song</th><th>Lyrics</th><th>Tags</th></tr>" >> $TAGFILE
    done
done < "$SCRIPT_DIR/../docs/all_tags.txt"


# Set up the listing index
LISTFILE="docs/hymn-index.md"
echo "---" > $LISTFILE
echo "title: Hymn Host Index" >> $LISTFILE
echo "layout: default" >> $LISTFILE
echo "---" >> $LISTFILE
echo "# Complete Index" >> $LISTFILE
echo "<table><tr><th>Song</th><th>Lyrics</th><th>Tags</th></tr>" >> $LISTFILE


find lilypond/songs -type f -iname "*.ly" -print0 | sort -z | while IFS= read -r -d $'\0' file; do
    BASE=`basename "$file"`
    BASE="${BASE%%.*}"
    SPACE_BASE=`echo "$BASE" | sed 's/_/ /g'`

    DIR=`dirname "$file"`"/"
    INPUT='docs/song-template.md'
    OUTPUT="docs/listing/$BASE.md"


    # Make the hymn page
    echo "-->Generating $OUTPUT from $INPUT"
    cp $INPUT $OUTPUT
    # Replace all instances of REPLACE_WITH_FILENAME_BASE with the file's basename
    sed -i '' 's/REPLACE_WITH_FILENAME_BASE/'$BASE'/g' $OUTPUT
    # Replace all instances of [SPACE_NAME] with the file's spaced basename
    #sed -i -e 's/\[SPACE_NAME\]/'"$SPACE_BASE"'/g' $OUTPUT

    # Add to every relevant index
    $SCRIPT_DIR/generate_all_hymn_indexes.py $file
done
echo "</table>" >> $LISTFILE
