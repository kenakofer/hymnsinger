#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# How many songs to build at once. LilyPond is single-threaded, so the only
# way to use the other cores is to run several songs side by side. Override
# with JOBS=1 to get the old serial behaviour back when debugging a build.
JOBS="${JOBS:-$(nproc)}"

# Decide "up to date" by content, not by mtime.
#
# The old test was `mp3 -nt ly`, which broke every time you switched between
# main and public-main: git checkout rewrites the mtime of every file that
# differs between the branches, so the ~19 songs main has and public-main
# lacks looked newer than their assets and rebuilt on every republish. That
# is where the ~200-file diffs of identical-but-for-the-date PDFs came from.
#
# Fingerprint the .ly together with the files it \includes - lib/*.ily, and
# shared-tunes/*.ily for the 35 songs that borrow another song's tune - so
# editing a shared lib still invalidates every song that uses it. Hashing
# the .ly alone would be worse than rebuilding too often: it would serve
# stale output after a lib change.
song_fingerprint() {
    local ly="$1" dir; dir="$(dirname "$ly")"
    {
        cat "$ly"
        grep -oE '\\include "[^"]+"' "$ly" | sed 's/.*"\(.*\)"/\1/' | while read -r inc; do
            [ -f "$dir/$inc" ] && cat "$dir/$inc"
        done
    } | sha256sum | cut -d' ' -f1
}

build_song() {
    local file="$1"
    local BASE; BASE=$(basename "${file%.*}") # This only strips the final ly, not any earlier "extension"
    local OUTPUT_DIR="docs/local-lilypond-outputs/"
    local INPUT="$file"
    local MIDI_OUTPUT="$OUTPUT_DIR$BASE.midi"
    local MP3_OUTPUT="$OUTPUT_DIR$BASE.mp3"
    local STAMP="$OUTPUT_DIR$BASE.inputhash"
    local FINGERPRINT; FINGERPRINT="$(song_fingerprint "$INPUT")"

    if [ -e "$MP3_OUTPUT" ] && [ -e "$STAMP" ] \
       && [ "$(cat "$STAMP" 2>/dev/null)" = "$FINGERPRINT" ] ; then
        echo "     ---- $BASE.mp3 exists and is up to date."
        return 0
    fi

    echo "     --> Generating outputs for $BASE.ly"
    # One LilyPond run emits every format. It used to be two - one for
    # PDF+MIDI, one for PNG - which parsed the .ly and laid out all six
    # books twice over to produce the same pages in two rasterisations.
    # --formats does that work once and is very close to half the time.
    # Point and click bloats the file size, makes every note into a "link",
    # and the file size larger. We disable it for the pdfs.
    echo "     --> (PDF, MIDI, PNG)"
    # Adding svg here is how you'd get a third format without a third parse.
    lilypond -s -o "$OUTPUT_DIR" -dno-point-and-click \
        --formats=pdf,png -dresolution=400 "$INPUT"

    # If it was a multi-page score, the images should be vertically joined
    echo "     --> (Optimizing PNGs)"
    for TYPE in -trad -clairnote -shapenote -4shapenote -lead; do
        if [ -e "$OUTPUT_DIR$BASE$TYPE-page3.png" ] ; then # 3 page case
            convert -append "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" "$OUTPUT_DIR$BASE$TYPE-page3.png" -strip "$OUTPUT_DIR$BASE$TYPE.png" &&
            rm "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" "$OUTPUT_DIR$BASE$TYPE-page3.png" ||
            echo "Failed to merge images for $BASE"
        else
            if [ -e "$OUTPUT_DIR$BASE$TYPE-page2.png" ] ; then # 2 page case
                convert -append "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" -strip "$OUTPUT_DIR$BASE$TYPE.png" &&
                rm "$OUTPUT_DIR$BASE$TYPE-page1.png" "$OUTPUT_DIR$BASE$TYPE-page2.png" ||
                echo "Failed to merge images for $BASE"
            fi
        fi
        mogrify -colorspace gray +dither -posterize 2 "$OUTPUT_DIR$BASE$TYPE*.png"
    done

    # We use 3 colors instead of 2 for slides since the image is smaller
    echo "     --> (Building ODP)"
    mogrify -colorspace gray +dither -posterize 3 "$OUTPUT_DIR$BASE-slides*.png"
    "$SCRIPT_DIR/build-odp-presentation-from-images.sh" "$BASE"

    echo "     --> (Midi to MP3)"
    # Timidity should be configured to use YDP Grand Piano soundfont, available for download at http://freepats.zenvoid.org/Piano/acoustic-grand-piano.html
    timidity --quiet --quiet "$MIDI_OUTPUT" -Ow -o - | ffmpeg -loglevel error -y -i - -acodec libmp3lame -ab 64k "$MP3_OUTPUT"

    # Record the fingerprint only once the outputs exist, so a build that
    # died partway is not cached as good and gets retried next run.
    if [ -s "$MP3_OUTPUT" ]; then
        printf '%s\n' "$FINGERPRINT" > "$STAMP"
    else
        echo "     --> WARNING: no mp3 produced for $BASE; not caching"
        rm -f "$STAMP"
    fi

    echo "     --> Done."
}
export -f build_song song_fingerprint
export SCRIPT_DIR

# Songs are independent - each writes only files named after itself - so they
# parallelise cleanly. The per-song output is buffered by xargs into whole
# lines, so progress from concurrent builds stays readable.
find ./lilypond/songs -type f -iname "*.ly" -print0 | sort -z |
    xargs -0 -P "$JOBS" -I{} bash -c 'build_song "$@"' _ {}
