# Source from zsh/bash aliases so github-fetch and friends work in any repo.
# Sets GITHUB_PROXY_HOME to this directory unless it is already set.
#
# command not found: github-… — не PATH. В этой сессии:
#   source ~/.zshrc
#   source "$HOME/Project/terminal-configs/github-proxy/env.sh"
# Windows: . $PROFILE
# напрямую: "$HOME/Project/terminal-configs/github-proxy/github-commit.sh" "msg"

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
github_commit() { "$GITHUB_PROXY_HOME/github-commit.sh" "$@"; }
github_push() { "$GITHUB_PROXY_HOME/github-push.sh" "$@"; }
github_gh() { "$GITHUB_PROXY_HOME/github-gh.sh" "$@"; }

alias github-fetch=github_fetch
alias github-pull=github_pull
alias github-commit=github_commit
alias github-push=github_push
alias github-gh=github_gh

github_help() {
  echo "github-* — aliases from env.sh, not PATH."
  echo "  github-fetch / github-pull / github-commit / github-push / github-gh"
  echo ""
  echo "command not found — reload this shell:"
  echo "  source ~/.zshrc"
  echo "  source \"\$HOME/Project/terminal-configs/github-proxy/env.sh\""
  echo "Windows: . \$PROFILE"
  echo "Direct: \"\$HOME/Project/terminal-configs/github-proxy/github-commit.sh\" \"msg\""
}
alias github-help=github_help
