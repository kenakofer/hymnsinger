#!/bin/bash

INPUT="lilypond/hymn_template/hymn_template.ly"
NEW_BASE=$1
OUTPUT="lilypond/songs/$NEW_BASE/$NEW_BASE.ly"
mkdir "lilypond/songs/$NEW_BASE"
cp $INPUT "$OUTPUT"
vim $OUTPUT
