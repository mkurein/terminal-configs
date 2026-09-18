# Source from zsh/bash aliases so github-fetch and friends work in any repo.
# Sets GITHUB_PROXY_HOME to this directory unless it is already set.

if [ -n "${BASH_VERSION:-}" ]; then
  _github_proxy_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "${ZSH_VERSION:-}" ]; then
  _github_proxy_dir="$(cd "$(dirname "${(%):-%x}")" && pwd)"
else
  _github_proxy_dir="$(cd "$(dirname "$0")" && pwd)"
fi

: "${GITHUB_PROXY_HOME:=$_github_proxy_dir}"
export GITHUB_PROXY_HOME
unset _github_proxy_dir

github_fetch() { "$GITHUB_PROXY_HOME/github-fetch.sh" "$@"; }
github_pull() { "$GITHUB_PROXY_HOME/github-pull.sh" "$@"; }
github_push() { "$GITHUB_PROXY_HOME/github-push.sh" "$@"; }
github_gh() { "$GITHUB_PROXY_HOME/github-gh.sh" "$@"; }

alias github-fetch=github_fetch
alias github-pull=github_pull
alias github-push=github_push
alias github-gh=github_gh
