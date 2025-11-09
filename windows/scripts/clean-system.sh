#!/bin/bash

# 🧹 Clean System - очистка и обслуживание системы WSL

echo "🧹 Очистка системы WSL..."
echo ""

# Подсчет освобожденного места
get_disk_usage() {
    df -h / | awk 'NR==2 {print $3}'
}

BEFORE=$(get_disk_usage)

# APT cache
echo "📦 Очистка APT кеша..."
sudo apt autoremove -y
sudo apt clean
sudo apt autoclean
echo "✓ APT очищен"

# Cargo cache (если установлен Rust)
if command -v cargo &> /dev/null; then
    echo ""
    echo "🦀 Очистка Cargo кеша..."
    cargo cache -a || echo "⊘ cargo-cache не установлен (cargo install cargo-cache)"
fi

# npm cache (если установлен Node.js)
if command -v npm &> /dev/null; then
    echo ""
    echo "📦 Очистка npm кеша..."
    npm cache clean --force
    echo "✓ npm кеш очищен"
fi

# Neovim
echo ""
echo "💻 Очистка Neovim..."
rm -rf "$HOME/.local/share/nvim/swap"
rm -rf "$HOME/.local/share/nvim/backup"
rm -rf "$HOME/.cache/nvim"
echo "✓ Neovim кеш очищен"

# Zellij old sessions
echo ""
echo "🖥️  Очистка старых сессий Zellij..."
find "$HOME/.cache/zellij" -name "*.kdl" -mtime +7 -delete 2>/dev/null
echo "✓ Старые сессии удалены"

# Temporary files
echo ""
echo "🗑️  Очистка временных файлов..."
rm -rf /tmp/* 2>/dev/null
echo "✓ Временные файлы удалены"

# Old logs
echo ""
echo "📄 Очистка старых логов..."
find "$HOME/.local/share" -name "*.log" -mtime +30 -delete 2>/dev/null
find "$HOME/.cache" -name "*.log" -mtime +30 -delete 2>/dev/null
echo "✓ Старые логи удалены"

AFTER=$(get_disk_usage)

echo ""
echo "════════════════════════════════════"
echo "✓ Очистка завершена!"
echo "📊 Использовано: $BEFORE → $AFTER"
echo "════════════════════════════════════"

