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
cwd "/Users/olgazaharova/Project/ProjectPython/VPNserverManage-Clean"
```

на ваш путь к проекту.

### Создать свой layout

1. Скопируйте существующий layout:
```bash
cp ~/.config/zellij/layouts/workspaceVPNmanage.kdl ~/.config/zellij/layouts/my-layout.kdl
```

2. Отредактируйте под свои нужды

3. Добавьте в `start-zellij-choose.sh` новый пункт меню

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

### Alacritty закрывается после выбора

**Проблема**: Zellij не в PATH.

**Решение**: Убедитесь, что все скрипты содержат:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

### Меню не появляется

**Проверьте**:
1. Права на исполнение: `ls -la ~/alacritty-start.sh`
2. Путь в `alacritty.toml`: должен быть полный путь к `alacritty-start.sh`

### Neo-tree не работает

**Решение**:
1. Откройте Neovim: `nvim`
2. Дождитесь установки плагинов (Lazy.nvim)
3. `:checkhealth` - проверьте статус

## 📝 Заметки

- **Zellij работает ТОЛЬКО в Alacritty** - другие терминалы используют обычный zsh
- **Персистентность**: layouts сохраняются, сессии восстанавливаются
- **Neo-tree**: современная альтернатива nvim-tree с превью файлов
- **Алиас `n`**: быстрый запуск Neovim (`n .` в layouts)

## 🔄 Обновление

Чтобы обновить конфигурацию из репозитория:

```bash
cd ~/terminal-configs-backup
git pull
cd macos
./install.sh
```

---

**Версия**: 2.1
**Дата**: 2025-11-08
**Платформа**: macOS

См. [CHANGELOG](../README.md#-changelog) для истории изменений.

