#!/bin/bash

# Если уже в zellij - выходим
if [[ -n "$ZELLIJ" ]]; then
    exit 0
fi

# Запускаем новый workspace ProjectSnabjenie (40/60)
exec zellij --layout "$HOME/.config/zellij/layouts/workspacePrjSnabjenie.kdl"

