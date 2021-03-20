#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Set up the listing index
LISTFILE="docs/hymn-index.md"
cat << EOF > $LISTFILE
---
title: Complete Index
description: An list of every hymn song music resource on the site
layout: default
---

{% include data_table.html %}

# Complete Index

<div id='toggle-vis-panel'>
Toggle:
<a class="toggle-vis" data-column="0" href="#">Song</a> |
<a class="toggle-vis" data-column="1" href="#">Tune</a> |
<a class="toggle-vis off" data-column="2" href="#">Meter</a> |
<a class="toggle-vis off" data-column="3" href="#">Composer</a> |
<a class="toggle-vis" data-column="4" href="#">Stanzas</a> |
<a class="toggle-vis off" data-column="5" href="#">#</a> |
<a class="toggle-vis" data-column="6" href="#">Tags</a> |
<a class="toggle-vis" data-column="7" href="#">Added</a>
</div>

<table id='song-table' cellspacing='0' width='100%'><thead>
<th>Song</th>
<th>Tune</th>
<th>Meter</th>
<th>Composer</th>
<th>Stanzas</th>
<th>#</th>
<th>Tags</th>
<th>Added</th>
</thead>
EOF


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
