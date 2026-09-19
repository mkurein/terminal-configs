#!/usr/bin/env bash
# command not found: github-commit — не PATH.  source ~/.zshrc
# или: source "$HOME/Project/terminal-configs/github-proxy/env.sh"
# напрямую: "$HOME/Project/terminal-configs/github-proxy/github-commit.sh" "msg"
# Windows: . $PROFILE
set -euo pipefail
# shellcheck source=_lib.sh
. "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

github_proxy_require_git
github_proxy_clear

echo "Proxy variables cleared for this terminal session."

if git diff --cached --quiet; then
  echo "Nothing staged. git add first, then github-commit." >&2
  exit 1
fi

if [[ "${1:-}" == "-e" || "${1:-}" == "--edit" ]]; then
  echo "Running: git commit  (editor)"
  git commit
  exit 0
fi

msg=""
if [[ $# -gt 0 ]]; then
  msg="$*"
else
  if [[ -t 0 ]]; then
    echo ""
    echo "Сообщение коммита. Проще всего: одна строка темы, потом Ctrl-D."
    echo "Пустая строка не нужна. Она только если после темы хотите абзац."
    echo "Пишите здесь, не в приглашении zsh. Отмена: Ctrl-C. Редактор: github-commit -e"
    echo "Или сразу: github-commit \"тема в кавычках\""
    echo ""
  fi
  msg=$(cat)
fi
msg="${msg%"${msg##*[![:space:]]}"}"
if [[ -z "$msg" ]]; then
  echo "Commit message cannot be empty." >&2
  exit 1
fi

echo "Running: git commit -F -"
git commit -F - <<<"$msg"
