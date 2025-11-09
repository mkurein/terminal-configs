#!/bin/bash

# 🔄 Sync Dotfiles - синхронизация конфигов с репозиторием
# Использование: sync-dotfiles.sh [push|pull]

REPO_PATH="$HOME/terminal-configs"
ACTION="${1:-menu}"

sync_to_repo() {
    echo "📤 Синхронизация конфигов В репозиторий..."
    
    # Alacritty
    cp "$HOME/.config/alacritty/alacritty.toml" "$REPO_PATH/macos/alacritty/" 2>/dev/null
    echo "✓ Alacritty config"
    
    # Zellij
    cp "$HOME/.config/zellij/config.kdl" "$REPO_PATH/macos/zellij/" 2>/dev/null
    cp "$HOME/.config/zellij/layouts/"*.kdl "$REPO_PATH/macos/zellij/layouts/" 2>/dev/null
    echo "✓ Zellij configs"
    
    # Zsh
    cp "$HOME/.config/zsh/aliases.zsh" "$REPO_PATH/macos/zsh/" 2>/dev/null
    echo "✓ Zsh aliases"
    
    # Scripts
    cp "$HOME"/*.sh "$REPO_PATH/macos/scripts/" 2>/dev/null
    echo "✓ Scripts"
    
    echo ""
    echo "✓ Синхронизация завершена!"
    echo "📝 Не забудьте: cd $REPO_PATH && git add . && git commit && git push"
}

sync_from_repo() {
    echo "📥 Синхронизация конфигов ИЗ репозитория..."
    
    if [[ ! -d "$REPO_PATH" ]]; then
        echo "✗ Репозиторий не найден: $REPO_PATH"
        exit 1
    fi
    
    cd "$REPO_PATH" || exit
    git pull
    
    cd macos || exit
    ./install.sh
    
    echo "✓ Синхронизация завершена!"
}

case $ACTION in
    push)
        sync_to_repo
        ;;
    pull)
        sync_from_repo
        ;;
    menu)
        echo "🔄 Sync Dotfiles"
        echo ""
        echo "1) Push - сохранить текущие конфиги в репозиторий"
        echo "2) Pull - загрузить конфиги из репозитория"
        echo ""
        read -p "Ваш выбор (1-2): " choice
        
        case $choice in
            1) sync_to_repo ;;
            2) sync_from_repo ;;
            *) echo "✗ Неверный выбор"; exit 1 ;;
        esac
        ;;
    *)
        echo "Использование: sync-dotfiles.sh [push|pull]"
        exit 1
        ;;
esac

