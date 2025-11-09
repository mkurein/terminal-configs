# 🚀 Productivity Tools для WSL

Коллекция скриптов и алиасов для повышения продуктивности разработки.

## 📦 Установленные инструменты

### 1. 📁 Project Switcher (`ps`)

**Быстрый переход между проектами с опциональным запуском Neovim.**

```bash
ps              # Показать меню проектов
```

**Как использовать:**
1. Запустите `ps`
2. Выберите проект из списка
3. Выберите, открыть ли Neovim

**Настройка:**
Отредактируйте список проектов в `~/project-switcher.sh`:

```bash
PROJECTS=(
    "/mnt/c/Project/ProjectSnabjenie:ProjectSnabjenie"
    "/home/$USER/Projects:Home Projects"
    "/mnt/c/Project:All Projects"
)
```

---

### 2. 💾 Backup Configs (`backup`)

**Автоматическое резервное копирование всех конфигураций.**

```bash
backup          # Создать backup всех конфигов
```

**Что сохраняется:**
- Neovim config (`~/.config/nvim`)
- Zellij config (`~/.config/zellij`)
- Zsh config (`.zshrc`, `aliases.zsh`)
- Git config (`.gitconfig`)
- SSH config (`~/.ssh/config`)
- Скрипты запуска

**Особенности:**
- Backups сохраняются в `~/backups/` с датой и временем
- Автоматическое удаление backups старше 30 дней

---

### 3. 🔄 Sync Dotfiles (`sync`)

**Синхронизация конфигов между системой и репозиторием.**

```bash
sync            # Показать меню
sync push       # Сохранить конфиги В репозиторий
sync pull       # Загрузить конфиги ИЗ репозитория
```

**Workflow:**

**Push (сохранить изменения):**
```bash
# 1. Изменили конфиги в системе
# 2. Сохранить в репозиторий
sync push

# 3. Закоммитить и запушить
cd ~/terminal-configs
git add .
git commit -m "Update configs"
git push
```

**Pull (загрузить изменения):**
```bash
# 1. На другой машине
sync pull

# 2. Конфиги обновлены!
```

---

### 4. 🛠️ Dev Environment Setup (`devenv`)

**Автоматическая настройка окружения для проекта.**

```bash
devenv                    # В текущей папке
devenv /path/to/project   # В указанной папке
```

**Поддерживаемые типы проектов:**

| Тип | Определяется по | Что делает |
|-----|----------------|------------|
| Node.js | `package.json` | Предлагает `npm install` |
| Python | `requirements.txt`, `setup.py` | Создает venv, устанавливает зависимости |
| Rust | `Cargo.toml` | Показывает команды cargo |
| Go | `go.mod` | Предлагает `go mod download` |

---

### 5. ⚡ Git Quick (`gq`)

**Быстрые Git команды для ежедневной работы.**

```bash
gq s                    # git status
gq a                    # git add .
gq c "Fix bug"          # git commit -m "Fix bug"
gq p                    # git push
gq l                    # красивый git log

# Комбинированные команды:
gq ac "Update docs"     # add + commit
gq acp "Fix bug"        # add + commit + push
gq sync                 # синхронизация с main/master
gq undo                 # отменить последний коммит
```

**Примеры использования:**

```bash
# Быстрый коммит и push
gq acp "Add new feature"

# Отменить последний коммит (изменения сохранятся)
gq undo

# Синхронизация с основной веткой
gq sync
```

---

### 6. 🧹 Clean System (`clean`)

**Очистка и обслуживание системы WSL.**

```bash
clean           # Запустить очистку
```

**Что очищается:**
- ✅ APT кеш и неиспользуемые пакеты
- ✅ Cargo кеш (если установлен Rust)
- ✅ npm кеш (если установлен Node.js)
- ✅ Neovim кеш и swap файлы
- ✅ Старые сессии Zellij (старше 7 дней)
- ✅ Временные файлы
- ✅ Старые логи (старше 30 дней)

**Показывает освобожденное место на диске.**

---

## ⌨️ Полезные алиасы

### Навигация

```bash
c               # clear
..              # cd ..
...             # cd ../..
....            # cd ../../..
~               # cd ~
```

### Git алиасы

```bash
g               # git
gs              # git status
ga              # git add .
gc "message"    # git commit -m "message"
gp              # git push
gl              # git log (красивый)
gd              # git diff
```

### Python

```bash
py              # python3
pip             # pip3
venv            # создать и активировать venv
activate        # активировать существующий venv
```

### Docker (если используете)

```bash
d               # docker
dc              # docker-compose
dps             # docker ps
dpa             # docker ps -a
```

---

## 🔧 Полезные функции

### mkcd - создать и перейти в папку

```bash
mkcd my-new-project
# Создаст my-new-project/ и перейдет в нее
```

### ff - поиск файлов

```bash
ff config
# Найдет все файлы с "config" в имени
```

### search - поиск в содержимом

```bash
search "TODO"
# Найдет все файлы содержащие "TODO"
```

### dirsize - размер папки

```bash
dirsize
# Показать размер текущей папки

dirsize ~/Projects
# Показать размер указанной папки
```

### serve - быстрый веб-сервер

```bash
serve
# Запустит сервер на порту 8000

serve 3000
# Запустит сервер на порту 3000
```

### psgrep - поиск процессов

```bash
psgrep python
# Найдет все процессы с "python"
```

### code - открыть в VSCode

```bash
code .
# Откроет текущую папку в VSCode

code file.txt
# Откроет файл в VSCode
```

---

## 📚 Примеры workflow

### Начало работы над проектом

```bash
# 1. Переключиться на проект
ps
# Выбрать проект → откроется Neovim

# 2. Или вручную
cd /mnt/c/Project/MyProject
devenv
# Автоматически настроит окружение
```

### Ежедневная работа с Git

```bash
# Быстрый workflow
gq acp "Implement feature X"

# Или пошагово
gs                  # Проверить статус
ga                  # Добавить все файлы
gc "Fix bug"        # Коммит
gp                  # Push
```

### Синхронизация конфигов между машинами

**На машине 1 (где внесли изменения):**
```bash
sync push
cd ~/terminal-configs
gq acp "Update zsh aliases"
```

**На машине 2:**
```bash
cd ~/terminal-configs
git pull
sync pull
```

### Регулярное обслуживание

```bash
# Раз в неделю
clean               # Очистка системы
backup              # Backup конфигов
```

---

## 🎯 Pro Tips

### 1. Комбинируйте команды

```bash
ps && devenv && gq s
# Переключить проект → настроить окружение → проверить git статус
```

### 2. Используйте tab-completion

```bash
gq <TAB>            # Покажет доступные команды
cd /mnt/c/Pr<TAB>   # Автодополнение путей
```

### 3. История команд

```bash
Ctrl + R            # Поиск по истории команд
!!                  # Повторить последнюю команду
!$                  # Последний аргумент предыдущей команды
```

### 4. Создайте свои алиасы

Добавьте в `~/.config/zsh/aliases.zsh`:

```bash
alias myproject='cd /mnt/c/Project/MyProject && n .'
alias deploy='./deploy.sh && gq acp "Deploy"'
```

---

## 📋 Checklist для новой машины

- [ ] Клонировать репозиторий terminal-configs
- [ ] Запустить `windows/install.sh`
- [ ] Скопировать Alacritty config в Windows
- [ ] Настроить `wa.bat` для проводника
- [ ] Отредактировать список проектов в `project-switcher.sh`
- [ ] Настроить Git config
- [ ] Установить необходимые LSP через Mason
- [ ] Создать первый backup: `backup`
- [ ] Проверить все скрипты: `ps`, `gq`, `devenv`, `clean`

---

## 🔗 Связанная документация

- [README.md](../README.md) - Общая информация
- [COMPLETE_SETUP_GUIDE.md](./COMPLETE_SETUP_GUIDE.md) - Полная настройка
- [LAZYVIM_SETUP.md](./LAZYVIM_SETUP.md) - LazyVim инструкция

---

**Версия**: 1.0  
**Дата**: 2025-11-09  
**Автор**: Terminal Configs Project

**Удачной разработки! 🚀**

