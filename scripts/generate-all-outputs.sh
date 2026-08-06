#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# How many songs to build at once. LilyPond is single-threaded, so the only
# way to use the other cores is to run several songs side by side. Override
# with JOBS=1 to get the old serial behaviour back when debugging a build.
JOBS="${JOBS:-$(nproc)}"

# Optional: rebuild only some notation books, and/or only some songs. Both are
# empty by default, which means "everything", exactly as before.
#
#   BOOKS=transposed ./scripts/generate-all-outputs.sh
#   BOOKS=trad,lead SONGS='abide-with-me come-o-thou-traveller' ...
#   SONGS="$(grep -rl 'minor' lilypond/songs --include='*.ly' | ...)"
#
# The point is that a change is usually confined to a few books: the minor-key
# spelling fix altered only the four transposed books of the 12 minor and modal
# songs, but rebuilding it the blunt way re-engraves 9 books x 150 songs.
#
# A partial run deliberately does NOT write the .inputhash stamp - see the end
# of build_song. The stamp means "every output for this song is current", and
# after building 4 of 9 books that is false. Leaving it unwritten means the
# next full run rebuilds the song and puts it right.
BOOKS="${BOOKS:-}"
SONGS="${SONGS:-}"

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

# Every output suffix a full run can produce. Single source of truth for the
# post-processing loops - it used to be spelled out twice and the two copies
# had to be edited together.
#
# The -uke* books only exist for songs that define chords, so these globs are
# expected to miss for most songs; every consumer below is guarded by [ -e ].
ALL_TYPES="-trad -clairnote -shapenote -4shapenote -lead -trad-up1 -trad-up2 -trad-dn1 -trad-dn2 -uke -uke-up1 -uke-up2 -uke-dn1 -uke-dn2"

# Map a BOOKS selection onto the output suffixes the post-processing steps
# walk. Must stay in step with ht-book? in lib/all-notation-outputs.ily.
books_to_types() {
    local sel="$1" out="" b
    for b in ${sel//,/ }; do
        case "$b" in
            all) out="$ALL_TYPES"; break ;;
            transposed) out="$out -trad-up1 -trad-up2 -trad-dn1 -trad-dn2 -uke-up1 -uke-up2 -uke-dn1 -uke-dn2" ;;
            # "uke" means the whole family, matching ht-book? in the .ily.
            uke) out="$out -uke -uke-up1 -uke-up2 -uke-dn1 -uke-dn2" ;;
            *) out="$out -${b}" ;;
        esac
    done
    echo "$out"
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

    # A partial build has no valid "up to date" answer: the stamp covers the
    # whole song, so it cannot say "the trad book is current but clairnote is
    # not". Skip the cache check entirely and always rebuild the named books.
    if [ -z "$BOOKS" ] && [ -e "$MP3_OUTPUT" ] && [ -e "$STAMP" ] \
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
    local BOOKOPT=()
    [ -n "$BOOKS" ] && BOOKOPT=(-dht-books="$BOOKS")
    lilypond -s -o "$OUTPUT_DIR" -dno-point-and-click \
        "${BOOKOPT[@]}" --formats=pdf,png -dresolution=400 "$INPUT"

    # If it was a multi-page score, the images should be vertically joined
    echo "     --> (Optimizing PNGs)"
    # Only walk the books this run actually emitted. Walking all nine looks
    # harmless because of the [ -e ] guards below, but it is not: a skipped
    # book's .png is still on disk from an earlier build, so the guard passes
    # and mogrify rewrites a file this run never regenerated. That silently
    # dirtied 5 books x 14 songs on the first partial run.
    local TYPES
    if [ -n "$BOOKS" ]; then
        TYPES=$(books_to_types "$BOOKS")
    else
        TYPES="$ALL_TYPES"
    fi
    for TYPE in $TYPES; do
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
        # Posterize this variant's own files only, and let the shell do the
        # globbing. Two traps here:
        #   - "$BASE$TYPE*.png" (the old pattern) matches -trad-up1 and friends
        #     under -trad, so each transposed png got posterized several times.
        #     Harmless - posterize is idempotent - but wasted work.
        #   - a "*" that reaches mogrify unmatched is expanded by ImageMagick
        #     itself, and it hangs on a literal non-matching pattern rather
        #     than erroring out. Never pass it one.
        # The -page files are anything a 4+ page score left unmerged above.
        for png in "$OUTPUT_DIR$BASE$TYPE.png" "$OUTPUT_DIR$BASE$TYPE"-page[0-9]*.png; do
            [ -e "$png" ] && mogrify -colorspace gray +dither -posterize 2 "$png"
        done
    done

    # Slides and MIDI are included directly by each song, not through
    # all-notation-outputs.ily, so -dht-books cannot suppress them - LilyPond
    # re-emits them on every run whatever the selection. Gating them properly
    # would mean touching the \include line in all 150 song files.
    #
    # They are cheap (slides is one small book, MIDI is not engraved at all),
    # so a partial run just lets them regenerate and then puts the files back
    # the way they were. Skipping the ODP and MP3 steps below is what actually
    # saves the time; this only stops the rebuilt-but-unchanged slides from
    # showing up as noise in git status.
    if [ -n "$BOOKS" ]; then
        # The intermediate page PNGs are always disposable - a full run merges
        # and deletes them anyway.
        rm -f "$OUTPUT_DIR$BASE"-slides-page[0-9]*.png
        # Restore the committed slides PDF if it is tracked and unchanged in
        # content. Without this a partial run shows 150 modified slides files
        # that differ only by rebuild metadata.
        git checkout -q -- "$OUTPUT_DIR$BASE-slides.pdf" 2>/dev/null || true
    fi

    if [ -z "$BOOKS" ]; then
        # We use 3 colors instead of 2 for slides since the image is smaller.
        # Shell-glob and guard, same reason as the loop above: a "*" that
        # reaches mogrify unmatched hangs rather than erroring.
        echo "     --> (Building ODP)"
        for png in "$OUTPUT_DIR$BASE"-slides*.png; do
            [ -e "$png" ] && mogrify -colorspace gray +dither -posterize 3 "$png"
        done
        "$SCRIPT_DIR/build-odp-presentation-from-images.sh" "$BASE"

        echo "     --> (Midi to MP3)"
        # Timidity should be configured to use YDP Grand Piano soundfont, available for download at http://freepats.zenvoid.org/Piano/acoustic-grand-piano.html
        timidity --quiet --quiet "$MIDI_OUTPUT" -Ow -o - | ffmpeg -loglevel error -y -i - -acodec libmp3lame -ab 64k "$MP3_OUTPUT"
    fi

    if [ -n "$BOOKS" ]; then
        # Partial build: the stamp asserts every output for this song is
        # current, which is not true after rebuilding a subset. Clear it so the
        # next full run redoes this song rather than trusting a stale hash.
        rm -f "$STAMP"
        echo "     --> Done (partial: $BOOKS; stamp cleared)."
        return 0
    fi

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
export -f build_song song_fingerprint books_to_types
export SCRIPT_DIR BOOKS ALL_TYPES

# Which songs to build. SONGS is a whitespace-separated list of slugs; empty
# means all of them.
song_list() {
    if [ -z "$SONGS" ]; then
        find ./lilypond/songs -type f -iname "*.ly" -print0 | sort -z
        return
    fi
    local missing=0 s path
    for s in $SONGS; do
        path="./lilypond/songs/$s/$s.ly"
        if [ -f "$path" ]; then
            printf '%s\0' "$path"
        else
            echo "     --> WARNING: no such song: $s" >&2
            missing=1
        fi
    done
    # A typo in SONGS would otherwise look like a fast, successful build.
    [ "$missing" = 1 ] && echo "     --> (some songs in SONGS were not found)" >&2
    return 0
}

if [ -n "$BOOKS" ] || [ -n "$SONGS" ]; then
    echo "==> Partial build: books=${BOOKS:-all} songs=${SONGS:-all}"
fi

# Songs are independent - each writes only files named after itself - so they
# parallelise cleanly. The per-song output is buffered by xargs into whole
# lines, so progress from concurrent builds stays readable.
song_list | xargs -0 -P "$JOBS" -I{} bash -c 'build_song "$@"' _ {}
