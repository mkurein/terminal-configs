#!/bin/bash

# 🍎 macOS Terminal Configuration Installer
# Автоматическая установка конфигураций Alacritty + Zellij + Neovim

set -e

echo "🚀 Установка конфигураций терминала для macOS..."
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

# Проверка, что скрипт запущен из директории macos
if [[ ! -f "install.sh" ]]; then
    log_error "Запустите скрипт из директории macos/"
    exit 1
fi

# Создание резервных копий
echo "📦 Создание резервных копий существующих конфигов..."
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

if [[ -f "$HOME/.config/alacritty/alacritty.toml" ]]; then
    cp "$HOME/.config/alacritty/alacritty.toml" "$BACKUP_DIR/"
    log_warning "Создан backup: $BACKUP_DIR/alacritty.toml"
fi

if [[ -d "$HOME/.config/zellij/layouts" ]]; then
    cp -r "$HOME/.config/zellij/layouts" "$BACKUP_DIR/"
    log_warning "Создан backup: $BACKUP_DIR/layouts/"
fi

# Создание необходимых директорий
echo ""
echo "📁 Создание директорий..."
mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/zellij/layouts"
mkdir -p "$HOME/.config/zsh"
log_success "Директории созданы"

# Копирование конфигурационных файлов
echo ""
echo "📄 Копирование конфигураций..."

# Alacritty
cp alacritty/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"
log_success "Alacritty config установлен"

# Zellij layouts
cp zellij/layouts/*.kdl "$HOME/.config/zellij/layouts/"
log_success "Zellij layouts установлены"

# Scripts
cp scripts/*.sh "$HOME/"
chmod +x "$HOME"/*.sh
log_success "Скрипты запуска установлены"

# Open Alacritty Here скрипты
if [[ -f "scripts/open-alacritty-here.sh" ]]; then
    log_success "Open Alacritty Here установлен"
fi
if [[ -f "scripts/open-alacritty-here-simple.sh" ]]; then
    log_success "Open Alacritty Here (Simple) установлен"
fi

# Productivity scripts
if [[ -f "scripts/project-switcher.sh" ]]; then
    log_success "Productivity tools установлены"
fi

# Zsh aliases (если существует)
if [[ -f "zsh/aliases.zsh" ]]; then
    cp zsh/aliases.zsh "$HOME/.config/zsh/aliases.zsh"
    log_success "Zsh aliases установлены"
fi

# Обновление путей в конфигах
echo ""
echo "🔧 Настройка путей..."

USERNAME=$(whoami)
HOME_DIR="$HOME"

# Обновление пути в alacritty.toml
sed -i.bak "s|program = \".*alacritty-start.sh\"|program = \"$HOME_DIR/alacritty-start.sh\"|g" "$HOME/.config/alacritty/alacritty.toml"
rm "$HOME/.config/alacritty/alacritty.toml.bak"
log_success "Пути обновлены для пользователя: $USERNAME"

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

check_command "alacritty" "Alacritty" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "zellij" "Zellij" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "nvim" "Neovim" || MISSING_DEPS=$((MISSING_DEPS + 1))
check_command "htop" "htop" || MISSING_DEPS=$((MISSING_DEPS + 1))

if [[ $MISSING_DEPS -gt 0 ]]; then
    echo ""
    log_warning "Найдено $MISSING_DEPS отсутствующих компонентов"
    echo ""
    echo "Для установки выполните:"
    echo "  brew install alacritty neovim htop"
    echo "  cargo install zellij  # или brew install zellij"
fi

# Финальные инструкции
echo ""
echo "================================================================"
echo -e "${GREEN}✓ Установка завершена!${NC}"
echo "================================================================"
echo ""
echo "📝 Следующие шаги:"
echo ""
echo "1. Перезапустите Alacritty"
echo "2. Выберите workspace layout из меню"
echo "3. Наслаждайтесь! 🎉"
echo ""
echo "📖 Документация: macos/docs/ZELLIJ_SETUP_MACOS.md"
echo ""

if [[ $MISSING_DEPS -gt 0 ]]; then
    echo -e "${YELLOW}⚠ Не забудьте установить отсутствующие компоненты!${NC}"
    echo ""
fi

echo "💾 Резервные копии сохранены в: $BACKUP_DIR"
echo ""

