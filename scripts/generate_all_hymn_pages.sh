#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Set up the listing index first

LISTFILE="docs/hymn-index.md"
echo "---" > $LISTFILE
echo "title: Hymn Host Index" >> $LISTFILE
echo "layout: default" >> $LISTFILE
echo "---" >> $LISTFILE
echo "<table><tr><th>Song</th><th>Lyrics</th><th>Tags</th></tr>" >> $LISTFILE


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
    echo "<tr><td class='hymn-name-box'><a href=\"listing/$BASE.html\">" >> $LISTFILE
    echo $SPACE_BASE | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1' >> $LISTFILE # Uppercase first letter
    echo "</a></td>" >> $LISTFILE
    echo -n "<td class='lyric-box'>" >> $LISTFILE
    # Output lyrics
    $SCRIPT_DIR/extract_lyrics.py $file >> $LISTFILE
    echo -n "</td>" >> $LISTFILE
    echo "<td>" >> $LISTFILE
    $SCRIPT_DIR/extract_tag_html.py $file >> $LISTFILE
    echo "</td></tr>" >> $LISTFILE
done
echo "</table>" >> $LISTFILE
