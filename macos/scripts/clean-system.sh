#!/bin/bash

# 🧹 Clean System - очистка и обслуживание системы macOS

echo "🧹 Очистка системы macOS..."
echo ""

# Подсчет освобожденного места
get_disk_usage() {
    df -h / | awk 'NR==2 {print $3}'
}

BEFORE=$(get_disk_usage)

# Homebrew cache
if command -v brew &> /dev/null; then
    echo "🍺 Очистка Homebrew..."
    brew cleanup -s
    brew autoremove
    rm -rf "$(brew --cache)"
    echo "✓ Homebrew очищен"
fi

# Cargo cache (если установлен Rust)
if command -v cargo &> /dev/null; then
    echo ""
    echo "🦀 Очистка Cargo кеша..."
    cargo cache -a 2>/dev/null || echo "⊘ cargo-cache не установлен (cargo install cargo-cache)"
fi

# npm cache (если установлен Node.js)
if command -v npm &> /dev/null; then
    echo ""
    echo "📦 Очистка npm кеша..."
    npm cache clean --force
    echo "✓ npm кеш очищен"
fi

# Yarn cache
if command -v yarn &> /dev/null; then
    echo ""
    echo "📦 Очистка Yarn кеша..."
    yarn cache clean
    echo "✓ Yarn кеш очищен"
fi

# Python pip cache
if command -v pip3 &> /dev/null; then
    echo ""
    echo "🐍 Очистка pip кеша..."
    pip3 cache purge 2>/dev/null || echo "⊘ pip cache недоступен"
fi

# Neovim
echo ""
echo "💻 Очистка Neovim..."
rm -rf "$HOME/.local/share/nvim/swap" 2>/dev/null
rm -rf "$HOME/.local/share/nvim/backup" 2>/dev/null
rm -rf "$HOME/.cache/nvim" 2>/dev/null
echo "✓ Neovim кеш очищен"

# Zellij old sessions
echo ""
echo "🖥️  Очистка старых сессий Zellij..."
find "$HOME/Library/Application Support/org.Zellij-Contributors.Zellij" -name "*.kdl" -mtime +7 -delete 2>/dev/null
find "$HOME/.cache/zellij" -name "*.kdl" -mtime +7 -delete 2>/dev/null
echo "✓ Старые сессии удалены"

# macOS specific - system caches
echo ""
echo "🍎 Очистка системных кешей macOS..."
rm -rf ~/Library/Caches/* 2>/dev/null
rm -rf ~/Library/Logs/* 2>/dev/null
echo "✓ Системные кеши очищены"

# Xcode derived data (если установлен)
if [[ -d "$HOME/Library/Developer/Xcode/DerivedData" ]]; then
    echo ""
    echo "🔨 Очистка Xcode DerivedData..."
    rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
    echo "✓ Xcode DerivedData очищен"
fi

# Docker (если установлен)
if command -v docker &> /dev/null; then
    echo ""
    echo "🐳 Очистка Docker..."
    read -p "Очистить неиспользуемые Docker образы и контейнеры? [y/N]: " docker_clean
    if [[ "$docker_clean" == "y" ]]; then
        docker system prune -af --volumes
        echo "✓ Docker очищен"
    fi
fi

# Empty Trash
echo ""
read -p "🗑️  Очистить Корзину? [y/N]: " empty_trash
if [[ "$empty_trash" == "y" ]]; then
    rm -rf ~/.Trash/*
    echo "✓ Корзина очищена"
fi

AFTER=$(get_disk_usage)

echo ""
echo "════════════════════════════════════"
echo "✓ Очистка завершена!"
echo "📊 Использовано: $BEFORE → $AFTER"
echo "════════════════════════════════════"
echo ""
echo "💡 Дополнительно:"
echo "  • Перезагрузите Mac для освобождения RAM"
echo "  • Проверьте: System Settings → Storage"

