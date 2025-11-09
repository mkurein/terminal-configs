#!/bin/bash

# 🚀 Open Alacritty Here - открыть Alacritty в текущей папке
# Использование: open-alacritty-here.sh [путь]
# Если путь не указан, используется текущая директория

TARGET_DIR="${1:-$(pwd)}"

# Проверка существования директории
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "✗ Папка не найдена: $TARGET_DIR"
    exit 1
fi

# Получаем абсолютный путь
ABSOLUTE_PATH=$(cd "$TARGET_DIR" && pwd)

# Запускаем Alacritty в указанной папке
osascript <<EOF
tell application "Alacritty"
    do script "cd '$ABSOLUTE_PATH' && exec zsh"
    activate
end tell
EOF

