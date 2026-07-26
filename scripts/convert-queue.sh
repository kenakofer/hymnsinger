#!/bin/bash
# Working queue for converting MuseScore sources to LilyPond songs.
#
# Keeps track of what has been converted, how accurate each conversion is,
# and what still needs a human pass, so a long conversion effort can be
# picked up and put down without losing the thread.
#
#   ./scripts/convert-queue.sh status            what is done / left / needs review
#   ./scripts/convert-queue.sh list [n]          next n unconverted songs, best first
#   ./scripts/convert-queue.sh convert <name>    convert one song into lilypond/songs/
#   ./scripts/convert-queue.sh convert --next N  convert the next N cleanest
#   ./scripts/convert-queue.sh verify [name]     note accuracy vs the source
#   ./scripts/convert-queue.sh review <name>     open the built PDF
#   ./scripts/convert-queue.sh done <name>       mark hand-checked and ready
#
# State lives in .convert-queue/ (git-ignored): the cached MusicXML export
# and a done-list. Everything else is derived, so it is safe to delete.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HYMNS="${HYMNS_DIR:-$REPO/../hymns/hymns}"
STATE="$REPO/.convert-queue"
XML="$STATE/xml"
FRAG="$STATE/fragments"
DONE="$STATE/done.txt"
SONGS="$REPO/lilypond/songs"
TEMPLATE="$REPO/lilypond/muse-template"

mkdir -p "$XML" "$FRAG"
touch "$DONE"

c_red=$'\033[31m'; c_grn=$'\033[32m'; c_yel=$'\033[33m'
c_dim=$'\033[2m'; c_bold=$'\033[1m'; c_off=$'\033[0m'

die() { echo "${c_red}error:${c_off} $*" >&2; exit 1; }

# dash-name for a source file, matching the existing convention
dash_name() {
  basename "$1" \
    | sed -E 's/^.[0-9]+_//; s/\.source\.mscx$//; s/_/-/g; s/[^a-zA-Z0-9-]//g' \
    | tr '[:upper:]' '[:lower:]'
}

ALIASES="$REPO/scripts/queue-aliases.txt"

# The song directory a source maps to, which is not always its dash-name:
# the hymnal sometimes spells a title differently than the tree does
# ("Bless'd" vs "Blest"), and then the plain -d test misses and the queue
# offers a song that is already converted. See scripts/queue-aliases.txt.
song_dir_for() {
  local n="$1" from to
  if [ -f "$ALIASES" ]; then
    while read -r from to; do
      case "$from" in ''|\#*) continue;; esac
      [ "$from" = "$n" ] && { echo "$to"; return 0; }
    done < "$ALIASES"
  fi
  echo "$n"
}

# True when this source is already in the tree, under either name.
already_converted() {
  [ -d "$SONGS/$(song_dir_for "$1")" ]
}

find_source() {
  local want="$1" f
  while IFS= read -r f; do
    [ "$(dash_name "$f")" = "$want" ] && { echo "$f"; return 0; }
  done < <(find "$HYMNS" -name '*.source.mscx' | sort)
  return 1
}

# Export a source to MusicXML, cached by mtime.
ensure_xml() {
  local src="$1" name="$2" out="$XML/$2.xml"
  if [ -f "$out" ] && [ "$out" -nt "$src" ]; then echo "$out"; return 0; fi
  local mscore
  mscore="$(command -v mscore || command -v mscore3 || true)"
  [ -z "$mscore" ] && die "mscore/mscore3 not found"
  QT_QPA_PLATFORM=offscreen timeout 120 "$mscore" "$src" -o "$out" >/dev/null 2>&1
  [ -f "$out" ] || return 1
  echo "$out"
}

ensure_fragment() {
  local xml="$1" name="$2" out="$FRAG/$2.ly"
  python3 "$REPO/scripts/from-xml.py" "$xml" "$out" 2>"$FRAG/$2.warn" || return 1
  echo "$out"
}

cmd_status() {
  local total=0 converted=0 pending=0 marked=0
  local -a pending_names=()
  while IFS= read -r f; do
    total=$((total + 1))
    local n; n="$(dash_name "$f")"
    if already_converted "$n"; then
      converted=$((converted + 1))
      grep -qxF "$n" "$DONE" && marked=$((marked + 1))
    else
      pending=$((pending + 1)); pending_names+=("$n")
    fi
  done < <(find "$HYMNS" -name '*.source.mscx' | sort)

  echo
  echo "${c_bold}conversion queue${c_off}"
  printf "  %-26s %d\n" "sources" "$total"
  printf "  %-26s ${c_grn}%d${c_off}\n" "in lilypond/songs" "$converted"
  printf "  %-26s ${c_grn}%d${c_off}\n" "hand-checked (done)" "$marked"
  printf "  %-26s ${c_yel}%d${c_off}\n" "needs review" "$((converted - marked))"
  printf "  %-26s %d\n" "not converted yet" "$pending"
  echo
  echo "  ${c_dim}next:${c_off} $0 list 10"
}

cmd_list() {
  local limit="${1:-15}"
  echo
  echo "${c_bold}unconverted sources${c_off} ${c_dim}(err% = notes disagreeing with the source; lowest first)${c_off}"
  echo

  # Score every pending song, then show the cleanest -- those are the ones
  # worth a human pass first.
  local tmp; tmp="$(mktemp)"
  local scanned=0
  while IFS= read -r f; do
    local n; n="$(dash_name "$f")"
    already_converted "$n" && continue
    scanned=$((scanned + 1))
    printf '\r  scanning %d...' "$scanned" >&2
    local xml frag rate note=""
    if xml="$(ensure_xml "$f" "$n")" && frag="$(ensure_fragment "$xml" "$n")"; then
      rate="$(python3 "$REPO/scripts/verify-xml-notes.py" \
                --ly-dir "$FRAG" --xml-dir "$XML" --only "$n" 2>/dev/null \
              | awk '/^error rate/{print $NF}')"
      [ -z "$rate" ] && rate="?"
      [ -s "$FRAG/$n.warn" ] && note="$(head -1 "$FRAG/$n.warn" | sed 's/warning: //')"
      printf '%s\t%s\t%s\n' "${rate%\%}" "$n" "$note" >> "$tmp"
    else
      printf '999\t%s\tconversion failed\n' "$n" >> "$tmp"
    fi
  done < <(find "$HYMNS" -name '*.source.mscx' | sort)
  printf '\r%*s\r' 30 '' >&2

  sort -g "$tmp" | head -"$limit" | while IFS=$'\t' read -r rate n note; do
    local colour="$c_grn"
    awk "BEGIN{exit !($rate > 5)}"  && colour="$c_yel"
    awk "BEGIN{exit !($rate > 20)}" && colour="$c_red"
    printf "  %-46s ${colour}%6s%%${c_off}  ${c_dim}%s${c_off}\n" "$n" "$rate" "$note"
  done
  rm -f "$tmp"
  echo
  echo "  ${c_dim}convert one:${c_off} $0 convert <name>"
}

cmd_convert() {
  local name="$1"
  local src; src="$(find_source "$name")" || die "no source for '$name'"
  [ -d "$SONGS/$name" ] && die "$SONGS/$name already exists (remove it to redo)"
  local existing; existing="$(song_dir_for "$name")"
  [ "$existing" != "$name" ] && [ -d "$SONGS/$existing" ] \
    && die "'$name' is $existing under another spelling (scripts/queue-aliases.txt)"

  echo "source   $src"
  local xml; xml="$(ensure_xml "$src" "$name")" || die "MusicXML export failed"
  local frag; frag="$(ensure_fragment "$xml" "$name")" || die "conversion failed"

  cp -r "$TEMPLATE" "$SONGS/$name"
  mv "$SONGS/$name/muse-template.ly" "$SONGS/$name/$name.ly"
  rm -f "$SONGS/$name/muse-template.pdf"

  python3 "$REPO/scripts/lyrics_extractor.py" "$xml" > "$STATE/$name.lyrics" \
    2>>"$FRAG/$name.warn"
  # [A-H]: the library has <N>verse.ily for 1..8. This must stay in step
  # with VERSE_LETTERS in lyrics_extractor.py - when it said [A-G] and the
  # extractor emitted 8 verses, verseCount and the \include would disagree
  # with the lyrics actually in the file.
  local verses; verses="$(grep -c '^verse[A-H] = ' "$STATE/$name.lyrics" 2>/dev/null || echo 1)"
  [ "$verses" -lt 1 ] && verses=1

  python3 - "$SONGS/$name/$name.ly" "$frag" "$STATE/$name.lyrics" "$verses" <<'PY'
import re, sys
target, frag, lyrics, verses = sys.argv[1:5]
tpl = open(target).read()
gen = open(frag).read()
lyr = open(lyrics).read() if lyrics else ''
HDR = ('title =', 'hymnKey', 'hymnTime', 'quarternoteTempo',
       'hymnBaseMoment', 'hymnBeatStructure', '\\include', '%')
hdr, body = [], []
for line in gen.splitlines():
    (hdr if line.startswith(HDR) else body).append(line)
body = '\n'.join(body)
chords = ''
if 'songChords' in body:
    i = body.index('songChords')
    chords, body = body[i:], body[:i]
tpl = tpl.replace('%NOTES', '\n'.join(hdr) + '\n' + body)
if chords:
    tpl = re.sub(r'songChords = \\chords \{.*?\n\}', lambda m: chords.rstrip(),
                 tpl, flags=re.S)
tpl = tpl.replace('%LYRICS', lyr)
tpl = tpl.replace('VERSE_COUNT', verses)
from datetime import date
tpl = tpl.replace('%YYYY-MM-DD%', '"%s"' % date.today().isoformat())
open(target, 'w').write(tpl)
PY
  rm -f "$STATE/$name.lyrics"

  echo "wrote    $SONGS/$name/$name.ly"
  ( cd "$SONGS/$name" && lilypond "$name.ly" >/dev/null 2>&1 ) \
    && echo "${c_grn}compiled${c_off} ok" \
    || echo "${c_yel}compile had errors${c_off} - run lilypond in $SONGS/$name"

  if [ -s "$FRAG/$name.warn" ]; then
    echo "${c_yel}warnings${c_off}"
    sed 's/^/  /' "$FRAG/$name.warn"
  fi
  echo
  echo "${c_bold}next steps${c_off} ${c_dim}(metadata is NOT in the source - fill by hand)${c_off}"
  echo "  1. composer / poet / meter placeholders in $name.ly"
  echo "  2. $0 verify $name"
  echo "  3. $0 review $name"
  echo "  4. $0 done $name"
}

cmd_verify() {
  local name="${1:-}"
  if [ -n "$name" ]; then
    python3 "$REPO/scripts/verify-xml-notes.py" \
      --ly-dir "$FRAG" --xml-dir "$XML" --only "$name" --verbose
  else
    python3 "$REPO/scripts/verify-xml-notes.py" --ly-dir "$FRAG" --xml-dir "$XML"
  fi
}

cmd_review() {
  local name="$1"
  local pdf
  pdf="$(find "$SONGS/$name" -name '*trad.pdf' -o -name '*.pdf' 2>/dev/null \
         | grep -v muse-template | head -1)"
  [ -z "$pdf" ] && die "no PDF in $SONGS/$name - convert it first"
  echo "opening $pdf"
  (xdg-open "$pdf" >/dev/null 2>&1 &)
}

cmd_done() {
  local name="$1"
  [ -d "$SONGS/$name" ] || die "$name is not converted yet"
  grep -qxF "$name" "$DONE" || echo "$name" >> "$DONE"
  echo "${c_grn}marked done:${c_off} $name"
  if grep -q 'Music: Composer\|Text: Author\|TUNE NAME meter' \
       "$SONGS/$name/$name.ly" 2>/dev/null; then
    echo "${c_yel}note:${c_off} placeholder metadata is still in $name.ly"
  fi
}

case "${1:-status}" in
  status)  cmd_status ;;
  list)    cmd_list "${2:-15}" ;;
  convert)
    shift
    [ $# -eq 0 ] && die "usage: convert <name> | convert --next N"
    if [ "$1" = "--next" ]; then
      n="${2:-1}"
      while IFS= read -r f; do
        [ "$n" -le 0 ] && break
        name="$(dash_name "$f")"
        [ -d "$SONGS/$name" ] && continue
        echo "=== $name"; cmd_convert "$name" || true; echo
        n=$((n - 1))
      done < <(find "$HYMNS" -name '*.source.mscx' | sort)
    else
      cmd_convert "$1"
    fi ;;
  verify)  cmd_verify "${2:-}" ;;
  review)  [ $# -ge 2 ] || die "usage: review <name>"; cmd_review "$2" ;;
  done)    [ $# -ge 2 ] || die "usage: done <name>";   cmd_done "$2" ;;
  *)       sed -n '2,25p' "${BASH_SOURCE[0]}" | sed 's/^# \?//' ;;
esac
