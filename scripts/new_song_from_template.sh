#!/bin/bash

INPUT="lilypond/hymn_template/hymn_template.ly"
NEW_BASE=$1
OUTPUT="lilypond/songs/$NEW_BASE/$NEW_BASE.ly"
DATE=$(date '+%Y-%m-%d')
mkdir "lilypond/songs/$NEW_BASE"
cp $INPUT $OUTPUT && sed -i '' 's/%YYYY-MM-DD%/"'$DATE'"/g' $OUTPUT
