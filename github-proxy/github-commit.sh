#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=_lib.sh
. "$(cd "$(dirname "$0")" && pwd)/_lib.sh"

github_proxy_require_git
github_proxy_clear

echo "Proxy variables cleared for this terminal session."

msg="$*"
if [[ -z "${msg// }" ]]; then
  read -r -p "Commit message: " msg
fi
if [[ -z "${msg// }" ]]; then
  echo "Commit message cannot be empty." >&2
  exit 1
fi

if git diff --cached --quiet; then
  echo "Nothing staged. git add first, then github-commit." >&2
  exit 1
fi

echo "Running: git commit -m ..."
git commit -m "$msg"
