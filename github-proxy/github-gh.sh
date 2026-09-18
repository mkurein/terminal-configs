#!/usr/bin/env bash
# command not found: github-gh — не PATH.  source ~/.zshrc
# или: source "$HOME/Project/terminal-configs/github-proxy/env.sh"
# напрямую: "$HOME/Project/terminal-configs/github-proxy/github-gh.sh"
# Windows: . $PROFILE
set -euo pipefail
# shellcheck source=_lib.sh
. "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

github_proxy_require_git
github_proxy_clear

if ! command -v gh >/dev/null 2>&1; then
  echo "gh не найден. Установите GitHub CLI: https://cli.github.com/"
  echo "macOS: brew install gh"
  exit 1
fi

echo "Proxy variables cleared for this terminal session."

while true; do
  echo
  echo "=== GitHub CLI (gh) ==="
  echo " 1) gh auth status"
  echo " 2) gh auth login"
  echo " 3) gh auth refresh (scope: workflow)"
  echo " 4) gh auth refresh (scope: workflow + repo)"
  echo " 5) gh repo view (открыть в браузере)"
  echo " 6) gh pr list"
  echo " 7) gh pr create"
  echo " 8) gh run list (последние 5)"
  echo " 9) gh run watch (последний run)"
  echo " 0) выход"
  echo
  read -r -p "Выберите пункт: " choice

  case "$choice" in
    1) gh auth status ;;
    2) gh auth login ;;
    3) gh auth refresh -h github.com -s workflow ;;
    4) gh auth refresh -h github.com -s workflow -s repo ;;
    5) gh repo view --web ;;
    6) gh pr list ;;
    7)
      read -r -p "Заголовок PR: " title
      if [[ -z "${title// }" ]]; then
        echo "Заголовок не может быть пустым."
        continue
      fi
      read -r -p "Описание PR (можно Enter для пустого): " body
      if [[ -z "$body" ]]; then
        gh pr create --title "$title"
      else
        gh pr create --title "$title" --body "$body"
      fi
      ;;
    8) gh run list --limit 5 ;;
    9) gh run watch ;;
    0)
      echo "Выход."
      break
      ;;
    *)
      echo "Неизвестный пункт: $choice"
      ;;
  esac
done
