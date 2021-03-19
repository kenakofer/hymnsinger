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
        echo "{% include data_table.html %}" >> $TAGFILE
        echo "# Tag: $tag" >> $TAGFILE
        echo "<table id='song-table' cellspacing='0' width='100%'><thead><th>Song</th><th>Tune</th><th>Meter</th><th>Lyrics</th><th>Tags</th></thead>" >> $TAGFILE
    done
done < "$SCRIPT_DIR/../docs/all_tags.txt"


# Set up the listing index
LISTFILE="docs/hymn-index.md"
echo "---" > $LISTFILE
echo "title: Complete Index" >> $LISTFILE
echo "description: An list of every hymn song music resource on the site" >> $LISTFILE
echo "layout: default" >> $LISTFILE
echo "---" >> $LISTFILE
echo "{% include data_table.html %}" >> $LISTFILE
echo "# Complete Index" >> $LISTFILE
echo "<table id='song-table' cellspacing='0' width='100%'><thead><th>Song</th><th>Tune</th><th>Meter</th><th>Lyrics</th><th>Tags</th></thead>" >> $LISTFILE


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

    # Add to every relevant index
    $SCRIPT_DIR/generate_all_hymn_indexes.py $file
done
echo "</table>" >> $LISTFILE
