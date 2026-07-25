#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_NAME=$1

# Create the outputs
$SCRIPT_DIR/generate-all-outputs.sh

# Update the hymn page and hymn index page
$SCRIPT_DIR/generate-all-hymn-pages.sh

# Commit the lilypond file and midi output and updated pages
git add "lilypond/songs/$BASE_NAME"
git add docs/local-lilypond-outputs/$BASE_NAME*
git add docs/listing/$BASE_NAME*
git add docs/hymn-index*
git add docs/_data*

# Commit and push
git commit -e -m "Add new song \"$BASE_NAME\""
git push
