#!/bin/bash

INPUT="lilypond/hymn_template/hymn_template.ly"
NEW_BASE=$1
mkdir -p "lilypond/songs/$NEW_BASE"
OUTPUT="lilypond/songs/$NEW_BASE/$NEW_BASE.ly"
DATE=$(date '+%Y-%m-%d')
cat $INPUT | sed 's/%YYYY-MM-DD%/"'$DATE'"/g' > $OUTPUT
