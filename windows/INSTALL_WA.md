# 🚀 Установка wa.bat - Quick Start Guide

Подробная инструкция по установке `wa.bat` для быстрого запуска Alacritty из проводника Windows.

## 🎯 Что это дает?

После установки вы сможете открывать Alacritty в **любой** папке просто набрав `wa` в адресной строке проводника!

```
C:\Projects\MyProject  [wa] → Enter → Alacritty открывается в /mnt/c/Projects/MyProject
```

---

## 📦 Способ 1: Копирование в System32 (Рекомендуется)

### Шаг 1: Откройте PowerShell от администратора

**Вариант A:** Через меню Пуск
1. Нажмите `Win` (клавиша Windows)
2. Введите: `PowerShell`
3. **Правой кнопкой** на "Windows PowerShell"
4. Выберите: **"Запуск от имени администратора"**

**Вариант B:** Через контекстное меню
1. Нажмите `Win + X`
2. Выберите: **"Terminal (Admin)"** или **"Windows PowerShell (Admin)"**

### Шаг 2: Перейдите в папку с репозиторием

```powershell
cd C:\Project\Project_Git\terminal-configs
```

### Шаг 3: Скопируйте wa.bat в System32

```powershell
Copy-Item windows\wa.bat C:\Windows\System32\
```

### Шаг 4: Проверьте установку

```powershell
# Закройте PowerShell
# Откройте проводник
# Перейдите в любую папку (например, C:\Users\ВашеИмя\Downloads)
# Кликните в адресную строку
# Введите: wa
# Нажмите Enter
```

✅ Alacritty должен открыться в этой папке в WSL!

---

## 📦 Способ 2: Добавление в PATH

Если не хотите копировать в System32, можно добавить папку с `wa.bat` в PATH.

### Шаг 1: Откройте System Environment Variables

1. Нажмите `Win + R`
2. Введите: `sysdm.cpl`
3. Нажмите Enter
4. Перейдите на вкладку **"Advanced"** (Дополнительно)
5. Нажмите **"Environment Variables..."** (Переменные среды)

### Шаг 2: Измените PATH

1. В секции **"User variables"** (Пользовательские переменные)
2. Найдите переменную **"Path"**
3. Нажмите **"Edit..."** (Изменить)
4. Нажмите **"New"** (Создать)
5. Добавьте путь: `C:\Project\Project_Git\terminal-configs\windows`
6. Нажмите **OK** везде

### Шаг 3: Перезапустите проводник

```powershell
# В PowerShell выполните:
taskkill /f /im explorer.exe
start explorer.exe
```

✅ Теперь `wa` доступен из любой папки!

---

## 🔧 Способ 3: Контекстное меню через .reg файл

### Шаг 1: Отредактируйте alacritty-here.reg

Откройте `windows\alacritty-here.reg` и убедитесь, что путь правильный:

```reg
@="\"C:\\Windows\\System32\\wa.bat\""
```

Если использовали Способ 2, измените на:

```reg
@="\"C:\\Project\\Project_Git\\terminal-configs\\windows\\wa.bat\""
```

### Шаг 2: Импортируйте .reg файл

1. Двойной клик на `alacritty-here.reg`
2. Подтвердите добавление в реестр
3. Нажмите **"Yes"** → **"OK"**

### Шаг 3: Используйте контекстное меню

Теперь в любой папке:
- **Правой кнопкой** на пустом месте (на фоне папки)
- Выберите **"Open Alacritty Here"**
- Alacritty откроется в этой папке! ✨

---

## 🐛 Устранение неполадок

### ❌ "wa is not recognized"

**Проблема:** Команда `wa` не найдена

**Решение:**
1. Убедитесь, что файл скопирован:
   ```powershell
   Test-Path C:\Windows\System32\wa.bat
   # Должно быть: True
   ```

2. Или проверьте PATH:
   ```powershell
   $env:PATH -split ';' | Select-String "terminal-configs"
   ```

3. Перезапустите проводник:
   ```powershell
   taskkill /f /im explorer.exe; start explorer.exe
   ```

### ❌ Alacritty не открывается

**Проблема:** Окно быстро закрывается или ошибка

**Решение:**

1. Проверьте путь к Alacritty:
   ```powershell
   Test-Path "C:\Program Files\Alacritty\alacritty.exe"
   ```
   
   Если False, отредактируйте `wa.bat` с правильным путём

2. Проверьте WSL:
   ```cmd
   wsl --status
   wsl --list --verbose
   ```

3. Проверьте, что zsh установлен в WSL:
   ```cmd
   wsl which zsh
   ```

### ❌ Открывается не в той папке

**Проблема:** Открывается в домашней директории вместо текущей

**Решение:**

Убедитесь, что используете правильную версию WSL (wsl.exe, не wsl2.exe)

В `wa.bat` должно быть:
```batch
start "" "C:\Program Files\Alacritty\alacritty.exe" -e wsl.exe bash -c "cd '%WSLPATH%' && exec zsh"
```

### ❌ Access Denied при копировании

**Проблема:** Отказано в доступе при копировании в System32

**Решение:**

Убедитесь, что PowerShell запущен **от администратора**:

```powershell
# Проверка прав администратора:
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
# Должно быть: True
```

---

## 💡 Дополнительные советы

### Создать ярлык на рабочем столе

```powershell
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Alacritty Here.lnk")
$Shortcut.TargetPath = "C:\Windows\System32\wa.bat"
$Shortcut.IconLocation = "C:\Program Files\Alacritty\alacritty.exe"
$Shortcut.Save()
```

### Добавить в Windows Terminal

Добавьте профиль в `settings.json`:

```json
{
    "name": "Alacritty WSL",
    "commandline": "C:\\Windows\\System32\\wa.bat",
    "icon": "C:\\Program Files\\Alacritty\\alacritty.ico",
    "startingDirectory": "%USERPROFILE%"
}
```

### Использовать с Total Commander

В Total Commander:
1. Commands → Change Command
2. Command: `C:\Windows\System32\wa.bat`
3. Assign Shortcut: `Ctrl+Alt+A`

---

## 📚 См. также

- [Windows README](./README.md) - Полная документация Windows конфигурации
- [PRODUCTIVITY_TOOLS.md](./docs/PRODUCTIVITY_TOOLS.md) - Другие инструменты продуктивности

---

**Версия**: 1.0  
**Дата**: 2025-11-09  
**Платформа**: Windows 11 + WSL

**Приятного использования! 🚀**

