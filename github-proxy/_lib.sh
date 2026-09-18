# Shared helpers for github-proxy/*.sh. Sourced from those scripts; do not run directly.
#
# command not found: github-… — алиас не в этой сессии (не PATH).
#   source ~/.zshrc
#   source "$HOME/Project/terminal-configs/github-proxy/env.sh"
# Напрямую: ~/Project/terminal-configs/github-proxy/github-commit.sh "msg"
# Windows:  . $PROFILE
#           cd C:\Project\terminal-configs\windows\powershell; .\install.ps1; . $PROFILE

github_proxy_load_hint() {
  local name="${1:-github-*}"
  echo ""
  echo "Command not found: $name — alias not loaded in this session (not PATH)." >&2
  echo "Fix (macOS):" >&2
  echo "  source ~/.zshrc" >&2
  echo "  source \"\$HOME/Project/terminal-configs/github-proxy/env.sh\"" >&2
  echo "Direct:" >&2
  echo "  \"\$HOME/Project/terminal-configs/github-proxy/${name}.sh\"" >&2
  echo "Windows:" >&2
  echo "  . \$PROFILE" >&2
  echo ""
}

github_proxy_clear() {
  unset HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY http_proxy https_proxy all_proxy no_proxy || true
}

github_proxy_require_git() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repository (cwd: $(pwd))" >&2
    exit 1
  fi
}
