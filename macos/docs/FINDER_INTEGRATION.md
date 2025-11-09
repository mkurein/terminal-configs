# 🍎 Интеграция Alacritty с Finder

Руководство по добавлению "Open Alacritty Here" в контекстное меню Finder.

## 🎯 Цель

Добавить возможность открывать Alacritty в любой папке прямо из Finder, как "Open in Terminal" но для Alacritty.

## 📦 Что включено

### 1. `open-alacritty-here.sh`
Основной скрипт для открытия Alacritty в указанной папке.

### 2. `open-alacritty-here-simple.sh`
Упрощенная версия, использующая команду `open`.

### 3. `install-finder-service.sh`
Интерактивный гид по созданию Quick Action в Automator.

---

## 🚀 Установка через Automator (Рекомендуется)

### Шаг 1: Запустите установочный скрипт

```bash
cd ~/terminal-configs/macos
./install.sh  # Если еще не делали

# Запустите инструкцию по установке
~/install-finder-service.sh
```

### Шаг 2: Создайте Quick Action

1. **Откройте Automator**
   - Applications → Automator
   - Или через Spotlight (⌘Space): "Automator"

2. **Создайте новый документ**
   - Выберите: **"Quick Action"** (Быстрое действие)

3. **Настройте параметры сверху:**
   ```
   Workflow receives: files or folders
   in: Finder
   ```

4. **Добавьте действие "Run Shell Script":**
   - В левой панели найдите: "Run Shell Script"
   - Перетащите в правую область

5. **Настройте действие:**
   ```
   Shell: /bin/bash
   Pass input: as arguments
   ```

6. **Вставьте код:**
   ```bash
   for f in "$@"; do
       ~/open-alacritty-here.sh "$f"
   done
   ```

7. **Сохраните:**
   - File → Save (⌘S)
   - Имя: **"Open Alacritty Here"**
   - Сохранится автоматически в `~/Library/Services/`

8. **Готово!** 🎉

---

## 🎮 Использование

### Из Finder

1. **Правой кнопкой на папке**
2. Наведите на **"Services"** (или "Quick Actions" в новых версиях)
3. Выберите **"Open Alacritty Here"**
4. Alacritty откроется в этой папке! ✨

### Из командной строки

```bash
# В текущей папке
~/open-alacritty-here.sh

# В конкретной папке
~/open-alacritty-here.sh ~/Projects/MyProject

# Упрощенная версия
~/open-alacritty-here-simple.sh ~/Downloads
```

### С помощью алиаса

Добавьте в `~/.zshrc`:

```bash
# Открыть Alacritty в текущей папке
alias here='open -na Alacritty --args --working-directory "$(pwd)"'

# Или более продвинутый вариант
alias here='~/open-alacritty-here-simple.sh'
```

Теперь просто: `here` 🚀

---

## ⌨️ Добавление горячей клавиши

### Способ 1: Через System Settings

1. **System Settings** → **Keyboard** → **Keyboard Shortcuts**
2. В левой панели выберите: **Services**
3. Найдите: **General** → **"Open Alacritty Here"**
4. Кликните справа и добавьте shortcut, например:
   - `⌘⌥T` (Command + Option + T)
   - `⌘⇧T` (Command + Shift + T)

### Способ 2: Через BetterTouchTool (если установлен)

1. Откройте BetterTouchTool
2. Keyboard → Shortcuts
3. Add New Shortcut
4. Trigger: `⌘⌥T`
5. Action: Run Script → `/Users/USERNAME/open-alacritty-here.sh "$(pwd)"`

---

## 🔧 Расширенная настройка

### Открытие с выбором Zellij layout

Модифицируйте `open-alacritty-here.sh`:

```bash
#!/bin/bash

TARGET_DIR="${1:-$(pwd)}"
ABSOLUTE_PATH=$(cd "$TARGET_DIR" 2>/dev/null && pwd || pwd)

# Открыть с меню выбора layout
osascript <<EOF
tell application "Alacritty"
    do script "cd '$ABSOLUTE_PATH' && ~/start-zellij-choose.sh"
    activate
end tell
EOF
```

### Открытие в существующем окне

Для открытия новой вкладки вместо нового окна:

```bash
#!/bin/bash

TARGET_DIR="${1:-$(pwd)}"

# Проверяем, запущен ли Alacritty
if pgrep -x "Alacritty" > /dev/null; then
    # Открываем новую вкладку (требуется настройка в Alacritty)
    osascript -e 'tell application "Alacritty" to activate'
    # Отправляем команду cd через clipboard (хак)
else
    # Открываем новое окно
    open -na Alacritty --args --working-directory "$TARGET_DIR"
fi
```

---

## 🎨 Кастомизация иконки

### Изменить иконку в контекстном меню

1. Откройте ваш Automator workflow:
   ```bash
   open ~/Library/Services/Open\ Alacritty\ Here.workflow
   ```

2. К сожалению, нативно добавить иконку в Quick Action нельзя, но можно:
   - Использовать приложения типа **Platypus** для создания app wrapper
   - Или использовать сторонние инструменты типа **Alfred** или **Raycast**

---

## 🐛 Устранение неполадок

### Quick Action не появляется в меню

1. **Проверьте права:**
   ```bash
   ls -la ~/Library/Services/
   # Должен быть Open\ Alacritty\ Here.workflow
   ```

2. **Перезапустите Finder:**
   ```bash
   killall Finder
   ```

3. **Проверьте System Settings:**
   - Extensions → Finder → убедитесь, что сервис включен

### Alacritty не открывается

1. **Проверьте путь к скрипту:**
   ```bash
   ls -la ~/open-alacritty-here.sh
   chmod +x ~/open-alacritty-here.sh
   ```

2. **Проверьте, установлен ли Alacritty:**
   ```bash
   which alacritty
   # или
   open -a Alacritty
   ```

3. **Проверьте логи:**
   ```bash
   # Запустите скрипт вручную и смотрите на ошибки
   ~/open-alacritty-here.sh ~/Desktop
   ```

### Не работает с сетевыми папками

Для SMB/AFP папок может потребоваться дополнительная настройка:

```bash
# В open-alacritty-here.sh добавьте проверку
if [[ "$TARGET_DIR" == /Volumes/* ]]; then
    echo "⚠️  Сетевая папка. Открываем в домашней директории."
    TARGET_DIR="$HOME"
fi
```

---

## 💡 Альтернативы

### Вариант 1: Alfred Workflow (если используете Alfred)

1. Скачайте или создайте Workflow
2. Keyword: `here`
3. Script: `~/open-alacritty-here-simple.sh "{query}"`

### Вариант 2: Raycast Extension

1. Store → Terminal
2. Настройте Alacritty как терминал по умолчанию

### Вариант 3: Через .app wrapper

Создайте приложение с помощью **Platypus**:

```bash
brew install platypus

# Создайте .app
platypus -a 'Open Alacritty Here' \
         -o 'Text Window' \
         -p '/bin/bash' \
         -V '1.0' \
         -I 'com.alacritty.here' \
         -c ~/open-alacritty-here.sh \
         ~/Applications/OpenAlacrittyHere.app
```

---

## 📚 Похожие инструменты

- **iTerm2** имеет встроенную интеграцию с Finder
- **Warp Terminal** также поддерживает Quick Actions
- **Kitty** можно настроить аналогично

---

## 🎓 Дополнительные ресурсы

- [Automator Documentation](https://support.apple.com/guide/automator/)
- [Alacritty Documentation](https://alacritty.org/)
- [AppleScript for Terminal Control](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/)

---

**Версия**: 1.0  
**Дата**: 2025-11-09  
**Совместимость**: macOS 10.15+

**Приятного использования! 🚀**

