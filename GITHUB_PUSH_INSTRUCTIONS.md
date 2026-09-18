# 📤 Инструкция по загрузке репозитория на GitHub

## 🎯 Быстрая инструкция

### Вариант 1: Создать новый репозиторий на GitHub (рекомендуется)

#### 1. Создайте репозиторий на GitHub

Перейдите на https://github.com/new и создайте новый репозиторий:

- **Repository name**: `terminal-configs` (или любое другое название)
- **Description**: `🖥️ Cross-platform terminal configurations (Alacritty + Zellij + Neovim)`
- **Visibility**: Public или Private (на ваш выбор)
- ⚠️ **НЕ создавайте** README, .gitignore, license (они уже есть в локальном репозитории)

#### 2. Настройте сохранение credentials (один раз)

```bash
# Windows:
git config --global credential.helper manager

# macOS:
git config --global credential.helper osxkeychain
```

💡 Это нужно сделать **один раз**. После этого Git больше не будет запрашивать логин/токен при каждом push.

#### 3. Подключите удалённый репозиторий

После создания GitHub покажет URL. Выполните в терминале:

```bash
cd ~/Project/terminal-configs

# Добавьте удалённый репозиторий (замените YOUR_USERNAME и REPO_NAME)
git remote add origin https://github.com/YOUR_USERNAME/terminal-configs.git

# Переименуйте ветку в main (опционально, GitHub использует main)
git branch -M main

# Загрузите код на GitHub
git push -u origin main
```

#### 4. Готово! 🎉

Ваш репозиторий теперь на GitHub!

---

### Вариант 2: Использовать GitHub CLI (если установлен)

```bash
cd ~/Project/terminal-configs

# Создайте репозиторий и загрузите код одной командой
gh repo create terminal-configs --public --source=. --remote=origin --push

# Или для приватного репозитория:
gh repo create terminal-configs --private --source=. --remote=origin --push
```

---

## 📝 Пример команд с реальным URL

После создания репозитория на GitHub (например, `https://github.com/yourusername/terminal-configs`):

```bash
cd ~/Project/terminal-configs

# Настройте сохранение credentials (один раз)
git config --global credential.helper manager  # Windows
# или
git config --global credential.helper osxkeychain  # macOS

# Добавьте remote
git remote add origin https://github.com/yourusername/terminal-configs.git

# Переименуйте ветку (опционально)
git branch -M main

# Загрузите на GitHub
git push -u origin main
```

---

## 🔄 Последующие обновления

После того, как репозиторий создан, для загрузки изменений:

```bash
cd ~/Project/terminal-configs

# Просмотр изменений
git status

# Добавить изменённые файлы
git add .

# Создать коммит
git commit -m "Описание изменений"

# Загрузить на GitHub
git push
```

---

## 📦 Что уже сделано

✅ Git репозиторий инициализирован
✅ Все файлы добавлены
✅ Создан первый коммит:
   - macOS конфигурация (v2.1)
   - Документация
   - Скрипты установки
   - Структура для Windows конфигов

---

## 🪟 Добавление Windows конфигурации (позже)

Когда будете готовы добавить Windows конфигурацию:

```bash
cd ~/Project/terminal-configs

# Скопируйте ваши Windows файлы в windows/
# Например:
# cp /path/to/windows/configs/* windows/

# Добавьте изменения
git add windows/
git commit -m "✨ Add Windows terminal configuration"
git push
```

---

## 🔍 Полезные команды Git

```bash
# Проверить статус
git status

# Посмотреть историю коммитов
git log --oneline

# Посмотреть изменения
git diff

# Проверить remote URL
git remote -v

# Изменить remote URL (если нужно)
git remote set-url origin NEW_URL
```

---

## 🔐 Настройка авторизации

> ℹ️ **Важно**: Credential helper не нужно устанавливать отдельно! Он уже входит в Git. Вам нужно только **настроить** его командой `git config`.

### ⚡ Быстрая шпаргалка

**Windows 11:**
```powershell
git config --global credential.helper manager
# Готово! При следующем push авторизуйтесь один раз через браузер
```

**macOS:**
```bash
git config --global credential.helper osxkeychain
# Готово! При следующем push введите username и Personal Access Token
```

💡 **После настройки**: сделайте `git push`, авторизуйтесь один раз, и credentials сохранятся автоматически!

---

### ✅ Проверка текущих настроек

```bash
# Проверьте версию Git (должна быть 2.29+ для Windows, любая для macOS)
git --version

# Проверьте текущий credential helper
git config --global credential.helper

# Если пусто или показывает что-то другое - нужно настроить (см. ниже)
```

**Что должно быть:**
- **Windows**: `manager` или `manager-core` или `wincred`
- **macOS**: `osxkeychain`
- **Linux**: `cache` или `store`

---

### 🪟 Windows 11: Сохранение логина и токена

#### Проблема: Git запрашивает логин и токен при каждом push

**Решение 1: Использовать Git Credential Manager (рекомендуется)**

Git Credential Manager **уже установлен** с Git for Windows (начиная с версии 2.29+) и автоматически сохраняет ваши учётные данные в Windows Credential Manager.

#### Проверка и настройка:

```powershell
# Проверьте, установлен ли Git Credential Manager
git credential-manager --version

# Если установлен, настройте его (обычно уже настроен по умолчанию)
git config --global credential.helper manager

# Или используйте полное название:
git config --global credential.helper manager-core
```

#### Первый push с сохранением:

После настройки при первом `git push`:
1. Git откроет окно браузера или диалог авторизации GitHub
2. Войдите в свой аккаунт GitHub
3. Учётные данные автоматически сохранятся в Windows Credential Manager
4. Последующие push/pull не будут требовать авторизации

#### Где хранятся credentials:

- Откройте: `Панель управления` → `Учётные записи пользователей` → `Диспетчер учётных данных` → `Учётные данные Windows`
- Найдите запись `git:https://github.com`

---

**Решение 2: SSH ключи (альтернатива)**

SSH ключи более безопасны и не требуют ввода пароля/токена:

#### 1. Создайте SSH ключ:

```powershell
# Создайте ключ (нажмите Enter для всех вопросов)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Запустите ssh-agent
ssh-agent

# Добавьте ключ
ssh-add ~/.ssh/id_ed25519
```

#### 2. Добавьте публичный ключ на GitHub:

```powershell
# Скопируйте содержимое публичного ключа
Get-Content ~/.ssh/id_ed25519.pub | clip
```

Затем:
1. Перейдите на https://github.com/settings/keys
2. Нажмите **New SSH key**
3. Вставьте скопированный ключ (Ctrl+V)
4. Нажмите **Add SSH key**

#### 3. Измените URL репозитория на SSH:

```powershell
# Проверьте текущий URL
git remote -v

# Измените на SSH (замените YOUR_USERNAME)
git remote set-url origin git@github.com:YOUR_USERNAME/terminal-configs.git

# Проверьте соединение
ssh -T git@github.com
```

После этого все операции `git push/pull` будут работать без запроса credentials.

---

**Решение 3: Кэширование credentials (временное решение)**

```powershell
# Кэширование на 1 час (3600 секунд)
git config --global credential.helper cache

# Или на 8 часов
git config --global credential.helper 'cache --timeout=28800'
```

⚠️ Это решение временное - credentials будут запрошены снова после истечения времени.

---

**Проверка текущей настройки:**

```powershell
# Посмотрите, какой credential helper используется
git config --global credential.helper

# Посмотрите все настройки Git
git config --global --list
```

---

**Удаление сохранённых credentials (если нужно):**

```powershell
# Через командную строку
git credential-manager erase
# Введите: protocol=https
# Enter, затем: host=github.com
# Enter дважды

# Или через Windows Credential Manager:
# Панель управления → Диспетчер учётных данных → 
# Найдите git:https://github.com → Удалить
```

---

### 🍎 macOS: Сохранение логина и токена

#### Проблема: Git запрашивает логин и токен при каждом push

**Решение 1: Использовать macOS Keychain (рекомендуется)**

macOS Keychain credential helper **уже встроен** в систему (входит в Xcode Command Line Tools). Вам нужно только его настроить.

#### Проверка и настройка:

```bash
# Настройте Git для использования osxkeychain
git config --global credential.helper osxkeychain

# Проверьте настройку
git config --global credential.helper
```

#### Первый push с сохранением:

После настройки при первом `git push`:
1. Git запросит ваш логин (username GitHub)
2. Git запросит ваш Personal Access Token (не пароль!)
3. Учётные данные автоматически сохранятся в macOS Keychain
4. Последующие push/pull не будут требовать авторизации

#### Где хранятся credentials:

- Откройте приложение **Keychain Access** (Связка ключей)
- Найдите запись `github.com`
- Credentials хранятся зашифрованными

#### Создание Personal Access Token:

Если у вас нет токена:
1. Перейдите: https://github.com/settings/tokens
2. **Generate new token** → **Classic**
3. Выберите scopes: `repo` (для приватных репозиториев) и `public_repo`
4. Скопируйте токен (он показывается только один раз!)
5. Используйте этот токен вместо пароля при `git push`

---

**Решение 2: SSH ключи (альтернатива)**

SSH ключи более безопасны и не требуют токенов:

#### 1. Создайте SSH ключ:

```bash
# Создайте ключ (замените email на свой)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Запустите ssh-agent в фоне
eval "$(ssh-agent -s)"

# Добавьте ключ в ssh-agent
ssh-add ~/.ssh/id_ed25519

# Настройте автозагрузку ключа (опционально)
echo "Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
```

#### 2. Добавьте публичный ключ на GitHub:

```bash
# Скопируйте содержимое публичного ключа в буфер обмена
pbcopy < ~/.ssh/id_ed25519.pub
```

Затем:
1. Перейдите на https://github.com/settings/keys
2. Нажмите **New SSH key**
3. Вставьте скопированный ключ (Cmd+V)
4. Нажмите **Add SSH key**

#### 3. Измените URL репозитория на SSH:

```bash
# Проверьте текущий URL
git remote -v

# Измените на SSH (замените YOUR_USERNAME)
git remote set-url origin git@github.com:YOUR_USERNAME/terminal-configs.git

# Проверьте соединение
ssh -T git@github.com
# Должно вернуть: "Hi YOUR_USERNAME! You've successfully authenticated..."
```

После этого все операции `git push/pull` будут работать без запроса credentials.

---

**Решение 3: Кэширование credentials (временное решение)**

```bash
# Кэширование на 1 час (3600 секунд)
git config --global credential.helper 'cache --timeout=3600'

# Или на 8 часов
git config --global credential.helper 'cache --timeout=28800'
```

⚠️ Это решение временное - credentials будут запрошены снова после истечения времени.

---

**Проверка текущей настройки:**

```bash
# Посмотрите, какой credential helper используется
git config --global credential.helper

# Посмотрите все настройки Git
git config --global --list | cat

# Проверьте, есть ли credentials в Keychain
git credential-osxkeychain get
# Введите: protocol=https
# Enter, затем: host=github.com
# Enter дважды
```

---

**Удаление сохранённых credentials (если нужно):**

```bash
# Через командную строку
git credential-osxkeychain erase
# Введите: protocol=https
# Enter, затем: host=github.com
# Enter дважды

# Или через Keychain Access:
# Откройте Keychain Access → Найдите github.com → Удалить
```

---

**Устранение проблем на macOS:**

Если `osxkeychain` не работает:

```bash
# Проверьте, установлен ли helper
git credential-osxkeychain

# Если команда не найдена, переустановите Xcode Command Line Tools
xcode-select --install

# Или используйте Homebrew версию Git
brew install git
```

---

### 📊 Сравнение методов авторизации

| Метод | Windows | macOS | Безопасность | Сложность | Рекомендация |
|-------|---------|-------|--------------|-----------|--------------|
| **Credential Helper** | ✅ manager | ✅ osxkeychain | 🟢 Высокая | 🟢 Простая | ⭐ Рекомендуется |
| **SSH ключи** | ✅ | ✅ | 🟢 Очень высокая | 🟡 Средняя | ⭐ Для опытных |
| **Кэширование** | ✅ | ✅ | 🔴 Низкая | 🟢 Простая | ❌ Временное |

**Итог:**
- Для большинства пользователей: используйте **Credential Helper** (одна команда настройки)
- Для максимальной безопасности: используйте **SSH ключи**
- Кэширование только для тестирования

---

## 🆘 Устранение проблем

### Ошибка: remote origin already exists

```bash
# Удалите существующий remote
git remote remove origin

# Добавьте снова с правильным URL
git remote add origin https://github.com/YOUR_USERNAME/terminal-configs.git
```

### Ошибка: Authentication failed

Если используете HTTPS и GitHub запрашивает пароль:

1. **Используйте Personal Access Token** вместо пароля:
   - Перейдите: https://github.com/settings/tokens
   - Generate new token (classic)
   - Выберите scopes: `repo`
   - Используйте этот token как пароль

2. **Или переключитесь на SSH**:
```bash
# Измените URL на SSH
git remote set-url origin git@github.com:YOUR_USERNAME/terminal-configs.git
```

### Ошибка: Updates were rejected

Если кто-то (или вы на другой машине) изменили репозиторий:

```bash
# Получите изменения с GitHub
git pull origin main

# Затем загрузите свои
git push
```

---

## 📚 Ссылки

- [GitHub: Creating a repository](https://docs.github.com/en/get-started/quickstart/create-a-repo)
- [GitHub: About remote repositories](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories)
- [GitHub CLI](https://cli.github.com/)

---

## 🎯 Структура вашего репозитория

```
terminal-configs/
├── README.md                      # Главный README
├── .gitignore                     # Игнорируемые файлы
├── GITHUB_PUSH_INSTRUCTIONS.md    # Эта инструкция
├── macos/                         # ✅ macOS конфигурация (готово)
│   ├── README.md
│   ├── install.sh
│   ├── alacritty/
│   ├── zellij/
│   ├── scripts/
│   ├── zsh/
│   └── docs/
└── windows/                       # 🚧 Windows конфигурация (в планах)
    ├── README.md
    └── docs/
```

---

**Текущий статус**: Готово к загрузке! ✅
**Первый коммит**: `7bcd517` - macOS configuration v2.1
**Файлов**: 14
**Строк кода**: 1260+

Удачи! 🚀

---

## 🔄 Инструкции по обновлению репозитория

> Создано: 2025-11-11  
> Версия после обновления: 2.2 (macOS) + поддержка Debian/Ubuntu (Windows)

### 🍎 Обновление на macOS

#### Текущая macOS машина (уже обновлено ✅)

Вы уже на актуальной версии! Все изменения присутствуют:
- ✅ macOS конфигурации обновлены до v2.2
- ✅ Windows конфигурации поддерживают Debian и Ubuntu
- ✅ Добавлен диагностический скрипт `check-alacritty-setup.sh`

**Что делать:** Ничего! Но если хотите убедиться:

```bash
cd ~/Project/terminal-configs
git status
git branch  # Должна быть ветка: main
```

#### Другая macOS машина (если есть)

```bash
# 1. Перейти в директорию репозитория
cd ~/Project/terminal-configs  # или ваш путь

# 2. Сохранить локальные изменения (если есть)
git status
git stash save "Backup before update"

# 3. Переключиться на main и обновить
git checkout main
git pull origin main

# 4. Переустановить конфиги (если нужно)
cd macos
./install.sh

# 5. Проверить установку
~/check-alacritty-setup.sh

# 6. Вернуть сохранённые изменения (если были)
git stash pop
```

---

### 🪟 Обновление на Windows машине

#### Быстрый способ (рекомендуется)

**В PowerShell:**

```powershell
# 1. Перейти в директорию
cd C:\путь\к\terminal-configs

# 2. Проверить состояние
git status
git branch

# 3. Сохранить изменения (если есть)
git stash save "Backup before update"

# 4. Обновить репозиторий
git checkout main
git pull origin main

# 5. Установить конфиги в WSL
wsl
cd ~/terminal-configs/windows
./install.sh
exit

# 6. Выбрать нужную конфигурацию Alacritty
# Вариант A: Использовать default WSL (рекомендуется)
copy windows\alacritty\alacritty.toml $env:USERPROFILE\.config\alacritty\

# Вариант B: Для конкретного дистрибутива
copy windows\alacritty\alacritty-debian.toml $env:USERPROFILE\.config\alacritty\
# ИЛИ
copy windows\alacritty\alacritty-ubuntu.toml $env:USERPROFILE\.config\alacritty\

# 7. Скопировать bat-файлы (опционально, от администратора)
Copy-Item windows\wa*.bat C:\Windows\System32\
```

#### Пошаговый способ

##### Шаг 1: Откройте PowerShell или WSL

```powershell
# PowerShell
cd C:\Project\terminal-configs

# Или WSL
wsl
cd ~/terminal-configs
```

##### Шаг 2: Проверьте текущее состояние

```bash
git status
git branch
```

Если видите несохранённые изменения:

```bash
git stash save "Мои изменения перед обновлением"
```

##### Шаг 3: Обновите репозиторий

```bash
git checkout main
git pull origin main
```

Вы должны увидеть:
```
Updating feed611..002fe2b
Fast-forward
 11 files changed, 1537 insertions(+), 19 deletions(-)
```

##### Шаг 4: Установите конфиги в WSL

```bash
# В WSL
cd windows
chmod +x install.sh
./install.sh
```

##### Шаг 5: Настройте Alacritty в Windows

**Вариант 1: Использовать default WSL дистрибутив (Рекомендуется)**

1. Установите нужный дистрибутив как default:
   ```powershell
   # Посмотреть все дистрибутивы
   wsl --list --verbose
   
   # Установить Ubuntu как default
   wsl --set-default Ubuntu
   
   # Или Debian
   wsl --set-default Debian
   ```
2. Скопируйте основной конфиг:
   ```powershell
   copy windows\alacritty\alacritty.toml $env:USERPROFILE\.config\alacritty\
   ```
3. Запускайте через:
   ```powershell
   alacritty
   # или
   wa.bat
   ```

**Вариант 2: Использовать конкретный дистрибутив**

Для **Debian**:
```powershell
copy windows\alacritty\alacritty-debian.toml $env:USERPROFILE\.config\alacritty\
# Запуск:
.\windows\wa-debian.bat
```

Для **Ubuntu**:
```powershell
copy windows\alacritty\alacritty-ubuntu.toml $env:USERPROFILE\.config\alacritty\
# Запуск:
.\windows\wa-ubuntu.bat
```

##### Шаг 6: Установите bat-файлы (опционально)

Для удобного запуска из любого места:

```powershell
# PowerShell от администратора
Copy-Item windows\wa.bat C:\Windows\System32\
Copy-Item windows\wa-debian.bat C:\Windows\System32\
Copy-Item windows\wa-ubuntu.bat C:\Windows\System32\
```

Теперь можно запускать из проводника:
- Введите `wa` в адресной строке
- Или `wa-debian` / `wa-ubuntu`

##### Шаг 7: Верните сохранённые изменения (если были)

```bash
git stash pop
```

---

### 🆕 Что нового после обновления

#### macOS (v2.2)
- ✅ Исправлен критичный баг с Windows-алиасом `open=explorer.exe`
- ✅ Добавлен диагностический скрипт `check-alacritty-setup.sh`
- ✅ Расширен раздел "Устранение неполадок"
- ✅ Добавлен раздел "Известные проблемы"

#### Windows (поддержка Debian/Ubuntu)
- ✅ 3 конфигурации Alacritty (default, debian, ubuntu)
- ✅ Bat-файлы для быстрого запуска каждого дистрибутива
- ✅ Автоматическое использование default WSL дистрибутива
- ✅ Подробная документация по выбору дистрибутива

---

### 📋 Проверка после обновления

#### macOS
```bash
~/check-alacritty-setup.sh
```

#### Windows (в WSL)
```bash
# Проверить версию Zellij
zellij --version

# Проверить наличие конфигов
ls -la ~/.config/zellij/layouts/

# Проверить скрипты
ls -la ~/start-zellij-choose.sh
```

#### Windows (в PowerShell)
```powershell
# Проверить конфиги Alacritty
dir $env:USERPROFILE\.config\alacritty\*.toml

# Проверить bat-файлы
where wa
where wa-debian
where wa-ubuntu
```

---

### ❓ Проблемы после обновления

#### "Git конфликты при pull"

```bash
# Сброс локальных изменений (ВНИМАНИЕ: потеряете изменения!)
git reset --hard origin/main

# Или сохраните изменения и примените после
git stash save "Мои изменения"
git pull origin main
git stash pop
# Разрешите конфликты вручную
```

#### "Alacritty не запускается на macOS"

```bash
# Проверьте алиасы
grep "explorer.exe" ~/.config/zsh/aliases.zsh

# Если находит - удалите:
sed -i.bak '/alias open=explorer.exe/d' ~/.config/zsh/aliases.zsh
source ~/.zshrc
```

#### "WSL дистрибутив не найден"

```powershell
# Проверьте установленные дистрибутивы
wsl --list --verbose

# Установите нужный как default
wsl --set-default Ubuntu  # или Debian
```

---

### 📞 Поддержка

Если возникли проблемы:

1. Проверьте документацию:
   - `macos/README.md` для macOS
   - `windows/README.md` для Windows
2. Запустите диагностику:
   - macOS: `~/check-alacritty-setup.sh`
   - Windows: проверьте `git log` и `git status`
3. Посмотрите CHANGELOG в README файлах

---

**Версия инструкции:** 1.0  
**Дата:** 2025-11-11  
**Актуально для:** terminal-configs commit 002fe2b

