# 🪟 Windows + WSL Terminal Configuration

> **Статус**: Готово ✅ | Конфигурационные файлы ✅ | Документация ✅

Конфигурация терминала для **Windows 11 + WSL Debian** с **Alacritty + Zellij + LazyVim**.

## 📦 Что включено

- ✅ **Alacritty** (Windows) - быстрый GPU-ускоренный терминал с интеграцией WSL
- ✅ **Zellij** (WSL) - terminal multiplexer с персистентностью
- ✅ **LazyVim** (WSL) - готовая сборка Neovim с плагинами
- ✅ **Workspace layouts** - готовые конфигурации (40/60 и 50/50)
- ✅ **Автозапуск** - Zellij запускается автоматически из Alacritty
- ✅ **Интерактивное меню** - выбор layout при запуске
- ✅ **Alt+стрелки** - навигация между панелями Zellij

## 🚀 Быстрая установка

### 1. Установите зависимости в WSL

```bash
# Обновление системы
sudo apt update && sudo apt upgrade -y

# Основные компоненты
sudo apt install zsh neovim htop build-essential -y

# Rust (для Zellij)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Zellij
cargo install zellij

# Oh My Zsh (опционально)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 2. Запустите установку WSL конфигов

```bash
cd windows
chmod +x install.sh
./install.sh
```

### 3. Установите Alacritty в Windows

**Вариант 1: Scoop**
```powershell
scoop install alacritty
```

**Вариант 2: Chocolatey**
```powershell
choco install alacritty
```

**Вариант 3:** [Скачайте с GitHub](https://github.com/alacritty/alacritty/releases)

### 4. Скопируйте конфиг Alacritty в Windows

```powershell
# В PowerShell
Copy-Item windows\alacritty\alacritty.toml $env:APPDATA\alacritty\
```

### 5. Перезапустите Alacritty

Откройте Alacritty → появится меню выбора workspace! 🎉

---

## 📁 Что будет установлено

| Источник | Назначение (WSL) | Описание |
|----------|------------------|----------|
| `zellij/config.kdl` | `~/.config/zellij/config.kdl` | Конфигурация Zellij |
| `zellij/layouts/*.kdl` | `~/.config/zellij/layouts/` | Workspace layouts |
| `scripts/*.sh` | `~/` | Скрипты запуска |
| `zsh/aliases.zsh` | `~/.config/zsh/aliases.zsh` | Алиасы (n=nvim) |

| Источник | Назначение (Windows) | Описание |
|----------|----------------------|----------|
| `alacritty/alacritty.toml` | `%APPDATA%\alacritty\alacritty.toml` | Конфигурация Alacritty |

---

## 📖 Документация

### Руководства:

- **[📚 Полное руководство по настройке](./docs/COMPLETE_SETUP_GUIDE.md)**  
  Объединенное руководство (1281 строка):
  - Установка и настройка WSL2
  - Alacritty: установка, конфигурация, темы, шрифты
  - Neovim: полная настройка с плагинами
  - LSP и автодополнение
  - Менеджеры плагинов (Lazy.nvim)

- **[🚀 LazyVim Setup](./docs/LAZYVIM_SETUP.md)**  
  Краткое руководство по LazyVim:
  - Установка LazyVim в WSL
  - Основные горячие клавиши
  - Установка LSP серверов через Mason
  - Добавление плагинов
  - Кастомизация и настройка

---

## 🔧 Основные возможности

### Alacritty + WSL Integration
- Запуск WSL Debian напрямую
- GPU-ускорение для быстрой отрисовки
- Прозрачность окна (opacity 0.95)
- Шрифт Cascadia Code с лигатурами
- Тема Gruvbox Dark

### Zellij Configuration
- Alt + стрелки для навигации между панелями
- Кастомные горячие клавиши
- Поддержка плавающих панелей
- Режимы: pane, tab, resize, move, scroll

### Workspace Layouts

**1. workspacePrjSnabjenie.kdl** (40/60 split):
- 40% слева: терминал + htop
- 60% справа: Neovim (70%) + терминал (30%)
- Автозапуск Neovim в проекте

**2. my-workspace.kdl** (50/50 split):
- 50% слева: терминал + htop
- 50% справа: Neovim + терминал
- Симметричная раскладка

---

## ⌨️ Горячие клавиши

### Zellij
- `Alt + стрелки` - переключение между панелями (быстро!)
- `Ctrl + p` → `n` - новая панель
- `Ctrl + t` → `n` - новый таб
- `Ctrl + n` - режим изменения размера
- `Ctrl + q` - выход из Zellij
- `Alt + n` - новая панель (без переключения режима)
- `Alt + f` - плавающие панели

### Alacritty
- `Ctrl + Shift + V` - вставить
- `Ctrl + Shift + C` - копировать
- `Ctrl + Plus/Minus` - изменить размер шрифта
- `F11` - полноэкранный режим

### LazyVim (Neovim)
- `Space + e` - Neo-tree (файловый менеджер)
- `Space + ff` - найти файл
- `Space + fg` - поиск по содержимому
- `gd` - перейти к определению
- `K` - показать документацию

---

## 🔧 Настройка под себя

### Изменить путь к проекту в layouts

Отредактируйте файлы в `zellij/layouts/*.kdl`:

```kdl
cwd "/mnt/c/Project/ProjectSnabjenie"
```

Замените на путь к вашему проекту в WSL.

### Добавить свой layout

1. Скопируйте существующий layout:
```bash
cp ~/.config/zellij/layouts/workspacePrjSnabjenie.kdl ~/.config/zellij/layouts/my-custom.kdl
```

2. Отредактируйте под свои нужды

3. Добавьте в `start-zellij-choose.sh`:
```bash
echo "3) my-custom - мой layout"
# ...
3)
    exec zellij --layout "$HOME/.config/zellij/layouts/my-custom.kdl"
    ;;
```

### Изменить тему Alacritty

В `alacritty.toml` раскомментируйте нужную тему:

```toml
[general]
import = [
    # "~\\AppData\\Roaming\\alacritty\\themes\\themes\\tokyo-night.toml"
    "~\\AppData\\Roaming\\alacritty\\themes\\themes\\gruvbox_dark.toml"
    # "~\\AppData\\Roaming\\alacritty\\themes\\themes\\catppuccin_mocha.toml"
]
```

---

## 🐛 Устранение неполадок

### Zellij не запускается
```bash
# Проверьте, что Zellij в PATH
which zellij
# Должно быть: /home/USERNAME/.cargo/bin/zellij

# Добавьте в ~/.zshrc или ~/.bashrc:
export PATH="$HOME/.cargo/bin:$PATH"
```

### Alt + стрелки не работают
Проверьте, что в `alacritty.toml` есть bindings:
```toml
[[keyboard.bindings]]
key = "Left"
mods = "Alt"
chars = "\u001b[1;3D"
```

### Neovim: LazyVim не установился
```bash
# Удалите старую конфигурацию
rm -rf ~/.config/nvim ~/.local/share/nvim

# Установите LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
nvim  # При первом запуске установятся плагины
```

### WSL: медленный запуск
Отключите антивирус для папки проекта в Windows или переместите проект в WSL:
```bash
# Вместо /mnt/c/Project используйте:
~/Project
```

---

## 📝 Заметки

- **Alacritty** запускается в Windows нативно (GPU-ускорение)
- **Zellij, Neovim, Zsh** работают в WSL (Linux окружение)
- **Персистентность**: layouts и сессии сохраняются
- **LazyVim**: готовая сборка с LSP, автодополнением, файловым менеджером
- **Алиас `n`**: быстрый запуск Neovim (`n .` открывает текущую папку)

---

## 🔄 Обновление конфигурации

Чтобы обновить из репозитория:

```bash
cd ~/terminal-configs
git pull
cd windows
./install.sh
```

Для Alacritty (Windows):
```powershell
Copy-Item terminal-configs\windows\alacritty\alacritty.toml $env:APPDATA\alacritty\
```

---

## 📚 Дополнительные ресурсы

- [Neovim официальный сайт](https://neovim.io)
- [Alacritty GitHub](https://github.com/alacritty/alacritty)
- [Zellij Documentation](https://zellij.dev)
- [LazyVim](https://www.lazyvim.org)
- [Nerd Fonts](https://www.nerdfonts.com)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

---

**Версия**: 2.0 (полная конфигурация)
**Дата**: 2025-11-09
**Платформа**: Windows 11 + WSL Debian
**Компоненты**: Alacritty, Zellij, LazyVim, Zsh

**См. также:** [macOS конфигурация](../macos/) - аналогичная структура для macOS

