#!/bin/bash

# Инициализируем Homebrew (для доступа к утилитам типа htop)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Добавляем cargo bin в PATH для Zellij
export PATH="$HOME/.cargo/bin:$PATH"

# Если уже в zellij - выходим
if [[ -n "$ZELLIJ" ]]; then
    exit 0
fi

# Запускаем workspace VPNserverManage (40/60)
exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage.kdl"
