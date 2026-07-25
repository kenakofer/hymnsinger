#!/bin/bash
# Song intake: hymnal photos -> reviewed metadata -> published song.
#
# Implements docs/song-intake-protocol.md. Work happens on a side branch,
# one commit per stage, so each step is a checkpoint you can read, amend,
# or drop:
#
#   start <song>              branch intake/<song>, convert, commit notes
#   transcribe <song>         commit the agent's metadata edits
#   review <song>             show the metadata commit and confidence notes
#   listen <song>             play the generated MIDI
#   publish <song> [--public] merge to main, and public-main if eligible
#
# The agent edits the .ly directly and runs `transcribe`. It never merges
# and never touches main or public-main.
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SONGS="$REPO/lilypond/songs"
PUBLIC_BRANCH="${PUBLIC_BRANCH:-public-main}"
MAIN_BRANCH="${MAIN_BRANCH:-main}"

c_red=$'\033[31m'; c_grn=$'\033[32m'; c_yel=$'\033[33m'
c_dim=$'\033[2m'; c_bold=$'\033[1m'; c_off=$'\033[0m'

die() { echo "${c_red}error:${c_off} $*" >&2; exit 1; }
note() { echo "${c_dim}$*${c_off}"; }

branch_for() { echo "intake/$1"; }

# publish ships source, not a song on the site: it commits the .ly and
# nothing else, so the song is absent from hymnsinger.com until the docs/
# assets and pages exist. That gap is deliberate - the --public path takes
# only lilypond/songs/<song> from the intake branch, which is what stops a
# branch forked from main dragging copyrighted songs onto public-main, and
# widening it to docs/ would reopen that leak. So warn instead of building.
# Checked against the working tree, so it stays quiet if you already ran
# republish-all.sh. See Stage 5 in docs/song-intake-protocol.md.
assets_warning() {
  local song="$1"
  # Key on the listing page and _data entry only. Both live on $MAIN_BRANCH,
  # and they are what Jekyll builds the song's page from - without them
  # there is no page for a PDF to hang off. Deliberately NOT checking
  # docs/local-lilypond-outputs/: that directory exists only on
  # $PUBLIC_BRANCH, so testing it from main would warn on every song and
  # train you to ignore the warning.
  [ -f "$REPO/docs/listing/$song.md" ] \
    && [ -f "$REPO/docs/_data/songs/$song.json" ] && return 0

  echo "${c_yel}warning${c_off} $song has no site page: it will not appear on the site"
  note "  the .ly is committed, but docs/listing/$song.md and"
  note "  docs/_data/songs/$song.json are not, and Jekyll builds the"
  note "  song's page from those - Pages does not run LilyPond, so"
  note "  what is not committed does not exist to a visitor"
  note "  generate them, then review and push:  scripts/republish-all.sh"
  echo
}

require_clean() {
  git -C "$REPO" diff --quiet && git -C "$REPO" diff --cached --quiet \
    || die "working tree has uncommitted changes; commit or stash first"
}

# Only the .ly is tracked; pdf/midi/mp3 are git-ignored.
song_ly() { echo "lilypond/songs/$1/$1.ly"; }

cmd_start() {
  local song="$1"
  local branch; branch="$(branch_for "$song")"
  require_clean
  git -C "$REPO" show-ref --verify --quiet "refs/heads/$branch" \
    && die "$branch already exists (git branch -D $branch to redo)"
  [ -d "$SONGS/$song" ] && die "$SONGS/$song already exists"

  # Fork from main, NOT from wherever HEAD happens to sit. An intake
  # branch that starts off a feature branch carries that branch's history
  # as ancestors, and `publish` then merges all of it into main and
  # public-main - which is how a converter branch full of copyrighted
  # songs once rode a single public-domain hymn onto public-main.
  git -C "$REPO" show-ref --verify --quiet "refs/heads/$MAIN_BRANCH" \
    || die "$MAIN_BRANCH does not exist"
  git -C "$REPO" checkout -q -b "$branch" "$MAIN_BRANCH" \
    || die "could not create $branch off $MAIN_BRANCH"
  echo "${c_grn}branch${c_off}   $branch ${c_dim}(off $MAIN_BRANCH)${c_off}"

  local warnings
  warnings="$("$REPO/scripts/convert-queue.sh" convert "$song" 2>&1)" || {
    echo "$warnings"
    git -C "$REPO" checkout -q -; git -C "$REPO" branch -D "$branch" >/dev/null
    die "conversion failed"
  }
  echo "$warnings" | sed 's/^/  /'

  local ly; ly="$(song_ly "$song")"
  [ -f "$REPO/$ly" ] || die "conversion produced no $ly"

  # Carry the converter's warnings into the commit: they say where the
  # generated music is least trustworthy, which is what stage 3 checks.
  local warn_lines
  warn_lines="$(printf '%s\n' "$warnings" | grep -i '^\s*warning:' | sed 's/^\s*/  /')"
  {
    echo "Convert $song from MuseScore source"
    echo
    echo "Machine-generated notes and lyrics from scripts/from-xml.py."
    echo "Metadata is not in the MuseScore sources and comes next."
    if [ -n "$warn_lines" ]; then
      echo
      echo "Converter warnings:"
      echo "$warn_lines"
    fi
  } > /tmp/intake-msg-$$
  git -C "$REPO" add "$ly"
  git -C "$REPO" commit -q -F /tmp/intake-msg-$$ || die "commit failed"
  rm -f /tmp/intake-msg-$$

  echo "${c_grn}committed${c_off} conversion"
  echo
  echo "${c_bold}next${c_off}: give the agent the photos, this file, and"
  echo "  docs/song-intake-protocol.md   (stage 2)"
  echo "  $ly"
  echo
  echo "then: $0 transcribe $song"
}

cmd_transcribe() {
  local song="$1"
  local branch; branch="$(branch_for "$song")"
  local current; current="$(git -C "$REPO" rev-parse --abbrev-ref HEAD)"
  [ "$current" = "$branch" ] || die "not on $branch (on $current)"

  local ly; ly="$(song_ly "$song")"
  git -C "$REPO" diff --quiet -- "$ly" \
    && die "no changes to $ly - the agent has not edited it yet"

  # The music belongs to commit 1. A transcription that changes notes or
  # lyrics means something went wrong, so refuse rather than bury it.
  local music_changed
  music_changed="$(git -C "$REPO" diff -U0 -- "$ly" \
    | grep -E '^[+-]' | grep -vE '^[+-][+-]' \
    | grep -vcE '^[+-]\s*(composer|poet|meter|title|tags|verseCount|dateAdded|typesetter|subtitle|arranger|alternateTitle)\s*=|^[+-]\s*\\header\s*\{.*copyright|^[+-]\s*$' \
    || true)"
  if [ "${music_changed:-0}" -gt 0 ] && [ "${FORCE:-0}" != "1" ]; then
    echo "${c_yel}warning${c_off} the diff touches $music_changed non-metadata line(s):"
    git -C "$REPO" diff -- "$ly" | grep -E '^[+-]' | grep -vE '^[+-][+-]' \
      | grep -vE '^[+-]\s*(composer|poet|meter|title|tags|verseCount|dateAdded|typesetter|subtitle|arranger|alternateTitle)\s*=|^[+-]\s*\\header\s*\{.*copyright' \
      | head -8 | sed 's/^/    /'
    die "notes and lyrics belong to the conversion commit (FORCE=1 to override)"
  fi

  local msgfile="${MSG_FILE:-}"
  if [ -z "$msgfile" ]; then
    msgfile="$(mktemp)"
    cat > "$msgfile" <<'TEMPLATE'
Add metadata for SONG from HYMNAL, p.N

Copyright-Status: copyrighted | public-domain | unknown | mixed
Copyright-Notice: <verbatim, or "none visible">
Copyright-Covers: <text | music | arrangement | translation>
Copyright-Reasoning: <dates and why>

Confidence: composer=high, meter=low
Uncertain: <what was hard to read, and how it was resolved>
Source: <photo filenames>
TEMPLATE
    echo "${c_dim}opening commit message template...${c_off}"
    "${EDITOR:-vi}" "$msgfile"
  fi

  local status
  status="$(grep -i '^Copyright-Status:' "$msgfile" | head -1 \
            | sed 's/^[^:]*:\s*//' | tr -d '\r' | awk '{print $1}')"
  case "$status" in
    copyrighted|public-domain|unknown|mixed) ;;
    *) die "Copyright-Status must be one of: copyrighted, public-domain, unknown, mixed (got '${status:-empty}')" ;;
  esac

  # public-domain is the only status that can reach a public repo, so the
  # reasoning has to be positive dated evidence, not a missing notice.
  if [ "$status" = "public-domain" ]; then
    local reasoning
    # Reasoning usually wraps, so take the field and its indented
    # continuation lines; reading only the first line loses the dates.
    reasoning="$(awk '
      /^[Cc]opyright-[Rr]easoning:/ { collecting=1; sub(/^[^:]*:[ \t]*/, ""); print; next }
      collecting && /^[ \t]+[^ \t]/ { print; next }
      collecting { collecting=0 }
    ' "$msgfile")"
    [ -z "$reasoning" ] && die "public-domain requires Copyright-Reasoning"
    echo "$reasoning" | grep -qE '\b1[0-9]{3}\b' \
      || die "public-domain reasoning must cite publication dates; absence of a notice is not evidence"
    if echo "$reasoning" | grep -qiE '\b(no|without|absent|missing|lack[a-z]*)\b[^.]{0,40}\b(notice|copyright|©)'; then
      die "public-domain reasoning argues from a missing notice; use dates or mark unknown"
    fi
  fi

  git -C "$REPO" add "$ly"
  git -C "$REPO" commit -q -F "$msgfile" || die "commit failed"
  [ -z "${MSG_FILE:-}" ] && rm -f "$msgfile"

  echo "${c_grn}committed${c_off} metadata (Copyright-Status: $status)"
  echo
  echo "next: $0 review $song"
}

cmd_review() {
  local song="$1"
  local branch; branch="$(branch_for "$song")"
  git -C "$REPO" show-ref --verify --quiet "refs/heads/$branch" \
    || die "$branch does not exist"

  echo
  echo "${c_bold}metadata commit${c_off} ${c_dim}(stage 2 - the agent's transcription)${c_off}"
  git -C "$REPO" show --no-patch --format='%B' "$branch" | sed 's/^/  /'
  echo "${c_dim}$(printf '%.0s-' {1..60})${c_off}"
  git -C "$REPO" show --format='' "$branch" -- "$(song_ly "$song")" \
    | grep -E '^[+-]' | grep -vE '^[+-][+-]' | sed 's/^/  /'

  local warnings
  warnings="$(git -C "$REPO" show --no-patch --format='%B' "$branch~1" \
              | grep -A20 'Converter warnings:' || true)"
  if [ -n "$warnings" ]; then
    echo
    echo "${c_yel}converter warnings from the conversion commit${c_off}"
    echo "$warnings" | sed 's/^/  /'
  fi

  echo
  echo "${c_bold}now inspect${c_off}"
  echo "  visual : scripts/convert-queue.sh review $song"
  echo "  audio  : $0 listen $song"
  echo
  echo "${c_dim}  amend metadata : git commit --amend"
  echo "  drop metadata  : git reset --hard HEAD~1"
  echo "  abandon        : git branch -D $branch${c_off}"
  echo
  echo "  publish: $0 publish $song [--public]"
}

cmd_listen() {
  local song="$1"
  local dir="$SONGS/$song"
  [ -d "$dir" ] || die "$dir does not exist"
  local midi; midi="$(find "$dir" -maxdepth 1 -name '*.midi' -o -maxdepth 1 -name '*.mid' | head -1)"
  [ -z "$midi" ] && die "no MIDI in $dir - compile the song first"
  for p in timidity fluidsynth mpv vlc; do
    if command -v "$p" >/dev/null 2>&1; then
      note "listen for: a melody you recognise, no odd leaps, clean cadences"
      case "$p" in
        fluidsynth) "$p" -i "$midi" ;;
        *) "$p" "$midi" ;;
      esac
      return 0
    fi
  done
  echo "no MIDI player found. File is at:"
  echo "  $midi"
}

# No song carrying a copyright notice may exist on the public branch.
public_branch_clean() {
  local offenders=""
  while read -r f; do
    [ -z "$f" ] && continue
    if git -C "$REPO" show "$PUBLIC_BRANCH:$f" 2>/dev/null \
         | grep -q '^\s*\\header\s*{.*copyright\s*='; then
      offenders="$offenders $(basename "$f")"
    fi
  done < <(git -C "$REPO" ls-tree -r --name-only "$PUBLIC_BRANCH" \
             -- lilypond/songs 2>/dev/null | grep '\.ly$')
  echo "$offenders"
}

cmd_publish() {
  local song="$1"; shift
  local want_public=0
  [ "${1:-}" = "--public" ] && want_public=1

  local branch; branch="$(branch_for "$song")"
  git -C "$REPO" show-ref --verify --quiet "refs/heads/$branch" \
    || die "$branch does not exist"
  require_clean

  # The metadata commit is not necessarily the branch tip: notation fixes
  # and hand edits legitimately land after `transcribe`. Find the commit on
  # this branch (ahead of main) that carries the Copyright-Status line, and
  # read the determination from that commit's message.
  local msg status notice meta_commit
  meta_commit="$(git -C "$REPO" log --format='%H' "$MAIN_BRANCH..$branch" \
                 --grep='^Copyright-Status:' -i | head -1)"
  [ -z "$meta_commit" ] \
    && die "no commit on $branch carries a Copyright-Status: line (did you run transcribe?)"
  msg="$(git -C "$REPO" show --no-patch --format='%B' "$meta_commit")"
  status="$(echo "$msg" | grep -i '^Copyright-Status:' | head -1 \
            | sed 's/^[^:]*:\s*//' | awk '{print $1}')"
  # A wrapped notice must be read whole: truncating it could turn a real
  # notice into an empty string and let a copyrighted song through.
  notice="$(printf '%s\n' "$msg" | awk '
    /^[Cc]opyright-[Nn]otice:/ { collecting=1; sub(/^[^:]*:[ \t]*/, ""); print; next }
    collecting && /^[ \t]+[^ \t]/ { print; next }
    collecting { collecting=0 }
  ')"

  [ -z "$status" ] && die "no Copyright-Status in the metadata commit"
  [ "$status" = "unknown" ] && die "copyright status is unknown - resolve before publishing"

  # The branch must sit directly on top of main, carrying only this song's
  # own commits. If it forked from somewhere else it drags that history
  # into main (and possibly public-main) on merge - the failure that once
  # put a whole converter branch, copyrighted songs and all, onto
  # public-main. List the files this merge would introduce and refuse if
  # any belong to a song other than this one.
  local stray
  stray="$(git -C "$REPO" diff --name-only "$MAIN_BRANCH...$branch" -- lilypond/songs \
           | sed -n 's,^lilypond/songs/\([^/]*\)/.*,\1,p' | sort -u \
           | grep -vx "$song")"
  if [ -n "$stray" ]; then
    die "branch is not based on $MAIN_BRANCH: publishing it would also change other songs:
$(echo "$stray" | sed 's/^/    /')
    rebase intake onto $MAIN_BRANCH (git rebase --onto $MAIN_BRANCH ... $branch) first"
  fi

  local ly; ly="$(song_ly "$song")"
  git -C "$REPO" show "$branch:$ly" \
    | grep -qE 'Music: Composer|Text: Author|TUNE NAME meter' \
    && die "placeholder metadata still present in $ly"

  ( cd "$SONGS/$song" && lilypond "$song.ly" >/dev/null 2>&1 ) \
    || die "$song.ly does not compile"
  echo "${c_grn}compiles${c_off} ok"

  # Check every public precondition BEFORE merging anything, so a refusal
  # never leaves a half-finished publish behind.
  if [ "$want_public" = "1" ]; then
    [ "$status" = "public-domain" ] \
      || die "refusing public: Copyright-Status is '$status', not 'public-domain'"
    if [ -n "$notice" ] && ! echo "$notice" | grep -qi 'none visible'; then
      die "refusing public: a copyright notice is recorded ($notice)"
    fi
    local offenders; offenders="$(public_branch_clean)"
    [ -n "$offenders" ] \
      && die "$PUBLIC_BRANCH already contains copyrighted songs:$offenders"
    git -C "$REPO" show-ref --verify --quiet "refs/heads/$PUBLIC_BRANCH" \
      || die "$PUBLIC_BRANCH does not exist"
  fi

  git -C "$REPO" checkout -q "$MAIN_BRANCH" || die "could not switch to $MAIN_BRANCH"
  git -C "$REPO" merge --no-ff -q -m "Add song \"$song\" ($status)" "$branch" \
    || die "merge into $MAIN_BRANCH failed"
  echo "${c_grn}merged${c_off}   $branch -> $MAIN_BRANCH"

  if [ "$want_public" != "1" ]; then
    [ "$status" = "public-domain" ] \
      && note "public-domain: pass --public to also promote to $PUBLIC_BRANCH"
    echo
    assets_warning "$song"
    note "not pushed - review, then: git push origin $MAIN_BRANCH"
    return 0
  fi

  # Do NOT merge the branch into public-main: the branch is forked from
  # main, so a merge would drag main's divergent (copyrighted) songs onto
  # public-main. That is exactly the leak this guard exists to prevent.
  # Instead take ONLY this song's files from the branch and commit them, so
  # public-main gains the one song and nothing else.
  git -C "$REPO" checkout -q "$PUBLIC_BRANCH" || die "could not switch to $PUBLIC_BRANCH"
  if ! git -C "$REPO" checkout "$branch" -- "lilypond/songs/$song" 2>/dev/null; then
    git -C "$REPO" checkout -q "$MAIN_BRANCH"
    die "could not take lilypond/songs/$song from $branch"
  fi
  # Post-condition: adding this song must not introduce a copyright field on
  # public-main. Belt-and-suspenders against a mislabelled song or a stray
  # file, checked against the actual staged tree before committing.
  if git -C "$REPO" grep -qE 'copyright\s*=' -- 'lilypond/songs/**/*.ly'; then
    git -C "$REPO" reset -q --hard
    git -C "$REPO" checkout -q "$MAIN_BRANCH"
    die "aborted: publishing $song would put a copyright field on $PUBLIC_BRANCH"
  fi
  git -C "$REPO" add "lilypond/songs/$song" \
    || { git -C "$REPO" checkout -q "$MAIN_BRANCH"; die "git add failed"; }
  git -C "$REPO" commit -q -m "Add song \"$song\"" \
    || { git -C "$REPO" checkout -q "$MAIN_BRANCH"; die "commit into $PUBLIC_BRANCH failed"; }
  echo "${c_grn}added${c_off}    $song -> $PUBLIC_BRANCH ${c_dim}(files only, no merge)${c_off}"
  git -C "$REPO" checkout -q "$MAIN_BRANCH"

  echo
  assets_warning "$song"
  note "not pushed - review both branches, then:"
  note "  git push origin $MAIN_BRANCH"
  note "  git push public-origin $PUBLIC_BRANCH:main"
}

case "${1:-help}" in
  start)      [ $# -ge 2 ] || die "usage: start <song>";      cmd_start "$2" ;;
  transcribe) [ $# -ge 2 ] || die "usage: transcribe <song>"; cmd_transcribe "$2" ;;
  review)     [ $# -ge 2 ] || die "usage: review <song>";     cmd_review "$2" ;;
  listen)     [ $# -ge 2 ] || die "usage: listen <song>";     cmd_listen "$2" ;;
  publish)    [ $# -ge 2 ] || die "usage: publish <song> [--public]";
              song="$2"; shift 2; cmd_publish "$song" "$@" ;;
  *)          sed -n '2,15p' "${BASH_SOURCE[0]}" | sed 's/^# \?//' ;;
esac
