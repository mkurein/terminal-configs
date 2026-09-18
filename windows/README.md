# 🪟 Windows + WSL Terminal Configuration

> **Статус**: Готово ✅ | Конфигурационные файлы ✅ | Документация ✅ | Автоустановка ✅

Конфигурация терминала для **Windows 11 + WSL Ubuntu** с **Alacritty / WezTerm + Zellij + LazyVim**.

> 💡 **Поддержка двух терминалов**: Alacritty (минималистичный, быстрый) или WezTerm (GPU + Kitty graphics)  
> 💡 **Поддержка Ubuntu и Debian WSL**  
> 🚀 **Автоматическая установка конфигураций** при первом запуске!  
> ⚡ **Быстрый запуск** из любой папки: команды `wa` и `ww`

**Версия**: 2.2 (обновлено 2025-11-17)

## 📦 Что включено

- ✅ **Alacritty** (Windows) - самый быстрый GPU-ускоренный терминал с интеграцией WSL
- ✅ **WezTerm** (Windows) - современный терминал с GPU, Kitty graphics и inline-изображениями
- ✅ **Zellij** (WSL) - terminal multiplexer с персистентностью
- ✅ **LazyVim** (WSL) - готовая сборка Neovim с плагинами
- ✅ **PowerShell aliases** - алиасы для PowerShell (gs, gq, gb и др.)
- ✅ **Workspace layouts** - готовые конфигурации (40/60 и 50/50)
- ✅ **Автозапуск** - Zellij запускается автоматически
- ✅ **Интерактивное меню** - выбор layout при запуске
- ✅ **Alt+стрелки** - навигация между панелями Zellij
- 🚀 **Автоустановка конфигов** - bat-файлы автоматически копируют конфигурации при первом запуске
- ⚡ **Быстрый запуск** - команды `wa` и `ww` из любой папки проводника

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

### 3. Установите терминал в Windows

**Вариант A: Alacritty** (рекомендуется для скорости)

```powershell
# Scoop (рекомендуется)
scoop install alacritty

# Или Chocolatey
choco install alacritty

# Или winget
winget install Alacritty.Alacritty
```

**Вариант B: WezTerm** (рекомендуется для rich-контента)

```powershell
# Scoop (рекомендуется)
scoop install wezterm

# Или Chocolatey
choco install wezterm

# Или winget
winget install wez.wezterm
```

### 4. Конфигурация установится автоматически! 🎉

**Конфигурации копируются автоматически** при первом запуске bat-файлов:
- `wa.bat`, `wa-ubuntu.bat`, `wa-debian.bat` → копируют конфиги Alacritty
- `ww.bat`, `wezterm-desktop.bat` → копируют конфиги WezTerm

**Или скопируйте вручную:**

```powershell
# Для Alacritty
Copy-Item windows\alacritty\*.toml $env:USERPROFILE\.config\alacritty\

# Для WezTerm
Copy-Item windows\wezterm\wezterm.lua $env:USERPROFILE\.config\wezterm\
```

### 5. Установите быстрые команды (опционально)

Установите команды `wa` и `ww` для запуска терминала из любой папки:

```powershell
# PowerShell от администратора
# Для Alacritty
Copy-Item windows\wa.bat C:\Windows\System32\

# Для WezTerm  
Copy-Item windows\ww.bat C:\Windows\System32\
```

**Теперь можно запускать терминал из проводника:**
1. Откройте любую папку в проводнике
2. Кликните в адресную строку
3. Введите `wa` (Alacritty) или `ww` (WezTerm)
4. Нажмите Enter
5. Терминал откроется в этой папке в WSL! 🚀

📖 **Подробные инструкции:**
- Alacritty: [INSTALL_WA.md](./INSTALL_WA.md)
- WezTerm: [INSTALL_WW.md](./INSTALL_WW.md)

### 6. Выберите дистрибутив WSL (если нужно)

**По умолчанию используется Ubuntu WSL.** Если у вас Debian или оба дистрибутива:

```powershell
# Проверить установленные дистрибутивы
wsl --list --verbose

# Установить дефолтный (если нужно)
wsl --set-default Ubuntu
# или
wsl --set-default Debian
```

#### 📂 Bat-файлы для разных дистрибутивов:

| Файл | Запускает | Использование |
|------|-----------|---------------|
| `wa.bat` | Основной запуск | Из любой папки |
| `wa-ubuntu.bat` | WSL Ubuntu + Zellij | Явно указан Ubuntu |
| `wa-debian.bat` | WSL Debian + Zellij | Явно указан Debian |
| `ww.bat` | WezTerm (Ubuntu) | Из любой папки |
| `alacritty-desktop.bat` | Alacritty | Ярлык на рабочем столе |
| `wezterm-desktop.bat` | WezTerm | Ярлык на рабочем столе |

### 7. Запустите терминал

Откройте Alacritty или WezTerm → появится меню выбора workspace! 🎉

---

## 📁 Что будет установлено

| Источник | Назначение (WSL) | Описание |
|----------|------------------|----------|
| `zellij/config.kdl` | `~/.config/zellij/config.kdl` | Конфигурация Zellij |
| `zellij/layouts/*.kdl` | `~/.config/zellij/layouts/` | Workspace layouts |
| `scripts/*.sh` | `~/` | Скрипты запуска и инструменты продуктивности |
| `zsh/aliases.zsh` | `~/.config/zsh/aliases.zsh` | Алиасы и функции (30+ команд) |

| Источник | Назначение (Windows) | Описание |
|----------|----------------------|----------|
| `alacritty/*.toml` | `%USERPROFILE%\.config\alacritty\` | Конфигурации Alacritty (3 файла) |
| `wezterm/wezterm.lua` | `%USERPROFILE%\.config\wezterm\` | Конфигурация WezTerm |
| `wa.bat` | `C:\Windows\System32\` (опционально) | Команда запуска Alacritty |
| `ww.bat` | `C:\Windows\System32\` (опционально) | Команда запуска WezTerm |
| `powershell/Microsoft.PowerShell_profile.ps1` | `$PROFILE` | Профиль PowerShell с алиасами |

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

- **[🚀 WezTerm Setup](./docs/WEZTERM_SETUP.md)** ⭐ NEW!  
  Полное руководство по WezTerm:
  - Установка и конфигурация WezTerm
  - GPU-ускорение и производительность
  - Kitty graphics protocol (inline-изображения)
  - Интеграция с WSL и Zellij
  - Темы и шрифты
  - Сравнение с Alacritty

- **[🚀 LazyVim Setup](./docs/LAZYVIM_SETUP.md)**  
  Краткое руководство по LazyVim:
  - Установка LazyVim в WSL
  - Основные горячие клавиши
  - Установка LSP серверов через Mason
  - Добавление плагинов
  - Кастомизация и настройка

- **[⚡ Productivity Tools](./docs/PRODUCTIVITY_TOOLS.md)**  
  Инструменты для повышения продуктивности:
  - Project Switcher - быстрое переключение между проектами
  - Backup & Sync - резервное копирование и синхронизация конфигов
  - Dev Environment - автоматическая настройка окружения
  - Git Quick - быстрые Git команды (add+commit+push одной командой)
  - Clean System - очистка и обслуживание WSL
  - Полезные алиасы и функции

- **[📁 WSL File Operations](./docs/WSL_FILE_OPERATIONS.md)**  
  Работа с файлами между WSL и Windows:
  - Копирование файлов (4 способа)
  - Буфер обмена (win32yank)
  - Доступ к WSL из Windows (`\\wsl$\`)
  - Доступ к Windows из WSL (`/mnt/c/`)
  - Best practices и оптимизация производительности
  - Troubleshooting

- **[🚀 Useful Aliases & Commands](./docs/USEFUL_ALIASES.md)**  
  Полный справочник по всем командам и алиасам:
  - 32+ алиасов для повседневной работы
  - Git quick commands (gq acp - add+commit+push!)
  - Productivity shortcuts (ps, backup, sync, clean)
  - Windows интеграция (open, clip, paste)
  - Zellij и LazyVim горячие клавиши
  - Готовые workflows для типичных задач

- **[💻 PowerShell Aliases](./powershell/README.md)** ⭐ NEW!  
  Алиасы для PowerShell:
  - Установка и настройка профиля
  - Git команды (gs, ga, gc, gp, gb, gq)
  - Навигация и файловые операции
  - Windows интеграция
  - Полный список команд

---

## 🚀 Быстрый запуск из проводника Windows

### Способы запуска терминала

#### 🎯 Способ 1: Команды `wa` и `ww` (Рекомендуется)

После установки в System32 (см. шаг 5), можно запускать терминал из любой папки:

**Alacritty (`wa`):**
1. Откройте любую папку в проводнике
2. Кликните в адресную строку
3. Введите `wa` и нажмите Enter
4. Alacritty откроется в этой папке в WSL! 🚀

**WezTerm (`ww`):**
1. Откройте любую папку в проводнике
2. Кликните в адресную строку
3. Введите `ww` и нажмите Enter
4. WezTerm откроется в этой папке в WSL! 🚀

📖 **Подробные инструкции:**
- [INSTALL_WA.md](./INSTALL_WA.md) - установка команды `wa`
- [INSTALL_WW.md](./INSTALL_WW.md) - установка команды `ww`

#### 🎯 Способ 2: Desktop shortcuts

Файлы для создания ярлыков на рабочем столе или в папках проектов:
- `alacritty-desktop.bat` — двойной клик открывает Alacritty в папке bat-файла
- `wezterm-desktop.bat` — двойной клик открывает WezTerm в папке bat-файла

**Использование:**
1. Скопируйте нужный bat-файл в папку проекта или на рабочий стол
2. Двойной клик → терминал откроется в этой папке в WSL!

**Особенности:**
- ✅ Автоматическое создание директории конфигурации
- ✅ Автоматическое копирование конфигов при первом запуске
- ✅ Поиск терминала в нескольких местах (PATH, Scoop, стандартные пути)
- ✅ Конвертация Windows путей в WSL пути
- ✅ Запуск zsh с правильными параметрами

#### 🎯 Способ 3: Контекстное меню (правый клик)

##### Для Alacritty:

**Создайте файл `alacritty-here.reg`:**

```reg
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\AlacrittyHere]
@="Open Alacritty Here"
"Icon"="C:\\Program Files\\Alacritty\\alacritty.exe"

[HKEY_CLASSES_ROOT\Directory\Background\shell\AlacrittyHere\command]
@="\"C:\\Project\\Project_Git\\terminal-configs\\windows\\wa.bat\""
```

**Установка:**
1. Отредактируйте путь к `wa.bat` в файле `alacritty-here.reg`
2. Двойной клик на `alacritty-here.reg`
3. Подтвердите добавление в реестр
4. Теперь ПКМ в папке → "Open Alacritty Here" ✨

##### Для WezTerm:

Аналогично создайте `wezterm-here.reg` или используйте готовый файл из репозитория.

### 🔧 Что происходит "под капотом"

Все bat-файлы теперь **умные** и делают следующее:

1. **Автоматически создают** директории конфигурации:
   - `%USERPROFILE%\.config\alacritty\`
   - `%USERPROFILE%\.config\wezterm\`

2. **Автоматически копируют** конфигурационные файлы при первом запуске

3. **Ищут исполняемый файл** в нескольких местах:
   - PATH (команда `where`)
   - Scoop (`%USERPROFILE%\.local\bin\`)
   - Стандартная установка (`C:\Program Files\`)
   - Local AppData (`%LOCALAPPDATA%\Programs\`)

4. **Конвертируют пути** Windows → WSL (`C:\Project\` → `/mnt/c/Project/`)

5. **Запускают zsh** с правильными параметрами для WSL

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

### Productivity Tools ✨ NEW!
- `ps` - быстрое переключение между проектами
- `gq acp "message"` - add + commit + push одной командой
- `devenv` - автонастройка окружения проекта
- `backup` - резервное копирование всех конфигов
- `sync` - синхронизация с репозиторием
- `clean` - очистка системы WSL
- `mkcd folder` - создать папку и перейти в нее
- `serve 3000` - запустить веб-сервер
- [См. полный список](./docs/PRODUCTIVITY_TOOLS.md)

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

## 🆚 Выбор терминала: Alacritty vs WezTerm

| Функция | Alacritty | WezTerm |
|---------|-----------|---------|
| **Скорость** | ⭐⭐⭐⭐⭐ Самый быстрый | ⭐⭐⭐⭐ Очень быстрый |
| **Размер** | ~8 MB | ~30 MB |
| **Конфигурация** | TOML | Lua (программируемая) |
| **Kitty graphics** | ❌ | ✅ |
| **Inline-изображения** | ❌ | ✅ |
| **Встроенные вкладки** | ❌ | ✅ |
| **Рекомендация** | Для максимальной скорости | Для rich-контента |

**Установить оба?** Можно использовать оба терминала параллельно! 🚀

---

---

## 📝 Changelog

### v2.4 - 2026-09-18
- 🚀 PowerShell: `github-fetch` / `github-pull` / `github-commit` / `github-push` / `github-gh` (шаблон `terminal-configs/github-proxy`)
- 📚 Remotes GitHub + Forgejo и проверка pull/push — корневой [README](../README.md)
- 🔒 Убран персональный путь из `wezterm-desktop.bat`

### v2.3 - 2025-11-27
- 🚀 Переработаны `wa.bat` и `ww.bat` — автоустановка конфигов + поиск терминала в Scoop/PATH
- ✅ Конвертация пути без `wsl wslpath` (чистый CMD)
- ✅ WezTerm сразу запускает Zellij + LazyVim меню (как Alacritty)
- ✅ Zellij layouts используют `nvim .` напрямую
- ✅ Убрана кириллица из bat-файлов

### v2.2 - 2025-11-17
- 🚀 **Автоматическая установка конфигураций** при первом запуске bat-файлов
- ✅ Исправлен `ww.bat` - теперь корректно запускается в WSL с zsh
- ✅ Улучшены все bat-файлы: автоматическое создание директорий и копирование конфигов
- ✅ Обновлена конфигурация WezTerm для Ubuntu WSL (было Debian)
- ✅ Добавлены `wa-ubuntu.bat` и `wa-debian.bat` для разных дистрибутивов
- ✅ Добавлены `alacritty-desktop.bat` и `wezterm-desktop.bat`
- ✅ Улучшена структура конфигураций: `~/.config/alacritty/` и `~/.config/wezterm/`
- ✅ Расширенный поиск исполняемых файлов (PATH, Scoop, стандартные пути)
- 📚 Обновлена документация с актуальными командами и путями

### v2.1 - 2025-11-10
- ✅ Добавлен WezTerm с GPU-ускорением и Kitty graphics
- ✅ Добавлены PowerShell aliases (профиль PowerShell)
- ✅ Полный справочник команд и алиасов (USEFUL_ALIASES.md)
- ✅ Документация по WezTerm (WEZTERM_SETUP.md)
- ✅ Productivity Tools - 9 скриптов + 32+ алиасов
- ✅ Поддержка Ubuntu и Debian WSL дистрибутивов

### v2.0 - 2025-11-09
- ✅ Сохранены все конфигурационные файлы с рабочей машины
- ✅ Alacritty (Windows) + Zellij (WSL) + LazyVim интеграция
- ✅ Готовые workspace layouts (40/60 и 50/50)
- ✅ Скрипт установки для WSL (install.sh)
- ✅ Alt+стрелки для навигации в Zellij
- ✅ Полная документация и примеры

---

**Версия**: 2.4 (`github-proxy`; терминал 2.3)  
**Дата**: 2026-09-18  
**Платформа**: Windows 11 + WSL Ubuntu (также поддерживается Debian)  
**Компоненты**: Alacritty, WezTerm, Zellij, LazyVim, Zsh, PowerShell, github-proxy

**См. также:** [macOS конфигурация](../macos/) - аналогичная структура для macOS

