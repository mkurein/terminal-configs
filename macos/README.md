# 🍎 macOS Terminal Configuration

Конфигурация терминала для macOS с **Alacritty + Zellij + Neovim**.

## 📦 Что включено

- ✅ **Alacritty** - быстрый GPU-ускоренный терминал
- ✅ **Zellij** - terminal multiplexer с персистентностью
- ✅ **Neovim** - с Lazy.nvim + Neo-tree (файловый менеджер с превью)
- ✅ **Workspace layouts** - готовые конфигурации (40/60 и 50/50)
- ✅ **Автозапуск** - Zellij запускается только в Alacritty
- ✅ **Интерактивное меню** - выбор layout при запуске

## 🚀 Быстрая установка

### 1. Установите зависимости

```bash
# Homebrew (если не установлен)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Основные компоненты
brew install alacritty neovim htop

# Zellij (через Cargo для совместимости)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install zellij

# Oh My Zsh (опционально)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2. Запустите установку

```bash
cd macos
./install.sh
```

Скрипт установки:
- Создаст необходимые директории
- Скопирует конфигурационные файлы
- Установит правильные права доступа
- Создаст резервные копии существующих конфигов

### 3. Перезапустите Alacritty

Откройте Alacritty → появится меню выбора workspace! 🎉

### 4. Проверьте установку (опционально)

Если возникли проблемы, запустите диагностический скрипт:

```bash
~/check-alacritty-setup.sh
```

Скрипт автоматически проверит все компоненты и подскажет, что нужно исправить.

## 📁 Что будет установлено

| Источник | Назначение | Описание |
|----------|-----------|----------|
| `alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` | Конфигурация Alacritty |
| `zellij/layouts/*.kdl` | `~/.config/zellij/layouts/` | Workspace layouts |
| `scripts/alacritty-start.sh` | `~/alacritty-start.sh` | Wrapper автозапуска |
| `scripts/start-zellij-choose.sh` | `~/start-zellij-choose.sh` | Меню выбора layout |
| `scripts/start-vpn-manage.sh` | `~/start-vpn-manage.sh` | Прямой запуск 40/60 |
| `scripts/start-vpn-manage-5050.sh` | `~/start-vpn-manage-5050.sh` | Прямой запуск 50/50 |
| `scripts/open-alacritty-here.sh` | `~/open-alacritty-here.sh` | Открыть Alacritty в папке |
| `scripts/open-alacritty-here-simple.sh` | `~/open-alacritty-here-simple.sh` | Упрощенная версия |
| `zsh/aliases.zsh` | `~/.config/zsh/aliases.zsh` | Алиасы (n=nvim) |

## 🚀 Открыть Alacritty в текущей папке

### Способ 1: Через Quick Action (Рекомендуется)

**Добавление в контекстное меню Finder:**

1. Запустите скрипт установки:
```bash
~/install-finder-service.sh
```

2. Следуйте инструкциям для создания Quick Action в Automator

3. Теперь в Finder: **ПКМ на папке → Services → "Open Alacritty Here"** ✨

**Бонус:** Добавьте горячую клавишу (например, `⌘⌥T`) в System Settings → Keyboard → Keyboard Shortcuts → Services

### Способ 2: Из командной строки

```bash
# В текущей папке
~/open-alacritty-here.sh

# В указанной папке
~/open-alacritty-here.sh ~/Projects/MyProject

# Упрощенная версия (просто открывает новое окно)
~/open-alacritty-here-simple.sh
```

### Способ 3: Создать алиас

Добавьте в `~/.zshrc`:

```bash
alias here='open -na Alacritty --args --working-directory "$(pwd)"'
```

Теперь команда `here` откроет Alacritty в текущей папке!

---

## 📖 Документация

### Основные руководства:

- **[Zellij Setup](./docs/ZELLIJ_SETUP_MACOS.md)**  
  Полная настройка Zellij с layouts и автозапуском

- **[Finder Integration](./docs/FINDER_INTEGRATION.md)**  
  Интеграция Alacritty с Finder (Quick Actions)

### ⚡ Productivity Tools

Аналогично Windows, добавлены инструменты для продуктивности:

**Скрипты:**
- `ps` - Project Switcher (быстрое переключение между проектами)
- `gq` - Git Quick (add+commit+push одной командой)
- `backup` - резервное копирование всех конфигов
- `sync` - синхронизация с репозиторием
- `devenv` - автонастройка окружения проекта
- `clean` - очистка системы (Homebrew, npm, Docker, кеши)

**Расширенные алиасы:**
- Git: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`
- Навигация: `c`, `..`, `...`, `....`
- Python: `py`, `pip`, `venv`, `activate`
- macOS: `showfiles`, `hidefiles`, `flushdns`
- И 10+ полезных функций

См. `zsh/aliases.zsh` для полного списка

### Основные горячие клавиши

**Zellij**:
- `Ctrl+p` → `n` - новая панель
- `Ctrl+t` → `n` - новый таб
- `Ctrl+p` → стрелки - переключение между панелями
- `Ctrl+q` - выйти из Zellij

**Neovim**:
- `Space + e` - открыть/закрыть Neo-tree
- `Space + ff` - найти файл (Telescope)
- `P` (в Neo-tree) - превью файла

## 🔧 Настройка под себя

### Изменить путь к проекту в layouts

Отредактируйте файлы в `zellij/layouts/*.kdl`, замените:

```kdl
cwd "~/Project/ProjectPython/VPNserverManage-Clean"
```

на ваш путь к проекту.

### Создать свой layout

1. Скопируйте существующий layout:
```bash
cp ~/.config/zellij/layouts/workspaceVPNmanage.kdl ~/.config/zellij/layouts/my-layout.kdl
```

2. Отредактируйте под свои нужды

3. Добавьте в `start-zellij-choose.sh` новый пункт меню

### Добавить свои алиасы

Алиасы находятся в файле `~/.config/zsh/aliases.zsh` (или `macos/zsh/aliases.zsh` в репозитории).

**Добавление нового алиаса:**

1. Откройте файл:
```bash
nvim ~/.config/zsh/aliases.zsh
# или
n ~/.config/zsh/aliases.zsh
```

2. Добавьте алиас в нужную секцию (Git, Python, Docker и т.д.):
```bash
# Git shortcuts
alias g='git'
alias gs='git status'
alias gb='git branch'              # ваш новый алиас
alias gba='git branch -a'          # ещё один
# ... и т.д.
```

3. Сохраните файл и перезагрузите конфигурацию:
```bash
source ~/.zshrc
```

4. Или откройте новое окно терминала - алиасы загрузятся автоматически.

**Примеры полезных алиасов:**
```bash
# Git
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gsp='git stash pop'

# Навигация
alias ll='ls -lah'
alias la='ls -la'

# Редакторы
alias v='vim'
alias e='code'  # или 'nvim'

# Система
alias ports='lsof -i -P -n | grep LISTEN'
alias reload='source ~/.zshrc'
```

**Важно:** После добавления алиасов в репозиторий, не забудьте:
```bash
# Обновить локальный файл
cp ~/Project/terminal-configs/macos/zsh/aliases.zsh ~/.config/zsh/aliases.zsh

# Или запустить install.sh
cd ~/Project/terminal-configs/macos
./install.sh
```

### Добавить горячие клавиши в Alacritty

Горячие клавиши настраиваются в `~/.config/alacritty/alacritty.toml`.

**Добавление новой горячей клавиши:**

1. Откройте конфигурацию:
```bash
n ~/.config/alacritty/alacritty.toml
```

2. Найдите секцию `[[keyboard.bindings]]` и добавьте новую привязку:
```toml
# Пример: Ctrl+Shift+T для нового таба
[[keyboard.bindings]]
key = "T"
mods = "Control|Shift"
action = "SpawnNewInstance"

# Пример: F12 для полноэкранного режима
[[keyboard.bindings]]
key = "F12"
action = "ToggleFullscreen"

# Пример: Кастомная команда
[[keyboard.bindings]]
key = "K"
mods = "Control|Shift"
chars = "\u000c"  # Ctrl+L для очистки экрана
```

3. Перезапустите Alacritty - изменения применятся автоматически.

**Доступные действия:**
- `SpawnNewInstance` - новое окно Alacritty
- `ToggleFullscreen` - полноэкранный режим
- `IncreaseFontSize` / `DecreaseFontSize` - размер шрифта
- `Copy` / `Paste` - копирование/вставка
- `chars = "..."` - отправить символы/escape-последовательности

**Модификаторы:**
- `Control` или `Ctrl`
- `Shift`
- `Alt` или `Option` (на macOS)
- `Command` или `Super` (на macOS)

**Примеры полезных привязок:**
```toml
# Увеличение/уменьшение шрифта
[[keyboard.bindings]]
key = "Plus"
mods = "Control"
action = "IncreaseFontSize"

[[keyboard.bindings]]
key = "Minus"
mods = "Control"
action = "DecreaseFontSize"

# Сброс размера шрифта
[[keyboard.bindings]]
key = "Key0"
mods = "Control"
action = "ResetFontSize"
```

### Добавить горячие клавиши в Zellij

Горячие клавиши Zellij настраиваются в `~/.config/zellij/config.kdl`.

**Добавление новой привязки:**

1. Откройте конфигурацию:
```bash
n ~/.config/zellij/config.kdl
```

2. Найдите секцию `keybinds` и добавьте новую привязку:
```kdl
keybinds {
    shared {
        // Ваша новая привязка
        bind "Ctrl g" { SwitchToMode "Normal"; }
        bind "Ctrl h" { GoToNextTab; }
    }
}
```

3. Перезапустите Zellij или нажмите `Ctrl + p` → `r` для перезагрузки конфигурации.

**Полезные привязки для Zellij:**
```kdl
keybinds {
    shared {
        // Быстрое переключение между табами
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        
        // Создание новой панели в разных направлениях
        bind "Ctrl n" { NewPane; }
        bind "Ctrl Shift n" { NewPane "Down"; }
        
        // Закрытие панели
        bind "Ctrl x" { ClosePane; }
    }
}
```

**Режимы Zellij:**
- `Normal` - обычный режим
- `Locked` - заблокированный режим
- `Resize` - режим изменения размера
- `Pane` - режим работы с панелями
- `Tab` - режим работы с табами
- `Scroll` - режим прокрутки

## ⚙️ Ручная установка

Если не хотите использовать `install.sh`:

```bash
# Создайте директории
mkdir -p ~/.config/{alacritty,zellij/layouts,zsh}

# Скопируйте файлы
cp alacritty/alacritty.toml ~/.config/alacritty/
cp zellij/layouts/*.kdl ~/.config/zellij/layouts/
cp scripts/*.sh ~/
cp zsh/aliases.zsh ~/.config/zsh/

# Установите права
chmod +x ~/*.sh

# Обновите alacritty.toml
# Замените строку program = "zsh" на:
# program = "/Users/YOUR_USERNAME/alacritty-start.sh"
```

## 🐛 Устранение неполадок

### 🔴 Alacritty не запускается / сразу закрывается

**Возможные причины и решения:**

#### 1. Отсутствуют скрипты запуска

**Симптомы**: Alacritty открывается и сразу закрывается без сообщений.

**Проверка**:
```bash
ls -la ~/alacritty-start.sh ~/start-zellij-choose.sh
```

**Решение**: Запустите установку заново:
```bash
cd /path/to/terminal-configs/macos
./install.sh
```

Или скопируйте скрипты вручную:
```bash
cp scripts/alacritty-start.sh ~/
cp scripts/start-zellij-choose.sh ~/
chmod +x ~/*.sh
```

#### 2. 🚨 Windows-алиасы конфликтуют с macOS (КРИТИЧНО!)

**Симптомы**: При запуске Alacritty появляется ошибка:
```
(eval):1: command not found: explorer.exe
```

**Причина**: В `~/.config/zsh/aliases.zsh` присутствует Windows-специфичный алиас:
```bash
alias open=explorer.exe
```

Этот алиас переопределяет системную команду `open` на macOS, из-за чего Alacritty не может запуститься!

**Решение**:
```bash
# Удалите конфликтующий алиас
sed -i.bak '/alias open=explorer.exe/d' ~/.config/zsh/aliases.zsh

# Перезагрузите конфигурацию
source ~/.zshrc

# Запустите Alacritty
/usr/bin/open -a Alacritty
```

**Профилактика**: Файл `macos/zsh/aliases.zsh` в репозитории уже исправлен и не содержит Windows-алиасов.

#### 3. Zellij не в PATH

**Симптомы**: Alacritty закрывается после выбора workspace.

**Проверка**:
```bash
which zellij
```

**Решение**: Убедитесь, что все скрипты содержат:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

Если Zellij не установлен:
```bash
cargo install zellij
# или
brew install zellij
```

### Меню выбора workspace не появляется

**Проверьте**:
1. Права на исполнение:
   ```bash
   ls -la ~/alacritty-start.sh ~/start-zellij-choose.sh
   ```

2. Путь в `alacritty.toml`:
   ```bash
   grep "program" ~/.config/alacritty/alacritty.toml
   ```
   Должно быть: `program = "/Users/YOUR_USERNAME/alacritty-start.sh"`

3. Скрипт существует и работает:
   ```bash
   cat ~/start-zellij-choose.sh
   ```

### Neo-tree не работает

**Решение**:
1. Откройте Neovim: `nvim`
2. Дождитесь установки плагинов (Lazy.nvim)
3. `:checkhealth` - проверьте статус

### 🔧 Диагностический скрипт

Если возникли проблемы, запустите автоматическую диагностику:

```bash
~/check-alacritty-setup.sh
```

Этот скрипт проверит:
- ✅ Установленные программы (alacritty, zellij, nvim, htop)
- ✅ Наличие всех скриптов запуска
- ✅ Конфигурационные файлы
- ✅ Темы и шрифты
- ✅ Права доступа

**Примечание**: Скрипт создаётся автоматически при первой настройке. Если его нет, создайте вручную или запустите `install.sh`.

### Проблемы со шрифтами

**Симптомы**: Иконки отображаются как квадраты или вопросительные знаки.

**Решение**:
```bash
# Проверьте установку Nerd Font
fc-list | grep -i "hack"

# Если шрифт отсутствует, установите:
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
```

### Alacritty запускается в неправильной директории

**Решение**: Используйте специальный скрипт для открытия в текущей папке:
```bash
# Добавьте в ~/.zshrc:
alias here='open -na Alacritty --args --working-directory "$(pwd)"'
```

## 📝 Заметки

- **Zellij работает ТОЛЬКО в Alacritty** - другие терминалы используют обычный zsh
- **Персистентность**: layouts сохраняются, сессии восстанавливаются
- **Neo-tree**: современная альтернатива nvim-tree с превью файлов
- **Алиас `n`**: быстрый запуск Neovim (`n .` в layouts)
- **macOS-специфичные команды**: используйте `/usr/bin/open` вместо `open`, если есть проблемы с алиасами

## ⚠️ Известные проблемы (исправлены в v2.2)

### 🐛 Баг: Windows-алиас блокирует запуск Alacritty

**Статус**: ✅ ИСПРАВЛЕНО в версии 2.2

**Описание**: В предыдущих версиях файл `zsh/aliases.zsh` содержал Windows-специфичный алиас:
```bash
alias open=explorer.exe
```

Этот алиас конфликтовал с системной командой `open` на macOS, полностью блокируя запуск Alacritty.

**Исправление**: 
- Удалён конфликтующий алиас из `macos/zsh/aliases.zsh`
- Добавлен комментарий о несовместимости Windows-алиасов
- Скрипт `install.sh` теперь корректно устанавливает macOS-версию файла

**Если у вас старая версия**:
```bash
# Удалите конфликтующий алиас
sed -i.bak '/alias open=explorer.exe/d' ~/.config/zsh/aliases.zsh
source ~/.zshrc
```

### 🐛 Проблема: Отсутствующие скрипты после установки

**Статус**: ⚠️ ОБХОДНОЕ РЕШЕНИЕ

**Описание**: Иногда скрипты `alacritty-start.sh` и `start-zellij-choose.sh` не копируются в домашнюю директорию.

**Решение**: Запустите `install.sh` заново или скопируйте скрипты вручную:
```bash
cp scripts/alacritty-start.sh ~/
cp scripts/start-zellij-choose.sh ~/
chmod +x ~/*.sh
```

## 🔄 Обновление

Чтобы обновить конфигурацию из репозитория:

```bash
cd ~/terminal-configs-backup
git pull
cd macos
./install.sh
```

---

**Версия**: 2.4 (`github-proxy`; терминал 2.2)
**Дата**: 2026-09-18
**Платформа**: macOS

## 📋 Changelog

### v2.4 (2026-09-18)
- 🚀 zsh: `github-fetch` / `github-pull` / `github-commit` / `github-push` / `github-gh` через `github-proxy/env.sh`
- 📚 Remotes GitHub + Forgejo и проверка pull/push — корневой [README](../README.md)
- 🔒 Обезличены домашние пути в docs и Zellij layouts (`~/…` вместо конкретного пользователя)

### v2.2 (2025-11-11)

Исправления:
- ✅ **Критично**: удалён Windows-алиас `open=explorer.exe` из `macos/zsh/aliases.zsh`
- ✅ Комментарий о несовместимости Windows-алиасов с macOS
- ✅ Диагностический скрипт `check-alacritty-setup.sh`
- ✅ Расширены устранение неполадок и известные проблемы

См. [Changelog](../README.md#-changelog) в корневом README для полной истории.

