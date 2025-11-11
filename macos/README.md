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

**Версия**: 2.2
**Дата**: 2025-11-11
**Платформа**: macOS

## 📋 Changelog v2.2 (2025-11-11)

### 🐛 Исправления:
- ✅ **КРИТИЧНО**: Удалён Windows-алиас `open=explorer.exe` из `macos/zsh/aliases.zsh`
- ✅ Добавлен комментарий о несовместимости Windows-алиасов с macOS
- ✅ Улучшена документация по устранению неполадок
- ✅ Добавлен диагностический скрипт `check-alacritty-setup.sh`

### 📚 Документация:
- ✅ Расширен раздел "Устранение неполадок"
- ✅ Добавлено описание известных проблем и их решений
- ✅ Добавлены инструкции по диагностике

См. [CHANGELOG](../README.md#-changelog) для полной истории изменений.

