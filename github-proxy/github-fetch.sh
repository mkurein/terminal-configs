#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=_lib.sh
. "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

github_proxy_require_git
github_proxy_clear

echo "Proxy variables cleared for this terminal session."

if [[ $# -eq 0 ]]; then
  echo "Running: git fetch for each remote (skip missing/unreachable)"
  skipped=0
  while IFS= read -r remote; do
    [[ -z "$remote" ]] && continue
    echo "Fetching $remote"
    if git -c http.proxy= -c https.proxy= fetch "$remote"; then
      continue
    fi
    echo "warning: skip remote '$remote' (not found or unreachable)" >&2
    skipped=1
  done < <(git remote)
  if [[ "$skipped" -eq 1 ]]; then
    echo "Fetch finished; at least one remote was skipped." >&2
  fi
else
  echo "Running: git -c http.proxy= -c https.proxy= fetch $*"
  git -c http.proxy= -c https.proxy= fetch "$@"
fi
