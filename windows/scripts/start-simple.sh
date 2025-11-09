#!/bin/bash

# Если уже в zellij - выходим
if [[ -n "$ZELLIJ" ]]; then
    exit 0
fi

# Просто запускаем с layout, без именованной сессии
exec zellij --layout "$HOME/.config/zellij/layouts/my-workspace.kdl"

