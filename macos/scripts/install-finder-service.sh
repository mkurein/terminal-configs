#!/bin/bash

# 📦 Установка Quick Action для Finder
# Создает "Open Alacritty Here" в контекстном меню Finder

echo "📦 Установка Finder Quick Action..."
echo ""

# Путь к скрипту
SCRIPT_PATH="$HOME/open-alacritty-here.sh"

# Проверяем, что скрипт скопирован
if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "✗ Скрипт не найден: $SCRIPT_PATH"
    echo "Сначала запустите основной install.sh"
    exit 1
fi

# Создаем AppleScript для Quick Action
AUTOMATOR_WORKFLOW="$HOME/Library/Services/Open Alacritty Here.workflow"

cat > /tmp/alacritty-service.applescript << 'EOFSCRIPT'
on run {input, parameters}
    set currentPath to POSIX path of (input as text)
    do shell script "~/open-alacritty-here.sh " & quoted form of currentPath
    return input
end run
EOFSCRIPT

echo ""
echo "════════════════════════════════════════════════════════════"
echo "⚠️  РУЧНАЯ УСТАНОВКА ЧЕРЕЗ AUTOMATOR"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Следуйте этим шагам для добавления в контекстное меню Finder:"
echo ""
echo "1. Откройте Automator (Приложения → Automator)"
echo ""
echo "2. Выберите: 'Quick Action' (Быстрое действие)"
echo ""
echo "3. Настройки сверху:"
echo "   - Workflow receives: 'files or folders'"
echo "   - in: 'Finder'"
echo ""
echo "4. Найдите слева действие 'Run Shell Script' и перетащите в область справа"
echo ""
echo "5. В настройках действия:"
echo "   - Shell: /bin/bash"
echo "   - Pass input: as arguments"
echo ""
echo "6. Вставьте этот код:"
echo "────────────────────────────────────────────────────────────"
cat << 'EOF'
for f in "$@"; do
    ~/open-alacritty-here.sh "$f"
done
EOF
echo "────────────────────────────────────────────────────────────"
echo ""
echo "7. File → Save (⌘S):"
echo "   - Имя: 'Open Alacritty Here'"
echo ""
echo "8. Готово! Теперь в Finder:"
echo "   - ПКМ на папке → Services → 'Open Alacritty Here' ✨"
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "💡 БОНУС: Добавить горячую клавишу"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "1. System Settings → Keyboard → Keyboard Shortcuts"
echo "2. Services → General → 'Open Alacritty Here'"
echo "3. Нажмите 'Add Shortcut' и выберите, например: ⌘⌥T"
echo ""
echo "Теперь можно открывать Alacritty горячей клавишей! 🚀"
echo ""

