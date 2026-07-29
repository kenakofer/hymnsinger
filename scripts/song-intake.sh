#!/bin/bash
# Song intake: hymnal photos -> reviewed metadata -> published song.
#
# Implements docs/song-intake-protocol.md. Work happens on a side branch
# and lands as ONE commit per song:
#
#   start <song>              branch intake/<song> off public-main, convert
#   transcribe <song>         fold metadata into the song's commit
#   review <song>             show the commit and confidence notes
#   listen <song>             play the generated MIDI
#   publish <song> [--public] merge to public-main if eligible, then main
#   check                     cross-branch invariants: counts, toolchain
#                             drift, and no copyright field on public-main
#
# The agent edits the .ly directly and runs `transcribe`. It never merges
# and never touches main or public-main.
#
# `start` commits the raw conversion so there is something to diff against
# while transcribing; `transcribe` amends that commit rather than adding a
# second one. Intake used to keep the two apart and refuse a metadata
# commit that touched notes or lyrics, on the theory that machine output
# and human transcription should be separately auditable. In practice the
# split cost more than it returned: hand fixes to the generated music
# (slurs the source never encoded, system breaks, corrected misspellings)
# are a normal part of transcribing and legitimately land in the same
# sitting, so the gate mostly produced amend-and-restage busywork, and it
# misfired on layout fields like clairStaffZoom that are neither notes nor
# lyrics. The copyright validation below is the check that actually has
# teeth, and it never depended on the split.
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
  # Key on the listing page and _data entry only. They exist on both
  # branches and are what Jekyll builds the song's page from - without them
  # there is no page for a PDF to hang off. This runs after the final
  # checkout, so it is reading $MAIN_BRANCH's working tree.
  #
  # Deliberately NOT checking the outputs directory: the two branches keep
  # it in different places ($PUBLIC_BRANCH in docs/local-lilypond-outputs/,
  # $MAIN_BRANCH in docs/_site/local-lilypond-outputs/) because their hosts
  # differ, so a single path would warn on every song on one branch and
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

# The stages move songs; they do not move tooling. Stage 4 merges the intake
# branch into $PUBLIC_BRANCH but takes only lilypond/songs/<song> across to
# $MAIN_BRANCH, so a fix committed to a script on the intake branch reaches
# the public branch and silently misses the private one. The reverse gap is
# worse: an intake branch forks from $PUBLIC_BRANCH, so a script fixed only
# on $MAIN_BRANCH is not the script Stage 1 actually runs. Both happened
# while publishing blessed-assurance - see "Keeping main and public-main in
# sync" in docs/song-intake-protocol.md.
#
# Only the intake toolchain is checked. The six host-specific scripts
# (republish-all.sh, the index generators, ...) differ for good reasons and
# are expected to; listing them here would train you to ignore the warning.
# These six have no host-specific paths and should stay byte-identical.
TOOLCHAIN_SHARED=(
  scripts/song-intake.sh
  scripts/convert-queue.sh
  scripts/from-xml.py
  scripts/from-muse.py
  scripts/lyrics_extractor.py
  scripts/verify-xml-notes.py
)

toolchain_warning() {
  local f a b drift=""
  for f in "${TOOLCHAIN_SHARED[@]}"; do
    # Compare blob hashes, not `git diff <branch> <branch> -- <path>`, which
    # reports byte-identical paths as differing.
    a=$(git -C "$REPO" rev-parse "$MAIN_BRANCH:$f" 2>/dev/null) || continue
    b=$(git -C "$REPO" rev-parse "$PUBLIC_BRANCH:$f" 2>/dev/null) || continue
    [ "$a" != "$b" ] && drift="$drift $f"
  done
  [ -z "$drift" ] && return 0

  echo "${c_yel}warning${c_off} intake toolchain differs between branches"
  for f in $drift; do note "  $f"; done
  note "  these carry no host-specific paths and should be identical."
  note "  stage 1 runs whichever copy $PUBLIC_BRANCH holds, so a fix that"
  note "  landed on only one branch is not the one the next song will use."
  note "  port it by hand, verbatim, and push both branches."
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

  # The hymnal sometimes spells a title differently than the tree does
  # ("Bless'd" vs "Blest"), so the check above misses and intake starts on
  # a song that is already converted. Caught here rather than at publish,
  # where the duplicate would already have a branch and two commits.
  local aliases="$REPO/scripts/queue-aliases.txt"
  if [ -f "$aliases" ]; then
    local from to
    while read -r from to; do
      case "$from" in ''|\#*) continue;; esac
      [ "$from" = "$song" ] && [ -d "$SONGS/$to" ] \
        && die "'$song' is already converted as $to (scripts/queue-aliases.txt)"
    done < "$aliases"
  fi

  # Fork from public-main, NOT from main and NOT from wherever HEAD
  # happens to sit.
  #
  # public-main holds only public-domain songs, so a branch forked from it
  # can be merged into public-main later and carry nothing but this song.
  # A branch forked from main cannot: main has 19 songs public-main lacks,
  # 12 of them copyrighted, and merging such a branch drags all of them
  # across. That is why publish used to copy the song's files across
  # instead of merging, and forking from here is what makes an honest
  # merge possible.
  #
  # Nothing about this exposes the song. The branch lives in the private
  # repo, has no upstream, and `git push` on it refuses and suggests
  # origin (private). A song that turns out copyrighted simply never gets
  # merged into public-main.
  git -C "$REPO" show-ref --verify --quiet "refs/heads/$PUBLIC_BRANCH" \
    || die "$PUBLIC_BRANCH does not exist"
  git -C "$REPO" checkout -q -b "$branch" "$PUBLIC_BRANCH" \
    || die "could not create $branch off $PUBLIC_BRANCH"
  echo "${c_grn}branch${c_off}   $branch ${c_dim}(off $PUBLIC_BRANCH)${c_off}"

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
  # A clean tree is fine on a re-run: transcribe amends, so fixing a typo
  # in the message alone is a legitimate second call. Only refuse when the
  # file is untouched AND the commit has no determination yet, which is
  # the real "the agent has not edited it" case.
  if git -C "$REPO" diff --quiet -- "$ly"; then
    git -C "$REPO" show --no-patch --format='%B' HEAD \
      | grep -qi '^Copyright-Status:' \
      || die "no changes to $ly - the agent has not edited it yet"
  fi

  # No metadata-vs-music check here on purpose: this commit carries the
  # whole song, hand fixes to the generated music included. See the header.

  local msgfile="${MSG_FILE:-}"
  if [ -z "$msgfile" ]; then
    msgfile="$(mktemp)"
    cat > "$msgfile" <<'TEMPLATE'
Add song "SONG" from HYMNAL, p.N

Converted from the MuseScore source, with metadata transcribed from the
page. Note any hand fixes to the generated music here.

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

  # Amend the conversion commit rather than stacking a second one, so the
  # song lands as a single commit. Guarded: amending when HEAD is the fork
  # point would rewrite a commit that belongs to public-main, not to this
  # song. In that case fall back to a fresh commit.
  git -C "$REPO" add "$ly"
  local base amend_ok=0
  base="$(git -C "$REPO" merge-base "$branch" "$PUBLIC_BRANCH" 2>/dev/null || true)"
  local head; head="$(git -C "$REPO" rev-parse HEAD)"
  if [ -n "$base" ] && [ "$head" != "$base" ]; then
    # Only fold into a commit this branch created for this song.
    if git -C "$REPO" show -s --format=%s HEAD | grep -qiE "^Convert .*$song|^Add song"; then
      amend_ok=1
    fi
  fi

  if [ "$amend_ok" = "1" ]; then
    # Amending with -F replaces the message outright, which would throw
    # away the converter warnings start recorded. They say where the
    # generated music is least trustworthy and are exactly what review
    # shows, so carry them onto the end of the new message.
    local carried
    carried="$(git -C "$REPO" show --no-patch --format='%B' HEAD \
               | grep -A20 'Converter warnings:' || true)"
    local finalmsg="$msgfile"
    if [ -n "$carried" ]; then
      finalmsg="$(mktemp)"
      cat "$msgfile" > "$finalmsg"
      printf '\n%s\n' "$carried" >> "$finalmsg"
    fi
    git -C "$REPO" commit -q --amend -F "$finalmsg" || die "commit failed"
    [ "$finalmsg" != "$msgfile" ] && rm -f "$finalmsg"
    echo "${c_grn}committed${c_off} song, one commit (Copyright-Status: $status)"
  else
    git -C "$REPO" commit -q -F "$msgfile" || die "commit failed"
    echo "${c_grn}committed${c_off} metadata (Copyright-Status: $status)"
  fi
  [ -z "${MSG_FILE:-}" ] && rm -f "$msgfile"

  echo
  echo "next: $0 review $song"
}

cmd_review() {
  local song="$1"
  local branch; branch="$(branch_for "$song")"
  git -C "$REPO" show-ref --verify --quiet "refs/heads/$branch" \
    || die "$branch does not exist"

  echo
  echo "${c_bold}song commit${c_off} ${c_dim}(the agent's transcription)${c_off}"
  git -C "$REPO" show --no-patch --format='%B' "$branch" | sed 's/^/  /'

  # The commit carries the whole song, so its diff is the entire file and
  # too long to read here. Show the header fields, which are what stage 3
  # is actually checking, and leave the music to the visual review below.
  echo "${c_dim}$(printf '%.0s-' {1..60})${c_off}"
  git -C "$REPO" show --format='' "$branch" -- "$(song_ly "$song")" \
    | grep -E '^[+-]' | grep -vE '^[+-][+-]' \
    | grep -E '^[+-][[:space:]]*%?[[:space:]]*(composer|poet|meter|title|tags|verseCount|dateAdded|typesetter|subtitle|arranger|alternateTitle|copyright)[[:space:]]*=' \
    | sed 's/^/  /'

  # Converter warnings live in this same commit now (start writes them,
  # transcribe amends around them), so read them from the commit itself
  # rather than from a conversion commit that no longer exists.
  local warnings
  warnings="$(git -C "$REPO" show --no-patch --format='%B' "$branch" \
              | grep -A20 'Converter warnings:' || true)"
  if [ -n "$warnings" ]; then
    echo
    echo "${c_yel}converter warnings${c_off}"
    echo "$warnings" | sed 's/^/  /'
  fi

  echo
  echo "${c_bold}now inspect${c_off}"
  echo "  visual : scripts/convert-queue.sh review $song"
  echo "  audio  : $0 listen $song"
  echo
  echo "${c_dim}  amend the song : git commit --amend"
  echo "  redo metadata  : edit the .ly, then $0 transcribe $song"
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
#
# Match `copyright =` anywhere, not just on a line that also opens the
# \header block. Every copyrighted song today writes it as the one-liner
# '\header { copyright = "..." }', but nothing enforces that spelling, and
# a header split across lines would walk straight past a stricter pattern.
# This is the check that decides whether a song may go public: it should
# err toward flagging. The post-condition check after the merge uses the
# same loose pattern, so the two cannot disagree.
public_branch_clean() {
  local offenders=""
  while read -r f; do
    [ -z "$f" ] && continue
    if git -C "$REPO" show "$PUBLIC_BRANCH:$f" 2>/dev/null \
         | grep -qE '^[^%]*copyright[[:space:]]*='; then
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
  # this branch (ahead of public-main, which is what it forked from) that
  # carries the Copyright-Status line, and read the determination from that
  # commit's message.
  local msg status notice meta_commit
  meta_commit="$(git -C "$REPO" log --format='%H' "$PUBLIC_BRANCH..$branch" \
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

  # The branch must sit directly on top of public-main, carrying only this
  # song's own commits. If it forked from somewhere else - main especially -
  # it drags that history along, and for a --public song the merge would
  # put every song main has and public-main lacks onto the public branch.
  # That is the failure that once put a whole converter branch, copyrighted
  # songs and all, onto public-main. List the files this merge would
  # introduce and refuse if any belong to a song other than this one.
  local stray
  stray="$(git -C "$REPO" diff --name-only "$PUBLIC_BRANCH...$branch" -- lilypond/songs \
           | sed -n 's,^lilypond/songs/\([^/]*\)/.*,\1,p' | sort -u \
           | grep -vx "$song")"
  if [ -n "$stray" ]; then
    die "branch is not based on $PUBLIC_BRANCH: publishing it would also change other songs:
$(echo "$stray" | sed 's/^/    /')
    rebase intake onto $PUBLIC_BRANCH (git rebase --onto $PUBLIC_BRANCH ... $branch) first"
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

  # Public first, then main.
  #
  # Into public-main this is an honest merge: the branch forked from there,
  # so it differs by exactly this song's commits.
  #
  # Into main it CANNOT be a merge. The branch's merge base with main is
  # public-main's own ancient base (db622afa), so merging it replays every
  # file public-main and main disagree about - ~1700 of them, including the
  # 1400+ assets each branch keeps in a different directory for a different
  # host. That is the wholesale cross-branch merge the protocol forbids.
  # Take just this song's files instead.
  #
  # So the file-copy did not disappear in the reversal, it moved: it used to
  # guard the public side and now guards the private one. The direction that
  # gets a real merge is whichever branch the intake fork came from.
  if [ "$want_public" = "1" ]; then
    git -C "$REPO" checkout -q "$PUBLIC_BRANCH" || die "could not switch to $PUBLIC_BRANCH"
    if ! git -C "$REPO" merge --no-ff -q -m "Add song \"$song\"" "$branch"; then
      git -C "$REPO" merge --abort 2>/dev/null
      git -C "$REPO" checkout -q "$MAIN_BRANCH"
      die "merge into $PUBLIC_BRANCH failed"
    fi
    # Post-condition: this merge must not have put a copyright field on
    # public-main. Belt-and-suspenders against a mislabelled song or a
    # stray file, checked against the real tree after merging. On failure
    # roll the branch back to where it was rather than leaving it dirty.
    if git -C "$REPO" grep -qE 'copyright\s*=' -- 'lilypond/songs/**/*.ly'; then
      git -C "$REPO" reset -q --hard HEAD~1
      git -C "$REPO" checkout -q "$MAIN_BRANCH"
      die "aborted: publishing $song would put a copyright field on $PUBLIC_BRANCH"
    fi
    echo "${c_grn}merged${c_off}   $branch -> $PUBLIC_BRANCH"
  fi

  git -C "$REPO" checkout -q "$MAIN_BRANCH" || die "could not switch to $MAIN_BRANCH"
  if ! git -C "$REPO" checkout "$branch" -- "lilypond/songs/$song" 2>/dev/null; then
    die "could not take lilypond/songs/$song from $branch"
  fi
  git -C "$REPO" add "lilypond/songs/$song" || die "git add failed"
  if git -C "$REPO" diff --cached --quiet; then
    note "$song is already on $MAIN_BRANCH and unchanged"
  else
    git -C "$REPO" commit -q -m "Add song \"$song\" ($status)" \
      || die "commit into $MAIN_BRANCH failed"
    echo "${c_grn}added${c_off}    $song -> $MAIN_BRANCH ${c_dim}(files only, no merge)${c_off}"
  fi

  if [ "$want_public" != "1" ]; then
    [ "$status" = "public-domain" ] \
      && note "public-domain: pass --public to also promote to $PUBLIC_BRANCH"
    echo
    assets_warning "$song"
    toolchain_warning
    note "not pushed - review, then: git push origin $MAIN_BRANCH"
    return 0
  fi

  echo
  assets_warning "$song"
  toolchain_warning
  note "not pushed. the song is on both branches, and each builds its"
  note "assets separately, so stage 5 runs once per branch:"
  note "  git checkout $PUBLIC_BRANCH && scripts/republish-all.sh"
  note "  git push public-origin $PUBLIC_BRANCH:main"
  note "  git checkout $MAIN_BRANCH && scripts/republish-all.sh"
  note "  git push origin $MAIN_BRANCH"
}

# Report the cross-branch invariants instead of asserting them in prose.
#
# The protocol doc used to carry these as literal counts ("main has 146
# songs, public-main 127, 12 copyrighted"). Counts in prose rot: by the
# time they read 177/140/30 the reader cannot tell a real leak from a
# stale sentence, which is the one distinction that matters here. So the
# doc points at this command and the numbers are derived on the spot.
#
# What is actually invariant is the LAST line: no .ly on the public branch
# may carry a copyright field. The counts are context, not the assertion.
cmd_check() {
  local main_songs public_songs main_copy
  main_songs="$(git -C "$REPO" ls-tree -d --name-only "$MAIN_BRANCH" \
                  -- lilypond/songs/ 2>/dev/null | wc -l)"
  public_songs="$(git -C "$REPO" ls-tree -d --name-only "$PUBLIC_BRANCH" \
                  -- lilypond/songs/ 2>/dev/null | wc -l)"

  # -z, because ls-tree quotes names containing non-ASCII bytes and an
  # unquoted read then skips accented titles silently.
  main_copy=0
  while IFS= read -r -d '' f; do
    case "$f" in *.ly) ;; *) continue ;; esac
    git -C "$REPO" show "$MAIN_BRANCH:$f" 2>/dev/null \
      | grep -qE '^[^%]*copyright[[:space:]]*=' && main_copy=$((main_copy + 1))
  done < <(git -C "$REPO" ls-tree -r -z --name-only "$MAIN_BRANCH" \
             -- lilypond/songs 2>/dev/null)

  echo "${c_bold}songs${c_off}"
  note "  $MAIN_BRANCH: $main_songs ($main_copy carrying a copyright field)"
  note "  $PUBLIC_BRANCH: $public_songs"
  echo

  echo "${c_bold}toolchain${c_off}"
  if toolchain_warning; then
    note "  shared scripts identical on both branches"
    echo
  fi

  echo "${c_bold}public branch copyright${c_off}"
  local offenders; offenders="$(public_branch_clean)"
  if [ -n "$offenders" ]; then
    echo "${c_red}LEAK${c_off} $PUBLIC_BRANCH carries a copyright field:"
    for f in $offenders; do echo "  $f"; done
    return 1
  fi
  echo "${c_grn}clean${c_off} no copyright field on $PUBLIC_BRANCH"
}

case "${1:-help}" in
  check)      cmd_check ;;
  start)      [ $# -ge 2 ] || die "usage: start <song>";      cmd_start "$2" ;;
  transcribe) [ $# -ge 2 ] || die "usage: transcribe <song>"; cmd_transcribe "$2" ;;
  review)     [ $# -ge 2 ] || die "usage: review <song>";     cmd_review "$2" ;;
  listen)     [ $# -ge 2 ] || die "usage: listen <song>";     cmd_listen "$2" ;;
  publish)    [ $# -ge 2 ] || die "usage: publish <song> [--public]";
              song="$2"; shift 2; cmd_publish "$song" "$@" ;;
  *)          sed -n '2,17p' "${BASH_SOURCE[0]}" | sed 's/^# \?//' ;;
esac
