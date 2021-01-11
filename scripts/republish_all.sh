#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BASE_NAME=$1

# Create the outputs
$SCRIPT_DIR/generate_all_outputs.sh

# Update the hymn page and hymn index page
$SCRIPT_DIR/generate_all_hymn_pages.sh

# Commit the lilypond file and midi output and updated pages
git add "lilypond/songs/"
git add docs/local_lilypond_outputs/
git add docs/listing/
git add docs/hymn-index*
git add docs/tags

# Commit and push
git commit -m "Republish all songs"
git push

# Add the song outputs to the release
LATEST_RELEASE=`gh release list | head -n1 | awk '{print $1;}'`
gh release upload --clobber $LATEST_RELEASE "docs/local_lilypond_outputs/"*
