#!/bin/bash

# 🚀 Project Switcher - быстрый переход между проектами
# Использование: ps или project-switcher.sh

# Определите ваши основные проекты здесь
PROJECTS=(
    "$HOME/Project/ProjectPython/VPNserverManage-Clean:VPNserverManage"
    "$HOME/Projects:Home Projects"
    "$HOME/.config:Config"
    "$HOME/Downloads:Downloads"
)

echo "📁 Выберите проект:"
echo ""

index=1
for project in "${PROJECTS[@]}"; do
    path="${project%%:*}"
    name="${project##*:}"
    echo "$index) $name ($path)"
    ((index++))
done

echo ""
read -p "Ваш выбор (1-${#PROJECTS[@]}): " choice

if [[ $choice -ge 1 && $choice -le ${#PROJECTS[@]} ]]; then
    selected="${PROJECTS[$((choice-1))]}"
    path="${selected%%:*}"
    name="${selected##*:}"
    
    if [[ -d "$path" ]]; then
        echo "✓ Переход в: $name"
        cd "$path" || exit
        
        # Спросить, запустить ли Neovim
        read -p "Открыть Neovim? (y/n): " open_nvim
        if [[ "$open_nvim" == "y" ]]; then
            nvim .
        else
            exec zsh
        fi
    else
        echo "✗ Папка не найдена: $path"
        exit 1
    fi
else
    echo "✗ Неверный выбор"
    exit 1
fi

