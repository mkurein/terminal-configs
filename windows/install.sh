#!/bin/bash

# 🪟 Windows + WSL Terminal Configuration Installer
# Автоматическая установка конфигураций Alacritty + Zellij + Neovim для WSL

set -e

echo "🚀 Установка конфигураций терминала для Windows + WSL..."
echo ""

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Проверка, что скрипт запущен из директории windows
if [[ ! -f "install.sh" ]]; then
    log_error "Запустите скрипт из директории windows/"
    exit 1
fi

# Создание резервных копий
echo "📦 Создание резервных копий существующих конфигов..."
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [[ -f "$HOME/.config/zellij/config.kdl" ]]; then
    cp "$HOME/.config/zellij/config.kdl" "$BACKUP_DIR/"
    log_warning "Создан backup: $BACKUP_DIR/config.kdl"
fi

if [[ -d "$HOME/.config/zellij/layouts" ]]; then
    cp -r "$HOME/.config/zellij/layouts" "$BACKUP_DIR/"
    log_warning "Создан backup: $BACKUP_DIR/layouts/"
fi

# Создание необходимых директорий
echo ""
echo "📁 Создание директорий..."
mkdir -p "$HOME/.config/zellij/layouts"
mkdir -p "$HOME/.config/zsh"
log_success "Директории созданы"

# Копирование конфигурационных файлов
echo ""
echo "📄 Копирование конфигураций..."

# Zellij config
cp zellij/config.kdl "$HOME/.config/zellij/config.kdl"
log_success "Zellij config установлен"

# Zellij layouts
cp zellij/layouts/*.kdl "$HOME/.config/zellij/layouts/"
log_success "Zellij layouts установлены"

# Scripts
cp scripts/*.sh "$HOME/"
chmod +x "$HOME"/*.sh
log_success "Скрипты запуска установлены"

# Zsh aliases
if [[ -f "zsh/aliases.zsh" ]]; then
    cp zsh/aliases.zsh "$HOME/.config/zsh/aliases.zsh"
    log_success "Zsh aliases установлены"
    
    # Добавляем source в .zshrc если ещё не добавлено
    if ! grep -q "source ~/.config/zsh/aliases.zsh" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Custom aliases" >> "$HOME/.zshrc"
        echo "source ~/.config/zsh/aliases.zsh" >> "$HOME/.zshrc"
        log_success "Добавлен source aliases.zsh в .zshrc"
    fi
fi

# Проверка зависимостей
echo ""
echo "🔍 Проверка установленных компонентов..."

check_command() {
    if command -v "$1" &> /dev/null; then
        log_success "$2 установлен"
        return 0
    else
        log_warning "$2 НЕ установлен"
        return 1
    fi
}

MISSING_DEPS=0

check_command "zellij" "Zellij" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "nvim" "Neovim" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "htop" "htop" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "zsh" "Zsh" || MISSING_DEPS=$((MISSING_DEPS + 1))

if [[ $MISSING_DEPS -gt 0 ]]; then
    echo ""
    log_warning "Найдено $MISSING_DEPS отсутствующих компонентов"
    echo ""
    echo "Для установки выполните в WSL:"
    echo "  sudo apt update"
    echo "  sudo apt install zsh neovim htop -y"
    echo "  cargo install zellij  # требуется Rust"
fi

# Информация об Alacritty (устанавливается в Windows)
echo ""
echo "📋 Alacritty (Windows)"
echo "Конфигурация находится в: windows/alacritty/alacritty.toml"
echo "Скопируйте в: %APPDATA%\\alacritty\\alacritty.toml"
echo ""
echo "Путь в PowerShell:"
echo '  Copy-Item windows\alacritty\alacritty.toml $env:APPDATA\alacritty\'

# Финальные инструкции
echo ""
echo "================================================================"
echo -e "${GREEN}✓ Установка завершена!${NC}"
echo "================================================================"
echo ""
echo "📝 Следующие шаги:"
echo ""
echo "1. Установите Alacritty в Windows (если не установлен)"
echo "2. Скопируйте alacritty.toml в %APPDATA%\\alacritty\\"
echo "3. Перезапустите Alacritty"
echo "4. Выберите workspace layout из меню"
echo "5. Наслаждайтесь! 🎉"
echo ""
echo "📖 Документация: windows/docs/COMPLETE_SETUP_GUIDE.md"
echo ""

if [[ $MISSING_DEPS -gt 0 ]]; then
    echo -e "${YELLOW}⚠ Не забудьте установить отсутствующие компоненты!${NC}"
    echo ""
fi

echo "💾 Резервные копии сохранены в: $BACKUP_DIR"
echo ""

