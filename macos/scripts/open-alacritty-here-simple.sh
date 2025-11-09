#!/bin/bash

# 🚀 Open Alacritty Here (Simple) - упрощенная версия
# Запускает новое окно Alacritty в текущей папке

TARGET_DIR="${1:-$(pwd)}"
ABSOLUTE_PATH=$(cd "$TARGET_DIR" 2>/dev/null && pwd || pwd)

# Запуск Alacritty с указанной рабочей директорией
open -na Alacritty --args --working-directory "$ABSOLUTE_PATH"

