#!/bin/bash

echo "Are you sure you would like to delete all *.pdf, *.midi, *.png, *.mp3, *.odp recursively"
echo "in the current directory `pwd` ?"
read -r -p "[y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "Clearing out files..."
        find . -type f -name '*.pdf' -exec rm {} +
        find . -type f -name '*.midi' -exec rm {} +
        find . -type f -name '*.png' -exec rm {} +
        find . -type f -name '*.mp3' -exec rm {} +
        find . -type f -name '*.odp' -exec rm {} +
        echo "Done."
        ;;
    *)
        echo "Aborting..."
        exit 1
        ;;
esac
