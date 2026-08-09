#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Make the build killable as one thing.
#
# The work runs under `xargs -P`, which is a child of this script's pipeline
# rather than a job of the shell. Kill this script alone and xargs is
# reparented to init and carries on feeding new songs - and it does not match
# `pkill -f generate-all-outputs.sh`, because that string is not in its command
# line. Every worker you then kill is simply replaced. Twice now that has meant
# a build that could not be stopped without hunting the orphan down by hand.
#
# Killing the whole process group fixes it, since xargs and every lilypond,
# mogrify and convert it spawns are all in this script's group. Running in our
# own group (setsid, only when we are not already a leader) keeps that signal
# off the caller's terminal and other jobs.
if [ -z "${HT_BUILD_GROUP:-}" ] && command -v setsid >/dev/null 2>&1; then
    if [ "$(ps -o pgid= -p $$ | tr -d ' ')" != "$$" ]; then
        export HT_BUILD_GROUP=1
        exec setsid "$0" "$@"
    fi
fi
ht_cleanup() {
    trap - INT TERM EXIT
    # Negative pid = the whole process group. Ignore it ourselves first, or
    # this shell dies before it can send it.
    trap '' TERM
    kill -TERM -$$ 2>/dev/null
    sleep 2
    kill -KILL -$$ 2>/dev/null
}
trap ht_cleanup INT TERM

# How many songs to build at once. LilyPond is single-threaded, so the only
# way to use the other cores is to run several songs side by side.
#
# Not nproc, though that is what this used to be. The repo lives on a FUSE
# NTFS mount, and each book writes a multi-megabyte PNG and a PDF through a
# single mount.ntfs daemon; at nproc the writes queue behind the kernel flush
# path and the whole thing collapses - measured: load average 38 on 8 cores
# with mount.ntfs itself at 0.3% CPU, a dozen processes stuck in uninterruptible
# D state, and forward progress of one song per eight minutes.
#
# 2 is measured, not guessed. Same four songs, cold, on this mount:
#
#   JOBS=1   158s   39.5s/song
#   JOBS=2   108s   27.0s/song   <- best
#   JOBS=4   123s   30.8s/song
#
# So the curve turns over almost immediately: one job leaves the CPU idle
# waiting on IO, four already spend more time queueing than they save. Raise it
# with JOBS= on a normal filesystem, where this ceiling does not apply, or
# JOBS=1 to serialise when debugging a build.
JOBS="${JOBS:-2}"

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
# The fret books (-uke*, -guitar*) and -roman only exist for songs that define
# chords, so these globs are expected to miss for most songs; every consumer
# below is guarded by [ -e ].
#
# -roman has no transposed siblings on purpose: a Roman numeral is relative to
# the tonic, so every transposition would engrave the same page.
ALL_TYPES="-trad -clairnote -shapenote -4shapenote -lead -trad-up1 -trad-up2 -trad-dn1 -trad-dn2 -lead-up1 -lead-up2 -lead-dn1 -lead-dn2 -uke -uke-up1 -uke-up2 -uke-dn1 -uke-dn2 -guitar -guitar-up1 -guitar-up2 -guitar-dn1 -guitar-dn2 -roman"

# Map a BOOKS selection onto the output suffixes the post-processing steps
# walk. Must stay in step with ht-book? in lib/all-notation-outputs.ily.
books_to_types() {
    local sel="$1" out="" b
    for b in ${sel//,/ }; do
        case "$b" in
            all) out="$ALL_TYPES"; break ;;
            transposed) out="$out -trad-up1 -trad-up2 -trad-dn1 -trad-dn2 -lead-up1 -lead-up2 -lead-dn1 -lead-dn2 -uke-up1 -uke-up2 -uke-dn1 -uke-dn2 -guitar-up1 -guitar-up2 -guitar-dn1 -guitar-dn2" ;;
            # A chord book's name means its whole family, matching ht-book?
            # in the .ily.
            lead) out="$out -lead -lead-up1 -lead-up2 -lead-dn1 -lead-dn2" ;;
            uke) out="$out -uke -uke-up1 -uke-up2 -uke-dn1 -uke-dn2" ;;
            guitar) out="$out -guitar -guitar-up1 -guitar-up2 -guitar-dn1 -guitar-dn2" ;;
            *) out="$out -${b}" ;;
        esac
    done
    echo "$out"
}

# Join a book's per-page PNGs into the single tall image the song page shows,
# and delete the parts. Takes the output prefix, e.g. ".../abide-with-me-trad"
# or ".../abide-with-me-slides"; a single-page book has no -page files and is
# left alone, having been written straight to $prefix.png already.
#
# This used to be an if/else ladder spelling out the 2- and 3-page cases by
# hand, which meant a 4-page score merged into nothing at all: the pages were
# left on disk, $prefix.png was never written, and the song page requested an
# image that did not exist. The longest score in the corpus is 3 pages, so that
# was one system break away from shipping. The slide decks reach nine pages
# routinely, which is what forced the general version.
#
# -v so page10 sorts after page9 rather than between page1 and page2.
merge_page_pngs() {
    local prefix="$1"
    local pages=()
    while IFS= read -r png; do
        [ -e "$png" ] && pages+=("$png")
    done < <(ls -v "$prefix"-page[0-9]*.png 2>/dev/null)
    [ ${#pages[@]} -eq 0 ] && return 0
    # -strip: see the posterize loop's note on ImageMagick's timestamp chunks.
    if convert -append "${pages[@]}" -strip "$prefix.png"; then
        rm -f "${pages[@]}"
    else
        echo "Failed to merge images for $(basename "$prefix")"
    fi
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
    # Adding svg here does NOT work, despite reading like it should: the SVG
    # backend cannot share a run with the PDF one, and --formats=pdf,png,svg
    # silently emits no SVG at all rather than erroring.
    local BOOKOPT=()
    [ -n "$BOOKS" ] && BOOKOPT=(-dht-books="$BOOKS")
    # Where the key signature and final bar line land in each book, for the
    # song page to hang the transpose arrows and (later) autoscroll on. Written
    # by lib/keysig-position.ily during this same run - it reads numbers the
    # layout has already computed, and costs well under 1%. Per-song file
    # because songs build in parallel.
    local LANDMARKS; LANDMARKS="$(mktemp -t "ht-landmarks-$BASE.XXXXXX")"
    lilypond -s -o "$OUTPUT_DIR" -dno-point-and-click \
        "${BOOKOPT[@]}" -dht-landmarks="$LANDMARKS" \
        --formats=pdf,png -dresolution=400 "$INPUT"

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
        merge_page_pngs "$OUTPUT_DIR$BASE$TYPE"
        # Posterize this variant's own files only, and let the shell do the
        # globbing. Two traps here:
        #   - "$BASE$TYPE*.png" (the old pattern) matches -trad-up1 and friends
        #     under -trad, so each transposed png got posterized several times.
        #     Harmless - posterize is idempotent - but wasted work.
        #   - a "*" that reaches mogrify unmatched is expanded by ImageMagick
        #     itself, and it hangs on a literal non-matching pattern rather
        #     than erroring out. Never pass it one.
        # -strip because this rewrite is what otherwise makes every rebuild
        # dirty every PNG. ImageMagick stamps tIME and date:create/date:modify
        # chunks on write, so a song whose engraving has not changed by a
        # single pixel still comes out as a modified file - 707 of them on one
        # run here, all bit-identical in image data, differing in 30 bytes of
        # timestamp. merge_page_pngs already strips during its `convert
        # -append`; single-page songs never passed through one, which is why
        # they were the ones churning.
        #
        # The -page glob is a belt-and-braces sweep: merge_page_pngs deletes
        # every page it merges, so it should no longer match anything.
        for png in "$OUTPUT_DIR$BASE$TYPE.png" "$OUTPUT_DIR$BASE$TYPE"-page[0-9]*.png; do
            [ -e "$png" ] && mogrify -strip -colorspace gray +dither -posterize 2 "$png"
        done

        # Same problem in the PDFs, four fields of it, and no build flag that
        # turns it off - see normalize-pdf-metadata.py. Inside this loop rather
        # than a glob over the song, so a partial run leaves the books it did
        # not rebuild alone, exactly like the PNG walk above.
        [ -e "$OUTPUT_DIR$BASE$TYPE.pdf" ] &&
            python3 "$SCRIPT_DIR/normalize-pdf-metadata.py" "$OUTPUT_DIR$BASE$TYPE.pdf"
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
    # The slides book is not in ALL_TYPES, so the per-book loop above did not
    # reach its PDF. Normalise it here instead, on every run: it is re-emitted
    # whatever -dht-books says, so a partial build would otherwise still leave
    # one dirty file per song.
    [ -e "$OUTPUT_DIR$BASE-slides.pdf" ] &&
        python3 "$SCRIPT_DIR/normalize-pdf-metadata.py" "$OUTPUT_DIR$BASE-slides.pdf"

    # The slide deck as one tall image, for the song page's Slideshow tab. This
    # has to run here, before either branch below: the ODP builder *moves* the
    # page PNGs into its zip and a partial build deletes them outright, so by
    # the time we know which of those happened there is nothing left to stitch.
    #
    # Posterized to 3 like the ODP's copies rather than 2 like the sheet-music
    # PNGs - a slide is a much smaller image blown up to fill a screen, and two
    # levels visibly stair-step the stems. Done here rather than reusing the
    # ODP's own pass so the stitch sees the same pixels the deck ships.
    echo "     --> (Stitching slides PNG)"
    for png in "$OUTPUT_DIR$BASE"-slides-page[0-9]*.png; do
        [ -e "$png" ] && mogrify -strip -colorspace gray +dither -posterize 3 "$png"
    done
    # Not merge_page_pngs: that deletes the pages it merges, and the ODP
    # builder below still needs them - it moves each one into the deck's
    # Pictures. Same -v ordering and -strip, but the parts are left in place.
    local SLIDE_PAGES=()
    while IFS= read -r png; do
        [ -e "$png" ] && SLIDE_PAGES+=("$png")
    done < <(ls -v "$OUTPUT_DIR$BASE"-slides-page[0-9]*.png 2>/dev/null)
    if [ ${#SLIDE_PAGES[@]} -gt 0 ]; then
        convert -append "${SLIDE_PAGES[@]}" -strip "$OUTPUT_DIR$BASE-slides.png" ||
            echo "Failed to stitch slides image for $BASE"
    fi

    if [ -n "$BOOKS" ]; then
        # The intermediate page PNGs are always disposable - a full run merges
        # and deletes them anyway.
        rm -f "$OUTPUT_DIR$BASE"-slides-page[0-9]*.png
        # The slides PDF used to be restored from git here, because a rebuild
        # produced a byte-different file from identical music. Normalising it
        # above fixes that at the source, so an unchanged song now rebuilds to
        # an unchanged file and there is nothing to put back.
    fi

    if [ -z "$BOOKS" ]; then
        echo "     --> (Building ODP)"
        # The posterize pass that used to live here has moved up to the stitch
        # step, which runs on every build and leaves the pages in place; the
        # deck takes those same files. It also narrowed the glob from -slides*
        # to -slides-page[0-9]*, which now matters: the old pattern would also
        # match the stitched -slides.png, and rewriting that on every build is
        # exactly the timestamp churn -strip was added to stop.
        "$SCRIPT_DIR/build-odp-presentation-from-images.sh" "$BASE"

        echo "     --> (Midi to MP3)"
        # Timidity should be configured to use YDP Grand Piano soundfont, available for download at http://freepats.zenvoid.org/Piano/acoustic-grand-piano.html
        timidity --quiet --quiet "$MIDI_OUTPUT" -Ow -o - | ffmpeg -loglevel error -y -i - -acodec libmp3lame -ab 64k "$MP3_OUTPUT"
    fi

    # Fold this run's landmark positions into the song's page data. Safe on a
    # partial build too: the merge is per book, so rebuilding two books updates
    # those two entries and leaves the rest of the song's alone.
    if [ -s "$LANDMARKS" ]; then
        echo "     --> (Landmarks)"
        local PARTIALOPT=()
        [ -n "$BOOKS" ] && PARTIALOPT=(--partial)
        python3 "$SCRIPT_DIR/extract-keysig.py" --base "$BASE" \
            --into "docs/_data/songs/$BASE.json" --landmarks "$LANDMARKS" \
            "${PARTIALOPT[@]}" \
            || echo "     --> WARNING: landmark merge failed for $BASE"
    fi
    rm -f "$LANDMARKS"

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
# Every function build_song calls has to be exported too: each song runs in its
# own `bash -c` under xargs, which inherits only what is exported here.
export -f build_song song_fingerprint books_to_types merge_page_pngs
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
#
# Backgrounded and waited on rather than run in the foreground, so the trap at
# the top of this file can actually fire. Bash runs a trap between commands, so
# a foreground xargs holds the signal pending until it returns on its own -
# which for a full build is hours, and is why killing this script used to leave
# xargs orphaned onto init, still spawning songs. `wait` is interruptible, so
# the handler runs immediately and takes the process group down with it.
# Verified: 10 processes in the group, one TERM to the script, 0 left.
song_list | xargs -0 -P "$JOBS" -I{} bash -c 'build_song "$@"' _ {} &
wait $!
