#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=_lib.sh
. "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

github_proxy_require_git
github_proxy_clear

echo "Proxy variables cleared for this terminal session."

if [[ $# -eq 0 ]]; then
  echo "Running: git -c http.proxy= -c https.proxy= fetch --all"
  git -c http.proxy= -c https.proxy= fetch --all
else
  echo "Running: git -c http.proxy= -c https.proxy= fetch $*"
  git -c http.proxy= -c https.proxy= fetch "$@"
fi
