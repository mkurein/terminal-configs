# 🔄 Инструкции по обновлению репозитория

> Создано: 2025-11-11
> Версия после обновления: 2.2 (macOS) + поддержка Debian/Ubuntu (Windows)

## 🍎 Обновление на macOS

### Текущая macOS машина (уже обновлено ✅)

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

### Другая macOS машина (если есть)

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

## 🪟 Обновление на Windows машине

### Быстрый способ (рекомендуется)

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

### Пошаговый способ

#### Шаг 1: Откройте PowerShell или WSL

```powershell
# PowerShell
cd C:\Users\ВашеИмя\terminal-configs

# Или WSL
wsl
cd ~/terminal-configs
```

#### Шаг 2: Проверьте текущее состояние

```bash
git status
git branch
```

Если видите несохранённые изменения:

```bash
git stash save "Мои изменения перед обновлением"
```

#### Шаг 3: Обновите репозиторий

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

#### Шаг 4: Установите конфиги в WSL

```bash
# В WSL
cd windows
chmod +x install.sh
./install.sh
```

#### Шаг 5: Настройте Alacritty в Windows

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

#### Шаг 6: Установите bat-файлы (опционально)

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

#### Шаг 7: Верните сохранённые изменения (если были)

```bash
git stash pop
```

---

## 🆕 Что нового после обновления

### macOS (v2.2)
- ✅ Исправлен критичный баг с Windows-алиасом `open=explorer.exe`
- ✅ Добавлен диагностический скрипт `check-alacritty-setup.sh`
- ✅ Расширен раздел "Устранение неполадок"
- ✅ Добавлен раздел "Известные проблемы"

### Windows (поддержка Debian/Ubuntu)
- ✅ 3 конфигурации Alacritty (default, debian, ubuntu)
- ✅ Bat-файлы для быстрого запуска каждого дистрибутива
- ✅ Автоматическое использование default WSL дистрибутива
- ✅ Подробная документация по выбору дистрибутива

---

## 📋 Проверка после обновления

### macOS
```bash
~/check-alacritty-setup.sh
```

### Windows (в WSL)
```bash
# Проверить версию Zellij
zellij --version

# Проверить наличие конфигов
ls -la ~/.config/zellij/layouts/

# Проверить скрипты
ls -la ~/start-zellij-choose.sh
```

### Windows (в PowerShell)
```powershell
# Проверить конфиги Alacritty
dir $env:USERPROFILE\.config\alacritty\*.toml

# Проверить bat-файлы
where wa
where wa-debian
where wa-ubuntu
```

---

## ❓ Проблемы после обновления

### "Git конфликты при pull"

```bash
# Сброс локальных изменений (ВНИМАНИЕ: потеряете изменения!)
git reset --hard origin/main

# Или сохраните изменения и примените после
git stash save "Мои изменения"
git pull origin main
git stash pop
# Разрешите конфликты вручную
```

### "Alacritty не запускается на macOS"

```bash
# Проверьте алиасы
grep "explorer.exe" ~/.config/zsh/aliases.zsh

# Если находит - удалите:
sed -i.bak '/alias open=explorer.exe/d' ~/.config/zsh/aliases.zsh
source ~/.zshrc
```

### "WSL дистрибутив не найден"

```powershell
# Проверьте установленные дистрибутивы
wsl --list --verbose

# Установите нужный как default
wsl --set-default Ubuntu  # или Debian
```

---

## 📞 Поддержка

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

