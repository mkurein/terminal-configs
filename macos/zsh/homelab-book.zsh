# homelab-book aliases (macOS / zsh)

export PATH="${HOME}/.local/bin:${PATH}"

_hl_ts() {
  if [[ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ]]; then
    /Applications/Tailscale.app/Contents/MacOS/Tailscale "$@"
  elif [[ -x /usr/local/bin/tailscale ]]; then
    /usr/local/bin/tailscale "$@"
  elif command -v tailscale >/dev/null 2>&1; then
    command tailscale "$@"
  else
    print -P "%F{red}Tailscale CLI не найден%f"
    return 127
  fi
}

_hl_exit_ip() {
  local ip
  ip="$(curl -4 -s --max-time 10 https://api.ipify.org 2>/dev/null)" || true

  if [[ -n "$ip" ]]; then
    print -P "%F{white}Публичный IP: ${ip}%f"
  else
    print -P "%F{red}Не удалось определить публичный IP%f"
  fi
}

_hl_exit_home() {
  _hl_ts set \
    --exit-node=tnas \
    --exit-node-allow-lan-access=true \
    || _hl_ts set \
      --exit-node=100.64.0.12 \
      --exit-node-allow-lan-access=true

  print -P "%F{green}Exit node: tnas / 100.64.0.12%f"
  _hl_exit_ip
}

_hl_exit_vps() {
  _hl_ts set \
    --exit-node=vps45379 \
    --exit-node-allow-lan-access=true \
    || _hl_ts set \
      --exit-node=100.64.0.13 \
      --exit-node-allow-lan-access=true

  print -P "%F{cyan}Exit node: vps45379 / 100.64.0.13%f"
  _hl_exit_ip
}

_hl_exit_srv() {
  _hl_ts set \
    --exit-node=srv015890413 \
    --exit-node-allow-lan-access=true \
    || _hl_ts set \
      --exit-node=100.64.0.11 \
      --exit-node-allow-lan-access=true

  print -P "%F{magenta}Exit node: srv015890413 / 100.64.0.11%f"
  _hl_exit_ip
}

_hl_exit_off() {
  _hl_ts set --exit-node=
  print -P "%F{yellow}Exit node выключен%f"
  _hl_exit_ip
}

alias mesh-on='_hl_ts up'
alias mesh-off='_hl_ts down'
alias mesh-st='_hl_ts status'
alias mesh-lan='_hl_ts set --accept-routes=true'

alias exit-home='_hl_exit_home'
alias exit-vps='_hl_exit_vps'
alias exit-srv='_hl_exit_srv'
alias exit-off='_hl_exit_off'
alias exit-ip='_hl_exit_ip'

alias mesh-home='_hl_exit_home'
alias mesh-vps='_hl_exit_vps'
alias mesh-srv='_hl_exit_srv'
alias mesh-direct='_hl_exit_off'

hl-aliases() {
  cat <<'HELP'
Tailscale / homelab aliases:

  mesh-on       включить Tailscale
  mesh-off      выключить Tailscale
  mesh-st       статус Tailscale
  mesh-lan      принимать subnet routes

Exit nodes:
  exit-home     tnas          100.64.0.12
  exit-vps      vps45379      100.64.0.13
  exit-srv      srv015890413  100.64.0.11
  exit-off      отключить Exit Node
  exit-ip       показать публичный IP

Synonyms:
  mesh-home
  mesh-vps
  mesh-srv
  mesh-direct
HELP
}
