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

---

### 🪟 [Windows](./windows/)
Полное руководство по настройке для Windows + WSL.

📖 **Документация**: [COMPLETE_SETUP_GUIDE.md](./windows/docs/COMPLETE_SETUP_GUIDE.md)

**Версия**: 1.0 - Документация (обновлено 2025-11-08)

**Включает**:
- Установка и настройка WSL2
- Alacritty: полная конфигурация для всех платформ
- Neovim: от установки до продвинутых плагинов
- LSP и автодополнение
- 1000+ строк подробных инструкций

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

### Windows

*(Инструкции будут добавлены после настройки Windows конфигурации)*

---

## 📁 Структура репозитория

```
terminal-configs/
├── README.md                          # Главный README
├── macos/                             # Конфигурация для macOS
│   ├── README.md                      # README для macOS
│   ├── install.sh                     # Скрипт установки
│   ├── alacritty/
│   │   └── alacritty.toml             # Конфигурация Alacritty
│   ├── zellij/
│   │   └── layouts/
│   │       ├── workspaceVPNmanage.kdl     # Layout 40/60
│   │       └── workspaceVPNmanage-5050.kdl # Layout 50/50
│   ├── scripts/
│   │   ├── alacritty-start.sh         # Wrapper для автозапуска
│   │   ├── start-zellij-choose.sh     # Меню выбора layout
│   │   ├── start-vpn-manage.sh        # Прямой запуск 40/60
│   │   └── start-vpn-manage-5050.sh   # Прямой запуск 50/50
│   ├── zsh/
│   │   └── aliases.zsh                # Алиасы (n=nvim)
│   └── docs/
│       └── ZELLIJ_SETUP_MACOS.md      # Полная документация
└── windows/                           # Конфигурация для Windows
    ├── README.md                      # README для Windows
    └── docs/                          # Документация (будет добавлена)
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

### Windows
*(Требования будут добавлены)*

---

## 📝 Changelog

### v1.0 - 2025-11-08 (Windows)
- 📚 Добавлено полное руководство по настройке (1000+ строк)
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

