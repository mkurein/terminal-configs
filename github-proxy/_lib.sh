# Shared helpers for github-proxy/*.sh. Sourced from those scripts; do not run directly.

github_proxy_clear() {
  unset HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY http_proxy https_proxy all_proxy no_proxy || true
}

github_proxy_require_git() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repository (cwd: $(pwd))" >&2
    exit 1
  fi
}
