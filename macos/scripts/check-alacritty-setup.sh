#!/bin/bash

# 🔍 Диагностика конфигурации Alacritty для macOS
# Автоматическая проверка всех компонентов

echo "🔍 Диагностика конфигурации Alacritty для macOS"
echo "=============================================="
echo ""

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Проверка программ
echo "📦 Проверка установленных программ:"
MISSING_PROGRAMS=0
for cmd in alacritty zellij nvim htop; do
    if command -v $cmd &> /dev/null; then
        echo -e "  ${GREEN}✅${NC} $cmd: $(which $cmd)"
    else
        echo -e "  ${RED}❌${NC} $cmd: НЕ УСТАНОВЛЕН"
        MISSING_PROGRAMS=$((MISSING_PROGRAMS + 1))
    fi
done
echo ""

# Проверка скриптов
echo "📜 Проверка скриптов запуска:"
MISSING_SCRIPTS=0
for script in alacritty-start.sh start-zellij-choose.sh start-vpn-manage.sh start-vpn-manage-5050.sh; do
    if [[ -x "$HOME/$script" ]]; then
        echo -e "  ${GREEN}✅${NC} $script: существует и исполняемый"
    else
        echo -e "  ${RED}❌${NC} $script: отсутствует или не исполняемый"
        MISSING_SCRIPTS=$((MISSING_SCRIPTS + 1))
    fi
done
echo ""

# Проверка конфигов
echo "⚙️  Проверка конфигурационных файлов:"
MISSING_CONFIGS=0

if [[ -f "$HOME/.config/alacritty/alacritty.toml" ]]; then
    echo -e "  ${GREEN}✅${NC} alacritty.toml: существует"
    
    # Проверка пути к скрипту запуска
    if grep -q "program.*alacritty-start.sh" "$HOME/.config/alacritty/alacritty.toml"; then
        echo -e "  ${GREEN}✅${NC} Путь к alacritty-start.sh настроен"
    else
        echo -e "  ${YELLOW}⚠${NC}  Путь к alacritty-start.sh не найден в конфигурации"
    fi
else
    echo -e "  ${RED}❌${NC} alacritty.toml: отсутствует"
    MISSING_CONFIGS=$((MISSING_CONFIGS + 1))
fi

if [[ -d "$HOME/.config/zellij/layouts" ]]; then
    layout_count=$(ls -1 "$HOME/.config/zellij/layouts"/*.kdl 2>/dev/null | wc -l)
    echo -e "  ${GREEN}✅${NC} Zellij layouts: найдено $layout_count файлов"
else
    echo -e "  ${RED}❌${NC} Zellij layouts: директория отсутствует"
    MISSING_CONFIGS=$((MISSING_CONFIGS + 1))
fi
echo ""

# Проверка темы
echo "🎨 Проверка темы:"
if [[ -f "$HOME/.config/alacritty/themes/themes/gruber_darker.toml" ]]; then
    echo -e "  ${GREEN}✅${NC} gruber_darker.toml: установлена"
else
    echo -e "  ${YELLOW}⚠${NC}  gruber_darker.toml: отсутствует (не критично)"
fi
echo ""

# Проверка шрифтов
echo "🔤 Проверка шрифтов:"
if fc-list | grep -q "Hack Nerd Font"; then
    echo -e "  ${GREEN}✅${NC} Hack Nerd Font: установлен"
else
    echo -e "  ${RED}❌${NC} Hack Nerd Font: не найден"
    echo -e "     Установите: ${YELLOW}brew install font-hack-nerd-font${NC}"
fi
echo ""

# Проверка конфликтующих алиасов
echo "🔍 Проверка конфликтующих алиасов:"
if [[ -f "$HOME/.config/zsh/aliases.zsh" ]]; then
    if grep -q "alias open=explorer.exe" "$HOME/.config/zsh/aliases.zsh"; then
        echo -e "  ${RED}❌ КРИТИЧНО!${NC} Найден Windows-алиас: ${RED}alias open=explorer.exe${NC}"
        echo -e "     Этот алиас блокирует запуск Alacritty на macOS!"
        echo -e "     ${YELLOW}Исправление:${NC} sed -i.bak '/alias open=explorer.exe/d' ~/.config/zsh/aliases.zsh"
        MISSING_CONFIGS=$((MISSING_CONFIGS + 1))
    else
        echo -e "  ${GREEN}✅${NC} Конфликтующие алиасы отсутствуют"
    fi
else
    echo -e "  ${YELLOW}⚠${NC}  ~/.config/zsh/aliases.zsh не найден"
fi
echo ""

# Подсчёт проблем
TOTAL_ISSUES=$((MISSING_PROGRAMS + MISSING_SCRIPTS + MISSING_CONFIGS))

echo "=============================================="
if [[ $TOTAL_ISSUES -eq 0 ]]; then
    echo -e "${GREEN}✨ Диагностика завершена! Всё в порядке!${NC}"
else
    echo -e "${YELLOW}⚠ Найдено проблем: $TOTAL_ISSUES${NC}"
    echo ""
    echo "Рекомендации:"
    
    if [[ $MISSING_PROGRAMS -gt 0 ]]; then
        echo "  • Установите отсутствующие программы:"
        echo "    brew install alacritty neovim htop"
        echo "    cargo install zellij"
    fi
    
    if [[ $MISSING_SCRIPTS -gt 0 ]]; then
        echo "  • Установите отсутствующие скрипты:"
        echo "    cd /path/to/terminal-configs/macos"
        echo "    ./install.sh"
    fi
    
    if [[ $MISSING_CONFIGS -gt 0 ]]; then
        echo "  • Исправьте конфигурационные файлы (см. выше)"
    fi
fi
echo "=============================================="
echo ""
echo "Для запуска Alacritty:"
echo "  Способ 1: Cmd + Space → 'Alacritty' → Enter"
echo "  Способ 2: /usr/bin/open -a Alacritty"
echo ""
echo "Документация: ~/terminal-configs/macos/README.md"
echo ""

