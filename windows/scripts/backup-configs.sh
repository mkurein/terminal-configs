#!/bin/bash

# 💾 Backup Configs - резервное копирование конфигураций
# Создает backup всех важных конфигов в ~/backups/

BACKUP_DIR="$HOME/backups/config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "💾 Создание резервной копии конфигураций..."
echo "📁 Папка: $BACKUP_DIR"
echo ""

# Функция для копирования с проверкой
backup_item() {
    local source=$1
    local name=$2
    
    if [[ -e "$source" ]]; then
        cp -r "$source" "$BACKUP_DIR/"
        echo "✓ $name"
    else
        echo "⊘ $name (не найдено)"
    fi
}

# Конфигурации
backup_item "$HOME/.config/nvim" "Neovim config"
backup_item "$HOME/.config/zellij" "Zellij config"
backup_item "$HOME/.config/zsh" "Zsh config"
backup_item "$HOME/.zshrc" ".zshrc"
backup_item "$HOME/.bashrc" ".bashrc"
backup_item "$HOME/.gitconfig" ".gitconfig"
backup_item "$HOME/.ssh/config" "SSH config"

# Скрипты
backup_item "$HOME/start-zellij-choose.sh" "Zellij scripts"
backup_item "$HOME/start-prj-snabjenie.sh" "Project scripts"

echo ""
echo "✓ Backup завершен!"
echo "📁 Сохранено в: $BACKUP_DIR"

# Очистка старых backups (старше 30 дней)
find "$HOME/backups" -name "config-backup-*" -type d -mtime +30 -exec rm -rf {} + 2>/dev/null
echo "🗑️  Удалены backups старше 30 дней"

