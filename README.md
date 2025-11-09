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
Полная конфигурация для Windows 11 + WSL Debian.

📖 **Документация**: [COMPLETE_SETUP_GUIDE.md](./windows/docs/COMPLETE_SETUP_GUIDE.md)

**Версия**: 2.0 (обновлено 2025-11-09)

**Особенности**:
- Alacritty в Windows с интеграцией WSL
- Zellij с Alt+стрелки навигацией
- LazyVim с полной настройкой
- Готовые workspace layouts (40/60 и 50/50)
- Автоматическое меню выбора layout
- Скрипт установки для WSL
- ✨ **NEW**: Productivity Tools - 6 скриптов + 30+ алиасов для ускорения работы

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
    └── docs/
        ├── COMPLETE_SETUP_GUIDE.md        # Полное руководство (1281 строка)
        └── LAZYVIM_SETUP.md               # Руководство по LazyVim
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

## 📝 Changelog

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

