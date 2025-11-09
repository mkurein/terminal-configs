# 📁 Работа с файлами между WSL и Windows

Полное руководство по копированию, перемещению и работе с файлами между WSL и Windows.

## 📋 Содержание

1. [Основы доступа к файлам](#основы-доступа-к-файлам)
2. [Копирование файлов](#копирование-файлов)
3. [Работа с буфером обмена](#работа-с-буфером-обмена)
4. [Best Practices](#best-practices)
5. [Troubleshooting](#troubleshooting)

---

## 🎯 Основы доступа к файлам

### Доступ к Windows из WSL

В WSL все диски Windows монтируются в `/mnt/`:

```bash
# Windows диски доступны в WSL:
/mnt/c/          # C:\
/mnt/d/          # D:\
/mnt/e/          # E:\

# Примеры:
cd /mnt/c/Users/YourName/Documents
cd /mnt/c/Project/MyProject
ls /mnt/d/Downloads
```

### Доступ к WSL из Windows

WSL файловая система доступна через специальный путь:

```
\\wsl$\Debian\home\username\
\\wsl$\Ubuntu\home\username\
```

**В проводнике Windows:**
1. Откройте проводник
2. В адресной строке введите: `\\wsl$\`
3. Выберите ваш дистрибутив (Debian, Ubuntu, и т.д.)
4. Перейдите в нужную папку

---

## 📋 Копирование файлов

### Вариант 1: Через команду `cp` в WSL (Рекомендуется для скриптов)

```bash
# Из WSL в Windows
cp ~/file.txt /mnt/c/Users/YourName/Desktop/

# Копировать папку рекурсивно
cp -r ~/my-project /mnt/c/Users/YourName/Documents/

# С сохранением атрибутов
cp -a ~/config /mnt/c/Backup/
```

### Вариант 2: Через проводник Windows

**Из WSL в Windows:**

1. **Откройте WSL файлы в проводнике:**
   ```
   # В адресной строке проводника:
   \\wsl$\Debian\home\username\
   ```

2. **Или из WSL командой:**
   ```bash
   # Открыть текущую папку WSL в проводнике Windows
   explorer.exe .
   
   # Открыть конкретную папку
   explorer.exe ~/Projects
   
   # Открыть домашнюю директорию
   explorer.exe ~
   ```

3. **Скопируйте как обычно:**
   - `Ctrl+C` → `Ctrl+V`
   - Или перетащите мышью

**Из Windows в WSL:**

1. **Откройте проводник в Windows папке**
2. **Скопируйте файлы** (`Ctrl+C`)
3. **В проводнике перейдите:**
   ```
   \\wsl$\Debian\home\username\
   ```
4. **Вставьте** (`Ctrl+V`)

### Вариант 3: Через PowerShell/CMD

```powershell
# Копирование в WSL
Copy-Item C:\Users\YourName\file.txt \\wsl$\Debian\home\username\

# Копирование из WSL
Copy-Item \\wsl$\Debian\home\username\file.txt C:\Users\YourName\Desktop\

# Папку рекурсивно
Copy-Item -Recurse \\wsl$\Debian\home\username\project C:\Backup\
```

### Вариант 4: Drag & Drop в проводнике

**Самый простой способ!**

1. Откройте два окна проводника:
   - Окно 1: `C:\Your\Windows\Folder`
   - Окно 2: `\\wsl$\Debian\home\username\`

2. Перетащите файлы между окнами
   - **Просто перетащить** = переместить
   - **Ctrl + перетащить** = скопировать
   - **Shift + перетащить** = переместить (принудительно)

---

## 📋 Работа с буфером обмена

### Копирование текста

#### Из WSL в Windows буфер обмена

```bash
# Установите win32yank (если еще не установлен)
# Скачайте: https://github.com/equalsraf/win32yank/releases

# Поместите в ~/.local/bin/
mkdir -p ~/.local/bin
# Скопируйте win32yank.exe туда

# Добавьте в PATH (в ~/.zshrc или ~/.bashrc)
export PATH="$HOME/.local/bin:$PATH"

# Использование:
echo "Hello World" | win32yank.exe -i

# Копировать содержимое файла
cat file.txt | win32yank.exe -i

# Копировать вывод команды
ls -la | win32yank.exe -i

# Теперь можно вставить в Windows: Ctrl+V
```

#### Из Windows буфера в WSL

```bash
# Вставить из буфера Windows
win32yank.exe -o

# Вставить в файл
win32yank.exe -o > output.txt

# Использовать в команде
win32yank.exe -o | grep "search"
```

#### Создать удобные алиасы

Добавьте в `~/.config/zsh/aliases.zsh`:

```bash
# Буфер обмена для WSL
alias clip='win32yank.exe -i'
alias paste='win32yank.exe -o'

# Примеры использования:
# pwd | clip                 # Скопировать текущий путь
# cat file.txt | clip        # Скопировать файл
# paste > newfile.txt        # Вставить в файл
```

### Копирование файлов через буфер

#### В проводнике:

1. **Скопируйте путь к файлу в WSL:**
   ```bash
   # Получить Windows путь к файлу WSL
   wslpath -w ~/myfile.txt | clip
   # Скопирует что-то вроде: \\wsl$\Debian\home\username\myfile.txt
   ```

2. **В проводнике Windows:**
   - Нажмите `Ctrl+V` в адресной строке
   - Откроется папка с файлом
   - Скопируйте файл куда нужно

#### Обратно - Windows путь в WSL:

```bash
# В Windows: скопируйте путь (Shift + ПКМ → "Copy as path")
# C:\Users\YourName\Documents\file.txt

# В WSL преобразовать в Unix путь:
wslpath "$(paste)"
# Вернет: /mnt/c/Users/YourName/Documents/file.txt
```

---

## 💡 Best Practices

### ⚡ Производительность

1. **Храните проекты разработки в WSL файловой системе**
   ```bash
   # ✅ ХОРОШО - быстро
   ~/Projects/MyApp/
   
   # ❌ ПЛОХО - медленно (особенно Node.js, Git)
   /mnt/c/Users/YourName/Projects/MyApp/
   ```
   
   **Почему?** Доступ к файлам в `/mnt/c/` в 10-20 раз медленнее!

2. **Исключение: работа с большими файлами**
   ```bash
   # Для больших файлов (видео, архивы) лучше держать в Windows
   /mnt/c/Downloads/large-file.zip
   ```

### 🔄 Синхронизация между WSL и Windows

**Создайте символическую ссылку:**

```bash
# Ссылка из WSL на Windows папку
ln -s /mnt/c/Users/YourName/Documents ~/documents-win

# Теперь можно использовать:
cd ~/documents-win
ls ~/documents-win
```

**Или наоборот - из Windows на WSL:**

```powershell
# В PowerShell (от администратора):
New-Item -ItemType SymbolicLink -Path "C:\WSL-Projects" -Target "\\wsl$\Debian\home\username\Projects"

# Теперь C:\WSL-Projects ведет в WSL
```

### 📁 Рекомендуемая структура

```
Windows (C:\):
├── Users\YourName\
│   ├── Documents\          # Документы, большие файлы
│   ├── Downloads\          # Загрузки
│   └── Pictures\           # Фото, видео

WSL (~/):
├── Projects\               # ✅ Проекты разработки здесь!
│   ├── MyApp\
│   ├── Website\
│   └── Scripts\
├── .config\                # ✅ Конфигурации
└── backups\                # ✅ Backups конфигов
```

### 🔒 Права доступа

```bash
# После копирования из Windows, файлы могут быть executable
# Исправить права:
chmod 644 file.txt          # Обычный файл
chmod 755 script.sh         # Исполняемый скрипт
chmod -R 755 folder/        # Рекурсивно для папки
```

---

## 🚀 Полезные команды

### Быстрый доступ

```bash
# Открыть текущую папку WSL в проводнике
alias winopen='explorer.exe .'

# Открыть проводник в Windows папке
alias cdwin='cd /mnt/c/Users/YourName/'

# Скопировать текущий путь (Windows формат) в буфер
alias pwdwin='wslpath -w $(pwd) | clip'
```

### Массовое копирование

```bash
# Скопировать все .txt файлы
cp ~/Documents/*.txt /mnt/c/Backup/

# Найти и скопировать все .log файлы старше 30 дней
find ~/logs -name "*.log" -mtime +30 -exec cp {} /mnt/c/Archive/ \;

# Синхронизировать папки (только измененные)
rsync -av ~/Projects/ /mnt/c/Backup/Projects/
```

### Преобразование путей

```bash
# Windows путь → WSL путь
wslpath "C:\Users\YourName\file.txt"
# Вернет: /mnt/c/Users/YourName/file.txt

# WSL путь → Windows путь
wslpath -w ~/file.txt
# Вернет: \\wsl$\Debian\home\username\file.txt

# Пакетное преобразование
cat windows-paths.txt | while read path; do wslpath "$path"; done
```

---

## 🐛 Troubleshooting

### ❌ "Permission denied" при копировании

**Проблема:** Отказано в доступе при копировании в WSL

**Решение:**

```bash
# Проверьте владельца и права
ls -la /path/to/file

# Измените владельца
sudo chown $USER:$USER /path/to/file

# Измените права
chmod 755 /path/to/folder
```

### ❌ Файлы с неправильными окончаниями строк

**Проблема:** Скрипты не работают после копирования из Windows

**Решение:**

```bash
# Конвертировать Windows (CRLF) → Unix (LF)
dos2unix file.sh

# Или через sed
sed -i 's/\r$//' file.sh

# Или для всех файлов в папке
find . -type f -name "*.sh" -exec dos2unix {} \;
```

### ❌ "Operation not permitted" для символических ссылок

**Проблема:** Не могу создать symlink в /mnt/c/

**Решение:**

В Windows включите Developer Mode:
1. Settings → Update & Security → For developers
2. Включите "Developer Mode"

Или запустите WSL от администратора.

### ❌ Медленное копирование больших файлов

**Проблема:** Копирование через `\\wsl$\` очень медленное

**Решение:**

```bash
# Вместо проводника используйте прямое копирование:
cp /mnt/c/source/large-file.zip ~/destination/

# Или rsync с прогресс-баром
rsync -av --progress /mnt/c/source/large-file.zip ~/destination/
```

### ❌ Не работает win32yank

**Проблема:** `win32yank.exe not found`

**Решение:**

```bash
# 1. Скачайте win32yank
# https://github.com/equalsraf/win32yank/releases

# 2. Разместите в ~/.local/bin/
mkdir -p ~/.local/bin
# Скопируйте win32yank.exe туда

# 3. Добавьте в PATH (в ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"

# 4. Перезапустите shell
exec zsh

# 5. Проверьте
which win32yank.exe
```

---

## 🎓 Продвинутые техники

### Автоматический backup в Windows

```bash
# Создайте скрипт ~/backup-to-windows.sh
#!/bin/bash
BACKUP_DIR="/mnt/c/Backups/WSL-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Backup важных папок
cp -r ~/.config "$BACKUP_DIR/"
cp -r ~/Projects "$BACKUP_DIR/"
cp ~/.zshrc "$BACKUP_DIR/"

echo "✓ Backup создан: $BACKUP_DIR"

# Добавьте в cron для автоматического backup
# crontab -e
# 0 2 * * * ~/backup-to-windows.sh
```

### Мониторинг изменений файлов

```bash
# Установите inotify-tools
sudo apt install inotify-tools

# Автоматически копировать при изменении
inotifywait -m ~/Projects -e modify |
    while read path action file; do
        cp "$path$file" /mnt/c/Backup/
        echo "Скопирован: $file"
    done
```

### Интеграция с Git

```bash
# Работайте в WSL, но храните backups в Windows
git clone https://github.com/user/repo.git ~/Projects/repo

# Создайте git hook для автокопирования
cat > ~/Projects/repo/.git/hooks/post-commit << 'EOF'
#!/bin/bash
cp -r ~/Projects/repo /mnt/c/Backup/repo-$(date +%Y%m%d-%H%M%S)
EOF
chmod +x ~/Projects/repo/.git/hooks/post-commit
```

---

## 📚 Полезные ресурсы

- [Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [win32yank GitHub](https://github.com/equalsraf/win32yank)
- [WSL File System](https://docs.microsoft.com/en-us/windows/wsl/filesystems)

---

## 📝 Чеклист для новичков

- [ ] Понимаю, что такое `/mnt/c/` и как им пользоваться
- [ ] Умею открывать WSL файлы в проводнике (`\\wsl$\`)
- [ ] Установил и настроил win32yank для буфера обмена
- [ ] Создал алиасы `clip` и `paste`
- [ ] Храню проекты разработки в WSL (`~/Projects/`)
- [ ] Умею конвертировать пути через `wslpath`
- [ ] Настроил символические ссылки для удобного доступа

---

**Версия**: 1.0  
**Дата**: 2025-11-09  
**Платформа**: Windows 11 + WSL2

**Удачной работы с файлами! 📁**

