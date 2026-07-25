#!/bin/bash
# Regenerate every song's outputs and pages, then commit them.
#
# This branch is the public one: everything here is public domain and gets
# pushed to the public remote. Songs arrive via `song-intake.sh publish
# --public` on the private branch, which commits the .ly and nothing else,
# so a song has no page on the site until this runs.
set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO="$( cd "$SCRIPT_DIR/.." && pwd )"
cd "$REPO" || exit 1

# generate-all-outputs.sh writes to docs/local-lilypond-outputs/ on this
# branch and docs/_site/local-lilypond-outputs/ on main - the two branches
# carry opposite docs/ layouts. Stage whichever this branch actually has, so
# the script does not silently generate everything and then stage none of it.
OUTPUTS=""
for d in docs/_site/local-lilypond-outputs docs/local-lilypond-outputs; do
    [ -d "$d" ] && OUTPUTS="$OUTPUTS $d"
done
if [ -z "$OUTPUTS" ]; then
    echo "error: no local-lilypond-outputs directory found under docs/" >&2
    exit 1
fi

# Create the outputs
"$SCRIPT_DIR/generate-all-outputs.sh" || exit 1

# Update the hymn page and hymn index page
"$SCRIPT_DIR/generate-all-hymn-pages.sh" || exit 1

# Commit the lilypond file and midi output and updated pages
git add "lilypond/songs/"
# shellcheck disable=SC2086
git add $OUTPUTS
git add docs/listing/
git add docs/hymn-index*
git add docs/_data*

if git diff --cached --quiet; then
    echo "nothing to commit - outputs and pages are already up to date"
    exit 0
fi

echo
echo "staged $(git diff --cached --name-only | wc -l) file(s) in:$OUTPUTS docs/listing docs/_data"
echo

# Commit only. Pushing is left to you: this script also exists on main, and
# a bare `git push` from the wrong branch is how private songs reach a
# public remote. Review, then push the branch you meant.
git commit -e -m "Republish all songs" || exit 1

echo
echo "not pushed - review, then push the branch you are on:"
echo "  git push public-origin public-main:main  (public, this branch)"
echo "  git push origin main                     (private)"
