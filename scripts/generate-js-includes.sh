#!/bin/bash

echo "define([], function() {"
echo "  return {"


find lilypond/lib -type f -iname "*.ly" -print0 | sort -z | while IFS= read -r -d $'\0' file; do
    BASE=`basename "$file"`
    BASE="${BASE%%.*}"

    echo "\"$BASE\": \`"
    cat $file | sed -e 's/\\/\\\\/g' | sed -e 's/`/\\`/g'
    echo "\`,"
done
echo "}});"
