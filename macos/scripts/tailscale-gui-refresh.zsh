#!/bin/zsh
# One GUI refresh per login, only after macOS reports the Tailscale VPN connected.
# No changes to VPN preferences, credentials, or exit-node selection.
/bin/sleep 30
for attempt in {1..60}; do
  if /usr/sbin/scutil --nc list | /usr/bin/grep -F '(Connected)' | /usr/bin/grep -Fq 'io.tailscale.ipn.macsys'; then
    if /usr/bin/pgrep -x Tailscale >/dev/null; then
      /usr/bin/pkill -TERM -x Tailscale
      for wait_step in {1..10}; do
        /usr/bin/pgrep -x Tailscale >/dev/null || break
        /bin/sleep 1
      done
      /usr/bin/open -g -a /Applications/Tailscale.app
    fi
    exit 0
  fi
  /bin/sleep 2
done
exit 0
