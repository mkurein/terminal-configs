# 🚀 Полезные Aliases и Команды

Полный справочник по всем установленным алиасам, функциям и командам для повышения продуктивности в WSL.

## 📋 Содержание

- [Редактирование и навигация](#-редактирование-и-навигация)
- [Git команды](#-git-команды)
- [Productivity Tools](#-productivity-tools)
- [Системные команды](#-системные-команды)
- [Windows интеграция](#-windows-интеграция)
- [Сетевые команды](#-сетевые-команды)
- [Функции](#-функции)
- [Zellij горячие клавиши](#-zellij-горячие-клавиши)
- [LazyVim горячие клавиши](#-lazyvim-горячие-клавиши)

---

## 📝 Редактирование и навигация

### Neovim

```bash
n                    # Открыть Neovim
n .                  # Открыть Neovim в текущей папке
n file.txt           # Открыть файл в Neovim
```

**Примеры:**
```bash
n ~/.zshrc           # Редактировать .zshrc
n .                  # Открыть файловый менеджер в текущей папке
```

---

### Навигация по директориям

```bash
..                   # cd ..              (на уровень вверх)
...                  # cd ../..           (на 2 уровня вверх)
....                 # cd ../../..        (на 3 уровня вверх)
~                    # cd ~               (домашняя директория)

c                    # clear              (очистить экран)
```

**Примеры:**
```bash
..                   # Перейти в родительскую папку
...                  # Быстро подняться на 2 уровня
cd /mnt/c/Project && ~  # Вернуться домой
```

---

### Просмотр файлов

```bash
l                    # ls -lah            (подробный список с размерами)
ll                   # ls -lh             (список с размерами)
la                   # ls -lAh            (все файлы включая скрытые)
```

**Примеры:**
```bash
l                    # Посмотреть все файлы с правами и размерами
ll *.txt             # Список всех .txt файлов
la                   # Показать скрытые файлы
```

---

## 🔧 Git команды

### Основные алиасы

```bash
g                    # git
gs                   # git status
ga                   # git add
ga .                 # git add . (добавить все)
gc                   # git commit -m
gp                   # git push
gl                   # git pull
gd                   # git diff
gco                  # git checkout
gb                   # git branch
```

**Примеры:**
```bash
gs                   # Проверить статус
ga .                 # Добавить все изменения
gc "fix bug"         # Закоммитить с сообщением
gp                   # Отправить на GitHub

# Или цепочкой:
ga . && gc "update docs" && gp
```

---

### Git Log и история

```bash
glog                 # git log --oneline --graph --decorate --all
glog | cat           # Просмотр в терминале (без пейджера)
```

**Примеры:**
```bash
glog                 # Красивая история коммитов
glog | head -10      # Последние 10 коммитов
```

---

### Git Quick Commands (gq)

Скрипт `git-quick.sh` предоставляет быстрые Git команды:

```bash
gq status            # git status (подробно)
gq add               # git add . (интерактивно)
gq commit "msg"      # git commit с сообщением
gq push              # git push в текущую ветку
gq pull              # git pull с rebase

# 🌟 СУПЕР-КОМАНДА:
gq acp "message"     # add + commit + push одной командой!
```

**Примеры:**
```bash
# Быстрый цикл разработки:
gq acp "add new feature"           # Все в одной команде!
gq acp "fix typo in README"        # Добавить, закоммитить, отправить

# Или поэтапно:
gq add                              # Добавить все изменения
gq commit "update documentation"    # Закоммитить
gq push                             # Отправить на GitHub
```

---

## ⚡ Productivity Tools

### Project Switcher (ps)

Быстрое переключение между проектами:

```bash
ps                   # Показать меню всех проектов
```

**Как работает:**
1. Запустите `ps`
2. Выберите проект из списка
3. Автоматически перейдете в папку проекта

**Настройка:**
```bash
# Отредактируйте список проектов:
nvim ~/project-switcher.sh

# Добавьте свои проекты:
projects=(
    "/mnt/c/Project/MyProject"
    "/mnt/c/Project/AnotherProject"
    "~/Development/WebApp"
)
```

---

### Backup & Sync

Резервное копирование и синхронизация конфигов:

```bash
backup               # Создать резервную копию всех конфигов
sync                 # Синхронизировать с Git репозиторием
```

**Что бэкапится:**
- Конфигурации Zellij
- Конфигурации Neovim
- .zshrc
- Пользовательские скрипты
- Aliases

**Примеры:**
```bash
backup               # Создать backup перед большими изменениями
sync                 # Синхронизировать после настройки

# Workflow:
backup               # Сохранить текущее состояние
# ... делаем изменения ...
sync                 # Отправить в Git
```

---

### Dev Environment (devenv)

Автоматическая настройка окружения проекта:

```bash
devenv               # Определить и настроить окружение
```

**Что определяет:**
- Node.js проекты (package.json) → `npm install`
- Python проекты (requirements.txt) → `pip install`
- Rust проекты (Cargo.toml) → `cargo build`
- Git репозитории → настройка

**Примеры:**
```bash
cd /mnt/c/Project/MyApp
devenv               # Автоматически установит зависимости
```

---

### Clean System

Очистка и обслуживание WSL:

```bash
clean                # Очистить систему от мусора
```

**Что очищается:**
- Кэш apt
- Старые kernel пакеты
- Логи системы
- Временные файлы
- Cargo кэш (опционально)

**Примеры:**
```bash
clean                # Очистка перед backup
df -h                # Проверить освобожденное место
```

---

## 🖥️ Системные команды

### Системная информация

```bash
update               # sudo apt update && sudo apt upgrade -y
install pkg          # sudo apt install pkg -y
df                   # df -h (место на дисках)
du                   # du -h (размер папок)
```

**Примеры:**
```bash
update               # Обновить систему
install htop         # Установить htop
df                   # Проверить место на дисках
du -sh *             # Размер каждой папки
```

---

### Процессы и мониторинг

```bash
htop                 # Интерактивный монитор процессов
ps aux | grep name   # Найти процесс
```

**Примеры:**
```bash
htop                 # Открыть системный монитор
ps aux | grep node   # Найти все Node.js процессы
```

---

### История команд

```bash
h                    # history (история команд)
h | grep text        # Поиск в истории
```

**Примеры:**
```bash
h                    # Показать всю историю
h | grep git         # Найти все git команды
h | tail -20         # Последние 20 команд
```

---

## 🪟 Windows интеграция

### Открытие файлов и папок

```bash
open .               # Открыть текущую папку в проводнике Windows
open file.txt        # Открыть файл в Windows приложении
explorer.exe .       # То же что open .
```

**Примеры:**
```bash
open .               # Открыть папку в проводнике
open README.md       # Открыть в блокноте/VSCode
open /mnt/c/Project  # Открыть проект в проводнике
```

---

### Буфер обмена

```bash
clip                 # Скопировать в буфер обмена Windows
paste                # Вставить из буфера обмена Windows
```

**Примеры:**
```bash
# Копирование:
cat ~/.ssh/id_rsa.pub | clip    # Скопировать SSH ключ
pwd | clip                       # Скопировать текущий путь
echo "Hello" | clip              # Скопировать текст

# Вставка:
paste                            # Вставить из буфера
paste > temp.txt                 # Сохранить в файл
```

---

### Пути Windows ↔ WSL

```bash
wslpath -w .         # Конвертировать WSL путь в Windows
wslpath -u path      # Конвертировать Windows путь в WSL
```

**Примеры:**
```bash
wslpath -w ~/Project              # → C:\Users\...\Project
wslpath -u "C:\Project\MyApp"     # → /mnt/c/Project/MyApp

# Использование с open:
open $(wslpath -w .)              # Открыть текущую папку
```

---

## 🌐 Сетевые команды

### Web-сервер

```bash
serve                # Запустить HTTP сервер на порту 8000
serve 3000           # Запустить на порту 3000
```

**Примеры:**
```bash
cd /mnt/c/Project/website
serve                # Запустить на :8000
# Откройте браузер: http://localhost:8000

serve 3000           # Запустить на :3000
# Откройте браузер: http://localhost:3000
```

---

### Сеть и порты

```bash
myip                 # Показать IP адрес
ports                # Показать открытые порты
```

**Примеры:**
```bash
myip                 # Узнать свой IP
ports                # Проверить какие порты открыты
netstat -tulpn       # Подробная информация о портах
```

---

## 🔨 Функции

### Создание и переход (mkcd)

```bash
mkcd folder          # mkdir -p folder && cd folder
```

**Примеры:**
```bash
mkcd test            # Создать и перейти в test/
mkcd a/b/c           # Создать вложенные папки и перейти
```

---

### Поиск файлов (ff)

```bash
ff name              # Найти файл по имени
ff "*.js"            # Найти все .js файлы
```

**Примеры:**
```bash
ff config            # Найти файлы с "config" в имени
ff "*.toml"          # Найти все TOML файлы
ff README            # Найти все README файлы
```

---

### Размер папки (dirsize)

```bash
dirsize              # Показать размер текущей папки
dirsize folder       # Размер конкретной папки
```

**Примеры:**
```bash
dirsize              # Размер текущей папки
dirsize /mnt/c       # Размер диска C:
du -sh */            # Размер всех подпапок
```

---

### Архивы

```bash
extract file.zip     # Извлечь архив (авто-определение типа)
extract file.tar.gz  # Работает с .tar.gz, .zip, .rar и др.
```

**Примеры:**
```bash
extract archive.zip      # Распаковать ZIP
extract project.tar.gz   # Распаковать TAR.GZ
extract file.7z          # Распаковать 7Z
```

---

## ⌨️ Zellij горячие клавиши

### Навигация между панелями

```
Alt + ←              # Переключиться на панель слева
Alt + →              # Переключиться на панель справа
Alt + ↑              # Переключиться на панель сверху
Alt + ↓              # Переключиться на панель снизу
```

### Управление панелями

```
Ctrl + p             # Войти в режим панелей
  затем:
  n                  # Новая панель
  x                  # Закрыть текущую панель
  f                  # Полноэкранный режим
  Esc                # Выйти из режима

Alt + n              # Новая панель (без режима)
Alt + f              # Плавающая панель
```

### Управление табами

```
Ctrl + t             # Войти в режим табов
  затем:
  n                  # Новый таб
  x                  # Закрыть таб
  r                  # Переименовать таб
  Esc                # Выйти из режима

Alt + [1-9]          # Переключиться на таб 1-9
```

### Изменение размера

```
Ctrl + n             # Войти в режим изменения размера
  затем:
  ←/→/↑/↓            # Изменить размер стрелками
  +/-                # Увеличить/уменьшить
  =                  # Сбросить размер
  Esc                # Выйти из режима
```

### Другие команды

```
Ctrl + s             # Режим поиска
Ctrl + o             # Режим сессий
Ctrl + q             # Выход из Zellij
Ctrl + g             # Режим блокировки (отключить hotkeys)
```

---

## 🎨 LazyVim горячие клавиши

### Основные

```
Space                # Leader key (главная клавиша)
Space + ?            # Показать все горячие клавиши
```

### Файловый менеджер (Neo-tree)

```
Space + e            # Открыть/закрыть Neo-tree
Space + E            # Открыть Neo-tree с фокусом на текущем файле

В Neo-tree:
  a                  # Создать файл/папку
  d                  # Удалить
  r                  # Переименовать
  x                  # Вырезать
  c                  # Копировать
  p                  # Вставить
  /                  # Поиск
  ?                  # Помощь
```

### Поиск файлов (Telescope)

```
Space + ff           # Найти файл (find file)
Space + fg           # Поиск по содержимому (grep)
Space + fb           # Список буферов
Space + fh           # История файлов
Space + fo           # Старые файлы (old files)
Space + fc           # Найти команды
```

### Навигация по коду

```
gd                   # Перейти к определению (goto definition)
gr                   # Показать ссылки (references)
gi                   # Перейти к реализации
K                    # Показать документацию (hover)
<Leader>ca           # Code actions

Ctrl + o             # Вернуться назад
Ctrl + i             # Вернуться вперед
```

### Редактирование

```
gcc                  # Закомментировать строку
gc + motion          # Закомментировать (visual mode)
Space + /            # Закомментировать/раскомментировать

<                    # Уменьшить отступ
>                    # Увеличить отступ (в visual mode)

J                    # Объединить строки
u                    # Отменить (undo)
Ctrl + r             # Повторить (redo)
```

### Окна и буферы

```
Space + w + v        # Разделить вертикально
Space + w + s        # Разделить горизонтально
Space + w + q        # Закрыть окно

Ctrl + h/j/k/l       # Переключение между окнами

Space + b + d        # Закрыть буфер
Space + b + n        # Следующий буфер
Space + b + p        # Предыдущий буфер
```

### LSP (автодополнение)

```
Ctrl + Space         # Вызвать автодополнение
Ctrl + n             # Следующий вариант
Ctrl + p             # Предыдущий вариант
Enter                # Подтвердить выбор

Space + c + a        # Code actions
Space + c + r        # Переименовать (rename)
Space + c + f        # Форматировать код
```

### Git интеграция

```
Space + g + g        # Открыть LazyGit
Space + g + s        # Git status
Space + g + b        # Git blame
Space + g + d        # Git diff

]c                   # Следующее изменение
[c                   # Предыдущее изменение
```

### Терминал

```
Space + t + t        # Открыть терминал
Space + t + f        # Плавающий терминал
Ctrl + /             # Переключить терминал

В терминале:
  Ctrl + \           # Выйти из режима терминала
  i / a              # Войти в режим редактирования
```

---

## 📚 Быстрые рабочие процессы

### Workflow 1: Разработка с Git

```bash
# 1. Начало работы
cd /mnt/c/Project/MyApp
devenv                              # Настроить окружение
n .                                 # Открыть в Neovim

# 2. Работа
# ... делаем изменения ...

# 3. Коммит и push
gq acp "add new feature"            # Все в одной команде!

# или
ga .                                # Добавить изменения
gc "add new feature"                # Закоммитить
gp                                  # Отправить
```

### Workflow 2: Быстрое переключение проектов

```bash
# Работаем над проектом A
cd /mnt/c/Project/ProjectA
n .

# Нужно переключиться на проект B
ps                                  # Выбрать проект из списка
n .                                 # Открыть в Neovim
```

### Workflow 3: Резервное копирование

```bash
# Перед большими изменениями
backup                              # Создать резервную копию

# Делаем изменения в конфигах
n ~/.config/zellij/config.kdl
n ~/.zshrc

# Синхронизируем
sync                                # Отправить в Git
```

### Workflow 4: Очистка системы

```bash
# Проверить место
df -h

# Очистить
clean                               # Удалить мусор

# Проверить снова
df -h
```

---

## 🎯 Шпаргалка команд

### Самые используемые:

```bash
# Навигация и редактирование
n .                  # Neovim
..                   # Вверх на уровень
l                    # Список файлов

# Git
gq acp "msg"         # Add + commit + push
gs                   # Status
glog                 # История

# Productivity
ps                   # Переключить проект
backup               # Резервная копия
clean                # Очистка

# Windows
open .               # Открыть в проводнике
clip                 # Копировать в буфер
paste                # Вставить из буфера

# Система
update               # Обновить систему
htop                 # Монитор процессов
serve                # Веб-сервер
```

---

## 📝 Кастомизация

### Добавить свой alias

Отредактируйте файл `~/.config/zsh/aliases.zsh`:

```bash
nvim ~/.config/zsh/aliases.zsh

# Добавьте свой alias:
alias myalias='your command'

# Сохраните и перезагрузите:
source ~/.zshrc
```

### Добавить свою функцию

```bash
nvim ~/.config/zsh/aliases.zsh

# Добавьте функцию:
myfunction() {
    echo "Hello from my function!"
    # Ваш код здесь
}

# Сохраните и перезагрузите:
source ~/.zshrc
```

---

## 🔗 Связанные документы

- [COMPLETE_SETUP_GUIDE.md](./COMPLETE_SETUP_GUIDE.md) - Полное руководство по настройке
- [PRODUCTIVITY_TOOLS.md](./PRODUCTIVITY_TOOLS.md) - Детали productivity инструментов
- [LAZYVIM_SETUP.md](./LAZYVIM_SETUP.md) - Настройка LazyVim
- [../README.md](../README.md) - Общая документация Windows конфигурации

---

## 💻 PowerShell версия

Если вы используете **PowerShell** вместо WSL, установите PowerShell версию алиасов:

```powershell
# Перейдите в папку проекта
cd C:\Project\terminal-configs\windows\powershell

# Запустите установку
.\install.ps1
```

**Документация**: [powershell/README.md](../powershell/README.md)

**Примечание**: PowerShell алиасы работают в Windows PowerShell, но некоторые команды (gq, ps, backup) требуют WSL для выполнения скриптов.

---

**Версия**: 1.1  
**Дата**: 2025-01-XX  
**Платформа**: Windows 11 + WSL Ubuntu / PowerShell

**Приятного использования! 🚀**

