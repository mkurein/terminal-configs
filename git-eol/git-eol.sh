#!/usr/bin/env bash
# git-eol — единые окончания строк в git-репо (macOS / Linux / WSL / Git Bash).
#
#   git-eol              блок в .gitattributes + renormalize индекса + освежить рабочую копию
#   git-eol --commit     то же + коммит (push не делает: дальше github-push)
#   git-eol --check      только проверить, ничего не менять (exit 1 при проблемах)
#   git-eol --scan [DIR] проверить все репо в DIR (по умолчанию ~/Project)
#   git-eol --force      не требовать чистого дерева (unstaged правки попадут в индекс!)
#
# В индексе всегда LF; *.bat/*.cmd/*.ps1/*.reg/*.iss — CRLF в рабочей копии.
# Шаблон правил: gitattributes.template рядом со скриптом. Совместим с bash 3.2.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/gitattributes.template"
BEGIN_MARK='# >>> git-eol >>>'
END_MARK='# <<< git-eol <<<'
COMMIT_MSG='Normalize line endings via .gitattributes'

TMP_FILES=()
cleanup() { [ ${#TMP_FILES[@]} -gt 0 ] && rm -f "${TMP_FILES[@]}"; return 0; }
trap cleanup EXIT

new_tmp() {
  local f
  f="$(mktemp)"
  TMP_FILES+=("$f")
  printf '%s' "$f"
}

usage() { sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; }
die() { echo "git-eol: $*" >&2; exit 1; }

go_to_repo_root() {
  local top
  top="$(git rev-parse --show-toplevel 2>/dev/null)" || die "не git-репозиторий (cwd: $(pwd))"
  cd "$top"
}

count_nul() { tr -cd '\000' <"$1" | wc -c | tr -d ' '; }

print_paths() { tr '\0' '\n' <"$1" | awk 'NR<=20 {print "    " $0} NR==21 {print "    …"}'; }

has_block() {
  [ -f .gitattributes ] && grep -qF "$BEGIN_MARK" .gitattributes && grep -qF "$END_MARK" .gitattributes
}

# Each tracked text file: <mode> <path>\0, mode = index|worktree.
# index:    committed with CRLF/mixed — needs `git add --renormalize`.
# worktree: checkout EOL differs from attributes — needs rm + checkout.
scan_mismatches() {
  local index_out="$1" worktree_out="$2" entry meta path ifield wfield attrs
  : >"$index_out"
  : >"$worktree_out"
  while IFS= read -r -d '' entry; do
    meta="${entry%%$'\t'*}"
    path="${entry#*$'\t'}"
    read -r ifield wfield attrs <<<"$meta"
    case "$attrs" in *-text*) continue ;; esac
    case "$ifield" in i/crlf|i/mixed) printf '%s\0' "$path" >>"$index_out" ;; esac
    case "$attrs" in *text*) ;; *) continue ;; esac
    [ -L "$path" ] && continue
    [ -f "$path" ] || continue
    case "$attrs" in
      *eol=crlf*) case "$wfield" in w/lf|w/mixed) printf '%s\0' "$path" >>"$worktree_out" ;; esac ;;
      *)          case "$wfield" in w/crlf|w/mixed) printf '%s\0' "$path" >>"$worktree_out" ;; esac ;;
    esac
  done < <(git ls-files --eol -z)
}

# Returns 0 if .gitattributes changed.
write_block() {
  local tmp
  tmp="$(new_tmp)"
  if has_block; then
    tr -d '\r' <.gitattributes | awk -v b="$BEGIN_MARK" -v e="$END_MARK" -v tpl="$TEMPLATE" '
      $0 == b { while ((getline line < tpl) > 0) { sub(/\r$/, "", line); print line }; skip = 1; next }
      $0 == e { skip = 0; next }
      !skip { print }' >"$tmp"
  else
    tr -d '\r' <"$TEMPLATE" >"$tmp"
    if [ -s .gitattributes ]; then
      printf '\n' >>"$tmp"
      tr -d '\r' <.gitattributes >>"$tmp"
    fi
  fi
  if [ -f .gitattributes ] && cmp -s "$tmp" .gitattributes; then
    return 1
  fi
  cat "$tmp" >.gitattributes
  return 0
}

require_clean() {
  local dirty
  dirty="$(git status --porcelain --untracked-files=no -- . ':(exclude).gitattributes')"
  if [ -n "$dirty" ]; then
    echo "$dirty" >&2
    die "есть незакоммиченные изменения. Сначала commit/stash (или --force: unstaged правки попадут в индекс)."
  fi
}

refresh_worktree() {
  local list="$1"
  xargs -0 rm -f -- <"$list"
  if ! git checkout --pathspec-from-file="$list" --pathspec-file-nul; then
    echo "git-eol: checkout не прошёл. Файлы целы в индексе, восстановить: git checkout -- ." >&2
    exit 1
  fi
}

cmd_check() {
  local quiet="${1:-0}" idx wt n_idx n_wt problems=0
  go_to_repo_root
  idx="$(new_tmp)"
  wt="$(new_tmp)"
  scan_mismatches "$idx" "$wt"
  n_idx="$(count_nul "$idx")"
  n_wt="$(count_nul "$wt")"
  has_block || problems=1
  [ "$n_idx" -eq 0 ] || problems=1
  [ "$n_wt" -eq 0 ] || problems=1

  if [ "$quiet" = 1 ]; then
    if [ "$problems" -eq 0 ]; then
      echo "OK"
    else
      local block="да"
      has_block || block="нет"
      echo "FIX   блок:$block  индекс:$n_idx  рабочая-копия:$n_wt"
    fi
    return "$problems"
  fi

  echo "Репо: $(pwd)"
  if has_block; then echo "✓ блок git-eol в .gitattributes есть"; else echo "✗ блока git-eol в .gitattributes нет"; fi
  if [ "$n_idx" -eq 0 ]; then
    echo "✓ индекс: все текстовые файлы с LF"
  else
    echo "✗ индекс: $n_idx файл(ов) закоммичены с CRLF/mixed"
    print_paths "$idx"
  fi
  if [ "$n_wt" -eq 0 ]; then
    echo "✓ рабочая копия совпадает с правилами"
  else
    echo "✗ рабочая копия: $n_wt файл(ов) с неверными окончаниями"
    print_paths "$wt"
  fi
  [ "$problems" -eq 0 ] || echo "Исправить: git-eol   (или git-eol --commit)"
  return "$problems"
}

cmd_apply() {
  local force="$1" do_commit="$2" idx wt n_wt
  go_to_repo_root
  [ -f "$TEMPLATE" ] || die "нет шаблона: $TEMPLATE"
  [ "$force" = 1 ] || require_clean

  if write_block; then
    echo "✓ .gitattributes: блок git-eol записан"
  else
    echo "• .gitattributes: блок уже актуален"
  fi

  git add -- .gitattributes
  git add --renormalize -- .

  idx="$(new_tmp)"
  wt="$(new_tmp)"
  scan_mismatches "$idx" "$wt"
  n_wt="$(count_nul "$wt")"
  if [ "$n_wt" -gt 0 ]; then
    echo "• освежаю рабочую копию: $n_wt файл(ов)"
    refresh_worktree "$wt"
  fi

  if git diff --cached --quiet; then
    echo "✓ коммитить нечего: репо уже нормализовано"
  else
    echo ""
    git --no-pager diff --cached --stat | tail -n 15
    if [ "$do_commit" = 1 ]; then
      git commit -m "$COMMIT_MSG"
      echo "✓ закоммичено. Push: github-push"
    else
      echo ""
      echo "Изменения в индексе. Дальше:"
      echo "  git-eol --commit      или   github-commit \"$COMMIT_MSG\""
      echo "  github-push"
    fi
  fi

  echo ""
  cmd_check || true
}

find_repos() {
  local dir="$1" depth="$2" sub
  if [ -e "$dir/.git" ]; then
    printf '%s\n' "$dir"
    return 0
  fi
  [ "$depth" -gt 0 ] || return 0
  for sub in "$dir"/*/; do
    [ -d "$sub" ] || continue
    sub="${sub%/}"
    case "${sub##*/}" in node_modules|.*) continue ;; esac
    find_repos "$sub" $((depth - 1))
  done
}

cmd_scan() {
  local root="${1:-$HOME/Project}" repo result
  [ -d "$root" ] || die "нет каталога: $root"
  root="$(cd "$root" && pwd)"
  echo "Сканирую $root (глубина 3)…"
  find_repos "$root" 3 | while IFS= read -r repo; do
    result="$( (cd "$repo" && bash "$SCRIPT_DIR/git-eol.sh" --check-quiet) 2>/dev/null || true)"
    [ -n "$result" ] || result="ERR"
    printf '%-60s %s\n' "${repo#"$root"/}" "$result"
  done
  echo ""
  echo "Исправить репо: cd <repo> && git-eol --commit && github-push"
}

main() {
  local mode=apply force=0 do_commit=0 scan_dir=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --check)  mode=check ;;
      --check-quiet) mode=check_quiet ;;
      --commit) do_commit=1 ;;
      --force)  force=1 ;;
      --scan)
        mode=scan
        if [ $# -gt 1 ] && [ "${2#-}" = "$2" ]; then scan_dir="$2"; shift; fi
        ;;
      -h|--help|help) usage; exit 0 ;;
      *) usage >&2; die "неизвестный аргумент: $1" ;;
    esac
    shift
  done

  case "$mode" in
    check) cmd_check 0 ;;
    check_quiet) cmd_check 1 ;;
    scan)  cmd_scan "$scan_dir" ;;
    apply) cmd_apply "$force" "$do_commit" ;;
  esac
}

main "$@"
