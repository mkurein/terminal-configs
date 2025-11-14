#!/bin/bash

# Инициализируем Homebrew (для доступа к утилитам типа htop)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Добавляем cargo bin в PATH для Zellij
export PATH="$HOME/.cargo/bin:$PATH"

# Если уже в zellij - выходим
if [[ -n "$ZELLIJ" ]]; then
    exit 0
fi

echo "Выберите workspace layout:"
echo "1) workspaceVPNmanage (40% лево / 60% право) - для VPNserverManage"
echo "2) workspaceVPNmanage-5050 (50% / 50%) - для VPNserverManage"
echo "3) Запустить без layout"
echo ""
read -p "Ваш выбор (1-3): " choice

case $choice in
    1)
        echo "Запускаю workspaceVPNmanage..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage.kdl"
        ;;
    2)
        echo "Запускаю workspaceVPNmanage-5050..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage-5050.kdl"
        ;;
    3)
        echo "Запускаю без layout..."
        exec zellij
        ;;
    *)
        echo "Неверный выбор, запускаю workspaceVPNmanage по умолчанию..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage.kdl"
        ;;
esac
