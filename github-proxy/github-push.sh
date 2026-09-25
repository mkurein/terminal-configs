#!/usr/bin/env bash
# command not found: github-push — не PATH.  source ~/.zshrc
# или: source "$HOME/Project/terminal-configs/github-proxy/env.sh"
# напрямую: "$HOME/Project/terminal-configs/github-proxy/github-push.sh"
# Windows: . $PROFILE
set -euo pipefail
# shellcheck source=_lib.sh
. "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

github_proxy_require_git
github_proxy_clear

echo "Proxy variables cleared for this terminal session."
echo "Running: git -c http.proxy= -c https.proxy= push -u origin HEAD"

if ! git -c http.proxy= -c https.proxy= push -u origin HEAD "$@"; then
  github_proxy_push_fail_hint
  exit 1
fi
