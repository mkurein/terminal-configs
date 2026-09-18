# 📚 Документация по настройке Zellij + Alacritty + MacOS

## 🎯 Обзор

Данная документация описывает настроенную систему управления терминальными сессиями с использованием:
- **Alacritty** - быстрый GPU-ускоренный эмулятор терминала (MacOS)
- **Zellij** - современный terminal multiplexer (запускается только в Alacritty)
- **Zsh** - оболочка командной строки (с Oh My Zsh)
- **Neovim** - текстовый редактор с Lazy.nvim + Neo-tree (файловый менеджер с превью)

> 📖 **См. также**: Полная шпаргалка по навигации в Neovim: [`NEOVIM_NAVIGATION.md`](NEOVIM_NAVIGATION.md)

## 🏗️ Архитектура и принципы работы

### Цепочка запуска

```
MacOS
    └─ Alacritty (терминальный эмулятор)
        └─ alacritty-start.sh (wrapper скрипт)
            └─ start-zellij-choose.sh (меню выбора)
                └─ Zellij (terminal multiplexer)
                    └─ Workspace layouts с панелями
```

### Принципы

1. **Изолированный автозапуск**: Zellij запускается ТОЛЬКО в Alacritty (другие терминалы работают без Zellij)
2. **Персистентность**: Layout файлы позволяют воссоздать структуру рабочего пространства после перезагрузки
3. **Гибкость**: Несколько предустановленных layout на выбор (40/60, 50/50)
4. **Интеграция**: Neovim с Neo-tree автоматически открывается в нужной директории, htop для мониторинга

## 📁 Структура файлов

### MacOS — домашняя директория (`~`)

```
~/
├── .config/
│   ├── alacritty/
│   │   └── alacritty.toml              # Конфигурация Alacritty
│   ├── zellij/
│   │   └── layouts/
│   │       ├── workspaceVPNmanage.kdl      # Layout 40/60 (4 панели, 2 таба)
│   │       └── workspaceVPNmanage-5050.kdl # Layout 50/50 (3 панели, 1 таб)
│   ├── zsh/
│   │   └── aliases.zsh                 # Алиасы (включая n=nvim)
│   └── nvim/
│       └── init.lua                    # Конфигурация Neovim с Lazy.nvim + Neo-tree
├── .zshrc                              # Конфигурация Zsh БЕЗ автозапуска Zellij
├── alacritty-start.sh                  # Wrapper для Alacritty (автозапуск Zellij)
├── start-zellij-choose.sh              # Скрипт выбора layout
├── start-vpn-manage.sh                 # Прямой запуск layout 40/60
└── start-vpn-manage-5050.sh            # Прямой запуск layout 50/50
```

## 📋 Конфигурационные файлы

### 1. Layout: workspaceVPNmanage.kdl (40% левая / 60% правая)

**Путь**: `~/.config/zellij/layouts/workspaceVPNmanage.kdl`

**Структура**:
- **Tab 1: "VPNserverManage"** (фокус по умолчанию)
  - Левая сторона (40%):
    - Верх (60%): Терминал в `~/.config`
    - Низ (40%): `htop` - мониторинг системы
  - Правая сторона (60%):
    - Верх (70%): Neovim (алиас `n`) в проекте VPNserverManage-Clean
    - Низ (30%): Терминал в проекте
- **Tab 2: "Config"**
  - Терминал в `~/.config`

---

### 2. Layout: workspaceVPNmanage-5050.kdl (50% / 50%)

**Путь**: `~/.config/zellij/layouts/workspaceVPNmanage-5050.kdl`

**Структура**:
- **Tab 1: "VPNserverManage"** (единственный таб, фокус по умолчанию)
  - Левая сторона (50%):
    - Верх (60%): Терминал в `~/.config`
    - Низ (40%): `htop` - мониторинг системы
  - Правая сторона (50%):
    - **Neovim на всю высоту** - проект VPNserverManage-Clean с Neo-tree

---

### 3. Скрипт выбора layout

**Путь**: `~/start-zellij-choose.sh`

```bash
#!/bin/bash

# Добавляем cargo bin в PATH для Zellij
export PATH="$HOME/.cargo/bin:$PATH"

# Если уже в zellij - выходим
if [[ -n "$ZELLIJ" ]]; then
    exit 0
fi

echo "Выберите workspace layout:"
echo "1) workspaceVPNmanage (40% лево / 60% право) - для VPNserverManage"
echo "2) workspaceVPNmanage-5050 (50% / 50%) - для VPNserverManage"
echo "3) Запустить без layout"
echo ""
read -p "Ваш выбор (1-3): " choice

case $choice in
    1)
        echo "Запускаю workspaceVPNmanage..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage.kdl"
        ;;
    2)
        echo "Запускаю workspaceVPNmanage-5050..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage-5050.kdl"
        ;;
    3)
        echo "Запускаю без layout..."
        exec zellij
        ;;
    *)
        echo "Неверный выбор, запускаю workspaceVPNmanage по умолчанию..."
        exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage.kdl"
        ;;
esac
```

**Назначение**: Интерактивный выбор layout при запуске. Используется автоматически из `.zshrc`.

---

### 4. Wrapper скрипт для Alacritty

**Путь**: `~/alacritty-start.sh`

```bash
#!/bin/bash

# Wrapper для запуска Zellij только из Alacritty
# Используется в ~/.config/alacritty/alacritty.toml

# Добавляем cargo bin в PATH для Zellij
export PATH="$HOME/.cargo/bin:$PATH"

# Если уже в Zellij - просто запустить zsh
if [[ -n "$ZELLIJ" ]]; then
    exec zsh -l
fi

# Иначе - показать меню выбора workspace
exec ~/start-zellij-choose.sh
```

**Назначение**:
- Запускается ТОЛЬКО из Alacritty
- Изолирует автозапуск Zellij от других терминалов
- Проверяет, не запущен ли уже Zellij
- Вызывает меню выбора layout

---

### 5. Конфигурация Zsh

**Путь**: `~/.zshrc`

**Важно**: В `.zshrc` НЕТ автозапуска Zellij! Это сделано намеренно, чтобы Zellij запускался только в Alacritty.

**Назначение**:
- Обычная конфигурация Zsh (Oh My Zsh, Powerlevel10k, плагины)
- Позволяет работать в других терминалах без Zellij

---

### 6. Конфигурация Alacritty

**Путь**: `~/.config/alacritty/alacritty.toml`

**Релевантная секция**:

```toml
[terminal.shell]
program = "~/alacritty-start.sh"
```

**Назначение**:
- Запускает wrapper скрипт вместо прямого запуска zsh
- Wrapper показывает меню выбора Zellij workspace
- Изолирует автозапуск Zellij только для Alacritty

---

### 7. Алиас для Neovim

**Путь**: `~/.config/zsh/aliases.zsh`

```bash
alias n=nvim
```

**Назначение**: Быстрый запуск Neovim через алиас `n`

---

### 8. Конфигурация Neovim

**Путь**: `~/.config/nvim/init.lua`

**Особенности**:
- **Neo-tree** - современный файловый менеджер с превью файлов
- **LSP** - Pyright, TypeScript, Go, Rust
- **Автодополнение** - nvim-cmp с LuaSnip
- **Telescope** - fuzzy finder с превью
- **Git интеграция** - gitsigns
- **Автоформатирование** - conform.nvim
- **Тема** - Kanagawa с прозрачным фоном

**Горячие клавиши Neo-tree**:
- `Space + e` - открыть/закрыть Neo-tree
- `P` (в Neo-tree) - превью файла
- См. полную документацию: `~/ForZellij/NEOVIM_NAVIGATION.md`

## 🚀 Способы запуска

### 1. Автоматический (по умолчанию)

Просто откройте **Alacritty** → автоматически появится меню выбора layout.

### 2. Ручной запуск с выбором

```bash
~/start-zellij-choose.sh
```

### 3. Прямой запуск конкретного layout

```bash
# Layout 40/60
~/start-vpn-manage.sh

# Layout 50/50
~/start-vpn-manage-5050.sh
```

### 4. Запуск без layout

```bash
zellij
```

## ⌨️ Горячие клавиши Zellij

### Управление панелями (`Ctrl+p`)

- `Ctrl+p` → `n` - новая панель
- `Ctrl+p` → стрелки - переключение между панелями
- `Ctrl+p` → `x` - закрыть панель
- `Ctrl+p` → `f` - полноэкранный режим для панели
- `Ctrl+p` → `z` - свернуть/развернуть панель

### Управление табами (`Ctrl+t`)

- `Ctrl+t` → `n` - новый таб
- `Ctrl+t` → `→/←` - переключение между табами
- `Ctrl+t` → `x` - закрыть таб
- `Ctrl+t` → `r` - переименовать таб
- `Ctrl+t` → `[1-9]` - перейти к табу по номеру

### Изменение размера (`Ctrl+n`)

- `Ctrl+n` → стрелки - изменить размер панели
- `Ctrl+n` → `+/-` - увеличить/уменьшить

### Режим поиска (`Ctrl+s`)

- `Ctrl+s` - войти в режим поиска по истории

### Общие

- `Ctrl+q` - выйти из Zellij
- `Ctrl+o` - режим управления сессией
- `Ctrl+g` - выход из любого режима (back to normal)

## 🔧 Настройка и кастомизация

### Изменить автозапуск на конкретный layout

Отредактируйте `~/.zshrc`, замените:

```bash
# Было
if [[ -z "$ZELLIJ" ]]; then
    ~/start-zellij-choose.sh
fi

# Станет (например, всегда 40/60)
if [[ -z "$ZELLIJ" ]]; then
    ~/start-vpn-manage.sh
fi
```

### Создать новый layout

1. Создайте файл в `~/.config/zellij/layouts/my-new-layout.kdl`
2. Используйте существующие как шаблон
3. Запустите: `zellij --layout ~/.config/zellij/layouts/my-new-layout.kdl`

### Изменить пропорции панелей

В layout файле измените значения `size`:
- `size="40%"` - 40% от родительской панели
- `size="70%"` - 70% от родительской панели

### Изменить путь к проекту

В layout файлах замените путь:

```kdl
cwd "~/Project/ProjectPython/VPNserverManage-Clean"
```

на нужный вам путь к проекту.

### Добавить новые команды в панели

```kdl
pane {
    cwd "/path/to/directory"
    command "your-command"
    args "arg1" "arg2"
}
```

## 🐛 Устранение неполадок

### Проблема: Alacritty закрывается сразу после выбора layout

**Причина**: Zellij установлен через Cargo и находится в `~/.cargo/bin/`, но этот путь не в `PATH` при запуске из Alacritty.

**Решение**: В начале всех скриптов запуска добавлена строка:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

Это исправление уже применено к:
- `~/alacritty-start.sh`
- `~/start-zellij-choose.sh`
- `~/start-vpn-manage.sh`
- `~/start-vpn-manage-5050.sh`

**Проверка**: Если проблема возникла снова, убедитесь, что в скриптах есть эта строка после `#!/bin/bash`.

### Проблема: Status bar не виден

**Решение**: Убедитесь, что в layout есть `default_tab_template` с `zellij:status-bar`:

```kdl
default_tab_template {
    pane size=1 borderless=true {
        plugin location="zellij:tab-bar"
    }
    children
    pane size=2 borderless=true {
        plugin location="zellij:status-bar"
    }
}
```

### Проблема: Алиас `n` не работает в layout

**Решение**: Запускайте команду через интерактивный shell:

```kdl
command "zsh"
args "-i" "-c" "n ."
```

### Проблема: Zellij запускается во всех терминалах

**Решение**:
1. Убедитесь, что в `.zshrc` НЕТ автозапуска Zellij
2. Автозапуск должен быть ТОЛЬКО в `~/alacritty-start.sh`
3. Alacritty должен использовать wrapper: `program = "~/alacritty-start.sh"`

### Проблема: Меню выбора не появляется в Alacritty

**Решение**: Проверьте, что:
1. Скрипты исполняемые:
   ```bash
   chmod +x ~/alacritty-start.sh
   chmod +x ~/start-zellij-choose.sh
   ```
2. Alacritty использует wrapper скрипт (проверьте `~/.config/alacritty/alacritty.toml`)
3. Wrapper НЕ блокируется Powerlevel10k instant prompt

### Проблема: Neo-tree не работает

**Решение**:
1. Откройте Neovim: `nvim`
2. Дождитесь установки плагинов (Lazy.nvim сделает это автоматически)
3. Используйте `Space + e` для открытия Neo-tree

### Проблема: htop не установлен

**Решение**: Установите htop через Homebrew:

```bash
brew install htop
```

## 📦 Требования

### Установленные компоненты

- MacOS
- Alacritty
- Zellij
- Zsh (с Oh My Zsh)
- Neovim (с Lazy.nvim)
- htop

### Установка отсутствующих компонентов

```bash
# Homebrew (если не установлен)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Alacritty
brew install --cask alacritty

# Zellij
brew install zellij

# Neovim
brew install neovim

# htop
brew install htop

# Oh My Zsh (если не установлен)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 📝 Заметки

1. **Путь к проекту**: `~/Project/ProjectPython/VPNserverManage-Clean` — подставьте свой
2. **Домашняя директория**: `~` (`$HOME`)
3. **Алиас `n`**: Настроен в `~/.config/zsh/aliases.zsh` как `n='nvim'`
4. **Персистентность сессий**: Zellij сессии сохраняются в `~/.local/share/zellij/`, но layouts позволяют быстро воссоздать структуру
5. **Shell**: Используется Zsh с Oh My Zsh и темой Powerlevel10k
6. **Изоляция Zellij**: Zellij запускается ТОЛЬКО в Alacritty, другие терминалы работают с обычным zsh
7. **Neo-tree**: Современный файловый менеджер с превью (`Space + e` → `P` на файле)
8. **Документация Neovim**: Полная шпаргалка по навигации в `~/ForZellij/NEOVIM_NAVIGATION.md`

## 🔄 Backup и восстановление

### Создать backup

```bash
# Backup layouts и скриптов
tar -czf ~/zellij-backup-$(date +%Y%m%d).tar.gz \
  ~/.config/zellij/layouts/ \
  ~/start-*.sh \
  ~/alacritty-start.sh

# Backup конфигов
cp ~/.zshrc ~/.zshrc.backup
cp ~/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml.backup
cp ~/.config/nvim/init.lua ~/.config/nvim/init.lua.backup
```

### Восстановление

```bash
# Восстановить layouts
tar -xzf ~/zellij-backup-YYYYMMDD.tar.gz -C ~/

# Восстановить конфиги
cp ~/.zshrc.backup ~/.zshrc
cp ~/.config/alacritty/alacritty.toml.backup ~/.config/alacritty/alacritty.toml
```

## 🆚 Отличия от Windows/WSL настройки

1. **Нет WSL**: Прямой запуск в нативном MacOS окружении
2. **Пути**: Используются MacOS пути (`/Users/...` вместо `/mnt/c/...`)
3. **Shell**: Zsh с Oh My Zsh вместо базового Zsh
4. **Alacritty**: Конфигурация в TOML формате в `~/.config/alacritty/`
5. **Homebrew**: Управление пакетами через Homebrew вместо apt
6. **Изоляция**: Wrapper скрипт для изоляции Zellij только в Alacritty
7. **Neo-tree**: Вместо nvim-tree - современный файловый менеджер с превью

## 📚 Дополнительные ресурсы

- [Zellij Documentation](https://zellij.dev/)
- [Zellij Layouts Guide](https://zellij.dev/documentation/layouts.html)
- [Alacritty Configuration](https://alacritty.org/config-alacritty.html)
- [Oh My Zsh](https://ohmyz.sh/)
- [Neovim Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
- **Локальная документация**: `~/ForZellij/NEOVIM_NAVIGATION.md` - шпаргалка по навигации в Neovim

---

**Дата создания**: 2025-11-06
**Последнее обновление**: 2025-11-08
**Версия**: 2.1
**Платформа**: MacOS
**Автор настройки**: Claude Code

**Изменения в v2.1**:
- 🔧 Исправлена проблема с PATH для Zellij (установлен через Cargo)
- Добавлен `export PATH="$HOME/.cargo/bin:$PATH"` во все скрипты запуска
- Обновлена документация с новым разделом устранения неполадок

**Изменения в v2.0**:
- Изоляция автозапуска Zellij только для Alacritty через wrapper
- Замена nvim-tree на Neo-tree с превью файлов
- Упрощение layout 50/50 (3 панели вместо 4, 1 таб вместо 2)
- Добавлена полная документация по навигации в Neovim

## 🚀 Быстрый старт

1. Откройте **Alacritty** (только в нем запустится Zellij!)
2. Выберите layout из меню:
   - **Вариант 1** (40/60) - для кодирования, больше места под Neovim
   - **Вариант 2** (50/50) - минималистичный, 3 панели
3. Neovim автоматически откроется в проекте VPNserverManage-Clean
4. Откройте файловый менеджер: `Space + e`
5. Выберите файл и нажмите `P` для превью! 👁️
6. Начните работу!

**Советы**:
- `Ctrl+g` - выйти из любого режима Zellij
- `Space + e` - открыть Neo-tree
- `Space + ff` - найти файл через Telescope
- `?` (в Neo-tree) - показать все команды
- См. полную шпаргалку: `~/ForZellij/NEOVIM_NAVIGATION.md`
