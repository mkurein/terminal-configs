# 🖥️ Terminal Configurations

Кроссплатформенный репозиторий конфигураций для терминала с Alacritty + Zellij + Neovim.

## 📋 Содержание

### 🍎 [macOS](./macos/)
Конфигурация для macOS с:
- **Alacritty** - GPU-ускоренный терминал
- **Zellij** - современный terminal multiplexer
- **Neovim** с Lazy.nvim + Neo-tree
- **Zsh** с Oh My Zsh

📖 **Документация**: [ZELLIJ_SETUP_MACOS.md](./macos/docs/ZELLIJ_SETUP_MACOS.md)

**Версия**: 2.1 (обновлено 2025-11-08)

**Особенности**:
- Изолированный автозапуск Zellij только в Alacritty
- Готовые workspace layouts (40/60 и 50/50)
- Интерактивное меню выбора layout
- Автоматический запуск Neovim в проектах
- ✨ **NEW**: Productivity Tools - 6 скриптов + 35+ алиасов/функций
- ✨ **NEW**: Finder Integration - Quick Action для открытия Alacritty

---

### 🪟 [Windows](./windows/)
Полная конфигурация для Windows 11 + WSL Ubuntu.

📖 **Документация**: 
- [COMPLETE_SETUP_GUIDE.md](./windows/docs/COMPLETE_SETUP_GUIDE.md) - полное руководство
- [USEFUL_ALIASES.md](./windows/docs/USEFUL_ALIASES.md) - справочник команд ✨ NEW!

**Версия**: 2.0 (обновлено 2025-11-10)

**Особенности**:
- Alacritty в Windows с интеграцией WSL Ubuntu
- Zellij с Alt+стрелки навигацией
- LazyVim с полной настройкой
- Готовые workspace layouts (40/60 и 50/50)
- Автоматическое меню выбора layout
- Скрипт установки для WSL
- ✨ **NEW**: Productivity Tools - 6 скриптов + 32+ алиасов
- ✨ **NEW**: Полный справочник команд и workflows

---

## 🚀 Быстрый старт

### macOS

1. **Клонируйте репозиторий**:
```bash
git clone <your-repo-url> ~/terminal-configs-backup
cd ~/terminal-configs-backup
```

2. **Запустите установку**:
```bash
cd macos
./install.sh
```

3. **Откройте Alacritty** и наслаждайтесь! 🎉

---

### Windows + WSL

1. **Установите WSL и зависимости** (в WSL):
```bash
# Основные компоненты
sudo apt update && sudo apt install zsh neovim htop build-essential -y

# Zellij (через Cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install zellij
```

2. **Клонируйте репозиторий** (в WSL):
```bash
git clone <your-repo-url> ~/terminal-configs
cd ~/terminal-configs
```

3. **Запустите установку WSL конфигов**:
```bash
cd windows
./install.sh
```

4. **Установите Alacritty в Windows** и скопируйте конфиг:
```powershell
# PowerShell
scoop install alacritty
Copy-Item windows\alacritty\alacritty.toml $env:APPDATA\alacritty\
```

5. **Откройте Alacritty** и наслаждайтесь! 🎉

---

## 📁 Структура репозитория

```
terminal-configs/
├── README.md                              # Главный README
├── macos/                                 # Конфигурация для macOS
│   ├── README.md                          # README для macOS
│   ├── install.sh                         # Скрипт установки
│   ├── alacritty/
│   │   └── alacritty.toml                 # Конфигурация Alacritty
│   ├── zellij/
│   │   └── layouts/
│   │       ├── workspaceVPNmanage.kdl     # Layout 40/60
│   │       └── workspaceVPNmanage-5050.kdl # Layout 50/50
│   ├── scripts/
│   │   ├── alacritty-start.sh             # Wrapper для автозапуска
│   │   ├── start-zellij-choose.sh         # Меню выбора layout
│   │   ├── start-vpn-manage.sh            # Прямой запуск 40/60
│   │   ├── start-vpn-manage-5050.sh       # Прямой запуск 50/50
│   │   ├── open-alacritty-here.sh         # Открыть Alacritty в папке Finder
│   │   ├── open-alacritty-here-simple.sh  # Упрощенная версия
│   │   └── install-finder-service.sh      # Установка Quick Action
│   ├── zsh/
│   │   └── aliases.zsh                    # Алиасы (n=nvim)
│   └── docs/
│       └── ZELLIJ_SETUP_MACOS.md          # Полная документация
└── windows/                               # Конфигурация для Windows + WSL
    ├── README.md                          # README для Windows
    ├── install.sh                         # Скрипт установки (WSL)
    ├── alacritty/
    │   └── alacritty.toml                 # Конфигурация Alacritty (Windows)
    ├── zellij/
    │   ├── config.kdl                     # Конфигурация Zellij (WSL)
    │   └── layouts/
    │       ├── workspacePrjSnabjenie.kdl  # Layout 40/60
    │       └── my-workspace.kdl           # Layout 50/50
    ├── scripts/
    │   ├── start-zellij-choose.sh         # Меню выбора layout
    │   ├── start-prj-snabjenie.sh         # Прямой запуск 40/60
    │   └── start-simple.sh                # Прямой запуск 50/50
    ├── zsh/
    │   └── aliases.zsh                    # Алиасы (n=nvim)
    ├── wa.bat                             # Запуск Alacritty из текущей папки Windows
    ├── alacritty-here.reg                 # Добавление в контекстное меню
    ├── INSTALL_WA.md                      # Установка wa.bat в System32
    └── docs/
        ├── COMPLETE_SETUP_GUIDE.md        # Полное руководство (1281 строка)
        ├── LAZYVIM_SETUP.md               # Руководство по LazyVim
        ├── PRODUCTIVITY_TOOLS.md          # Инструменты продуктивности
        ├── WSL_FILE_OPERATIONS.md         # Работа с файлами WSL ↔ Windows
        └── USEFUL_ALIASES.md              # Справочник команд и алиасов (32+)
```

---

## 🔧 Требования

### macOS
- macOS 10.15+
- Homebrew
- Alacritty
- Zellij (через Cargo или Homebrew)
- Neovim 0.9+
- Zsh + Oh My Zsh
- htop

### Windows + WSL
- Windows 11 (или Windows 10 с WSL2)
- WSL2 с Debian/Ubuntu
- Alacritty (для Windows)
- Zellij (через Cargo в WSL)
- Neovim 0.9+ (в WSL)
- Zsh (в WSL)
- Rust + Cargo (для Zellij)
- htop (в WSL)

---

## 🔧 Настройка под себя

### 🪟 Windows + WSL

#### Добавить свои алиасы

Алиасы находятся в файле `~/.config/zsh/aliases.zsh` в WSL (или `windows/zsh/aliases.zsh` в репозитории).

**Добавление нового алиаса:**

1. Откройте файл в WSL:
```bash
# В WSL
nvim ~/.config/zsh/aliases.zsh
# или
n ~/.config/zsh/aliases.zsh
```

2. Добавьте алиас в нужную секцию:
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

4. Или откройте новое окно Alacritty - алиасы загрузятся автоматически.

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

# WSL специфичные
alias explorer='explorer.exe .'    # открыть текущую папку в Windows Explorer
alias code='code .'                 # открыть в VSCode
```

**Важно:** После добавления алиасов в репозиторий:
```bash
# В WSL
cd ~/terminal-configs/windows
./install.sh

# Или вручную
cp windows/zsh/aliases.zsh ~/.config/zsh/aliases.zsh
```

#### Добавить горячие клавиши в Alacritty (Windows)

Горячие клавиши настраиваются в `%APPDATA%\alacritty\alacritty.toml` (Windows) или `~/.config/alacritty/alacritty.toml` (WSL).

**Добавление новой горячей клавиши:**

1. Откройте конфигурацию:
```powershell
# В PowerShell
notepad $env:APPDATA\alacritty\alacritty.toml

# Или в WSL
n ~/.config/alacritty/alacritty.toml
```

2. Найдите секцию `[[keyboard.bindings]]` и добавьте новую привязку:
```toml
# Пример: Ctrl+Shift+T для нового окна
[[keyboard.bindings]]
key = "T"
mods = "Control|Shift"
action = "SpawnNewInstance"

# Пример: F12 для полноэкранного режима
[[keyboard.bindings]]
key = "F12"
action = "ToggleFullscreen"

# Пример: Alt+стрелки для Zellij (уже есть в конфиге)
[[keyboard.bindings]]
key = "Left"
mods = "Alt"
chars = "\u001b[1;3D"
```

3. Перезапустите Alacritty - изменения применятся автоматически.

**Доступные действия:**
- `SpawnNewInstance` - новое окно Alacritty
- `ToggleFullscreen` - полноэкранный режим
- `IncreaseFontSize` / `DecreaseFontSize` - размер шрифта
- `Copy` / `Paste` - копирование/вставка
- `chars = "..."` - отправить символы/escape-последовательности (для Zellij)

**Модификаторы:**
- `Control` или `Ctrl`
- `Shift`
- `Alt`
- `Command` или `Super` (на Windows обычно не используется)

**Примеры полезных привязок для Windows:**
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

# Копирование/вставка (Windows стиль)
[[keyboard.bindings]]
key = "C"
mods = "Control|Shift"
action = "Copy"

[[keyboard.bindings]]
key = "V"
mods = "Control|Shift"
action = "Paste"
```

#### Добавить горячие клавиши в Zellij (WSL)

Горячие клавиши Zellij настраиваются в `~/.config/zellij/config.kdl` в WSL.

**Добавление новой привязки:**

1. Откройте конфигурацию в WSL:
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
        
        // Создание новой панели
        bind "Ctrl n" { NewPane; }
        bind "Ctrl Shift n" { NewPane "Down"; }
        
        // Закрытие панели
        bind "Ctrl x" { ClosePane; }
        
        // Переключение между панелями (Alt+стрелки уже настроены в Alacritty)
        bind "Alt Left" { MoveFocus "Left"; }
        bind "Alt Right" { MoveFocus "Right"; }
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

**Важно:** Горячие клавиши для Zellij работают через Alacritty, поэтому:
1. Сначала настройте привязку в Alacritty (`alacritty.toml`) для отправки нужных escape-последовательностей
2. Затем настройте обработку этих последовательностей в Zellij (`config.kdl`)

### 🍎 macOS

См. подробные инструкции в [macos/README.md](./macos/README.md#-настройка-под-себя):
- Добавить свои алиасы
- Добавить горячие клавиши в Alacritty
- Добавить горячие клавиши в Zellij

---

## 📝 Changelog

### v2.1 - 2025-11-10 (Windows)
- ✅ Добавлен полный справочник команд и алиасов (USEFUL_ALIASES.md)
- ✅ Обновлена конфигурация для Ubuntu WSL (было Debian)
- ✅ Документированы все 32+ алиасов и функций
- ✅ Добавлены готовые workflows для типичных задач
- ✅ Полная интеграция Zellij + LazyVim + Productivity Tools

### v2.0 - 2025-11-09 (Windows)
- ✅ Сохранены все конфигурационные файлы с рабочей машины
- ✅ Alacritty (Windows) + Zellij (WSL) + LazyVim интеграция
- ✅ Готовые workspace layouts (40/60 и 50/50)
- ✅ Скрипт установки для WSL (install.sh)
- ✅ Alt+стрелки для навигации в Zellij
- ✅ Полная документация и примеры

### v1.0 - 2025-11-08 (Windows)
- 📚 Добавлено полное руководство по настройке (1281 строка)
- Объединены 3 источника: WSL, Alacritty, Neovim
- Готова структура для конфигурационных файлов

### v2.1 - 2025-11-08 (macOS)
- 🔧 Исправлена проблема с PATH для Zellij (установлен через Cargo)
- Добавлен `export PATH="$HOME/.cargo/bin:$PATH"` во все скрипты
- Обновлена документация

### v2.0 - 2025-11-06 (macOS)
- Изоляция автозапуска Zellij только для Alacritty
- Замена nvim-tree на Neo-tree с превью
- Упрощение layout 50/50
- Добавлена полная документация

---

## 🤝 Contributing

Это персональный репозиторий конфигураций, но вы можете использовать его как основу для своих настроек.

---

## 📄 License

MIT License - используйте как хотите!

---

**Автор**: [@your-username](https://github.com/your-username)
**Дата создания**: 2025-11-08

