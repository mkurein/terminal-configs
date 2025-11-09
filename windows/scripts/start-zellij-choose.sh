#!/bin/bash

# Если уже в zellij - выходим
if [[ -n "$ZELLIJ" ]]; then
    exit 0
fi

echo "Выберите workspace layout:"
echo "1) workspacePrjSnabjenie (40% лево / 60% право) - новый"
echo "2) my-workspace (50% / 50%) - старый"
echo "3) Запустить без layout"
echo ""
read -p "Ваш выбор (1-3): " choice

case $choice in
    1)
        echo "Запускаю workspacePrjSnabjenie..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspacePrjSnabjenie.kdl"
        ;;
    2)
        echo "Запускаю my-workspace..."
        exec zellij --layout "$HOME/.config/zellij/layouts/my-workspace.kdl"
        ;;
    3)
        echo "Запускаю без layout..."
        exec zellij
        ;;
    *)
        echo "Неверный выбор, запускаю workspacePrjSnabjenie по умолчанию..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspacePrjSnabjenie.kdl"
        ;;
esac

