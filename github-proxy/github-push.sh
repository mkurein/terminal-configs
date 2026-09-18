#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=_lib.sh
. "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

github_proxy_require_git
github_proxy_clear

echo "Proxy variables cleared for this terminal session."
echo "Running: git -c http.proxy= -c https.proxy= push -u origin HEAD"

git -c http.proxy= -c https.proxy= push -u origin HEAD "$@"
