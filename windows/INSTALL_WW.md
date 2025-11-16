# 🚀 Установка ww.bat - Быстрый запуск WezTerm

Полное руководство по установке `ww.bat` для быстрого запуска **WezTerm** в текущей папке из проводника Windows.

## 📋 Содержание

- [Что такое ww.bat](#что-такое-wwbat)
- [Способы использования](#способы-использования)
- [Установка](#установка)
- [Использование](#использование)
- [Контекстное меню](#контекстное-меню)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Что такое ww.bat

`ww.bat` — это батник-скрипт для **быстрого запуска WezTerm** прямо из проводника Windows.

**Аналог `wa.bat` для Alacritty**

### Что делает скрипт:

1. ✅ Получает текущую директорию Windows
2. ✅ Конвертирует Windows путь в WSL путь (через `wslpath`)
3. ✅ Определяет дефолтный WSL дистрибутив
4. ✅ Запускает WezTerm с переходом в эту директорию в WSL
5. ✅ Автоматически запускает zsh

### Результат:

Вместо:
```
Windows Explorer: C:\Project\MyApp
→ Открыть PowerShell
→ wsl
→ cd /mnt/c/Project/MyApp
```

Теперь:
```
Windows Explorer: C:\Project\MyApp
→ Введите "ww" в адресную строку
→ WezTerm откроется СРАЗУ в /mnt/c/Project/MyApp в WSL! 🚀
```

---

## 📦 Способы использования

### Вариант 1: Через адресную строку проводника (⭐ Рекомендуется)

1. Откройте любую папку в проводнике
2. Кликните в адресную строку (или `Ctrl + L`)
3. Введите: `ww`
4. Нажмите `Enter`
5. WezTerm откроется в этой папке в WSL!

**Демо:**
```
Проводник: C:\Project\MyApp
Адресная строка: ww [Enter]
→ WezTerm открыт в /mnt/c/Project/MyApp
```

### Вариант 2: Через контекстное меню

1. ПКМ на фоне любой папки
2. Выберите "Open WezTerm Here"
3. WezTerm откроется в этой папке!

### Вариант 3: Из PowerShell / CMD

```powershell
cd C:\Project\MyApp
ww
```

---

## 🔧 Установка

### Шаг 1: Установить WezTerm

Если WezTerm ещё не установлен:

```powershell
# Через Scoop (рекомендуется)
scoop install wezterm

# Через Chocolatey
choco install wezterm

# Через Winget
winget install wez.wezterm
```

### Шаг 2: Скопировать ww.bat в System32

**Вариант A: Через PowerShell (от администратора)**

```powershell
# Откройте PowerShell от имени администратора
# Перейдите в папку проекта
cd C:\Project\terminal-configs

# Скопируйте ww.bat в System32
Copy-Item windows\ww.bat C:\Windows\System32\
```

**Вариант B: Вручную**

1. Откройте проводник
2. Перейдите в `C:\Project\terminal-configs\windows\`
3. Скопируйте файл `ww.bat`
4. Откройте `C:\Windows\System32\` (требуются права администратора)
5. Вставьте файл `ww.bat`

### Шаг 3: Проверка установки

```powershell
# Проверьте, что ww.bat доступен
where ww.bat
# Должно вывести: C:\Windows\System32\ww.bat

# Проверьте, что WezTerm найден
where wezterm-gui.exe
```

---

## 🚀 Использование

### Основное использование

1. **Откройте проводник Windows**
2. **Перейдите в нужную папку** (например, `C:\Project\MyApp`)
3. **Кликните в адресную строку** (или нажмите `Ctrl + L`)
4. **Введите `ww` и нажмите Enter**
5. **WezTerm откроется в WSL в этой папке!**

### Примеры

**Пример 1: Открыть проект**
```
Папка: C:\Project\MyWebApp
Действие: ww [Enter]
Результат: WezTerm в /mnt/c/Project/MyWebApp
```

**Пример 2: Быстрый доступ к домашней папке**
```
Папка: C:\Users\YourName
Действие: ww [Enter]
Результат: WezTerm в /mnt/c/Users/YourName
```

**Пример 3: Работа с документами**
```
Папка: C:\Users\YourName\Documents\Code
Действие: ww [Enter]
Результат: WezTerm в /mnt/c/Users/YourName/Documents/Code
```

---

## 🖱️ Контекстное меню

Добавьте "Open WezTerm Here" в контекстное меню проводника.

### Установка

1. **Отредактируйте файл `wezterm-here.reg`**

Откройте `windows/wezterm-here.reg` и измените путь к `ww.bat`:

```reg
[HKEY_CLASSES_ROOT\Directory\Background\shell\WeztermHere\command]
@="\"C:\\Project\\terminal-configs\\windows\\ww.bat\""
```

Замените `C:\\Project\\terminal-configs\\windows\\ww.bat` на:
- `C:\\Windows\\System32\\ww.bat` (если установили в System32)
- Или полный путь к вашему `ww.bat`

2. **Запустите файл .reg**

Двойной клик на `wezterm-here.reg` → Подтвердите добавление в реестр

3. **Готово!**

Теперь в любой папке: ПКМ → "Open WezTerm Here" 🎉

### Удаление из контекстного меню

Создайте файл `wezterm-here-remove.reg`:

```reg
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\Directory\Background\shell\WeztermHere]
```

Запустите его для удаления пункта меню.

---

## 🛠️ Troubleshooting

### ww.bat не найден

```powershell
# Проверьте, что файл скопирован
Test-Path C:\Windows\System32\ww.bat

# Если False, скопируйте снова (от администратора)
Copy-Item windows\ww.bat C:\Windows\System32\
```

### WezTerm не запускается

**Проблема:** Ошибка "WezTerm не найден"

**Решение:**

```powershell
# Проверьте установку WezTerm
where wezterm-gui.exe

# Если не найден, установите:
scoop install wezterm
```

### WezTerm открывается, но не в WSL

**Проблема:** WezTerm открывается в PowerShell вместо WSL

**Решение:** Проверьте, что WSL установлен и настроен:

```powershell
# Проверьте WSL
wsl --list --verbose

# Убедитесь, что есть дефолтный дистрибутив
wsl --status
```

### WezTerm открывается не в нужной папке

**Проблема:** WezTerm открывается в домашней директории

**Решение:** Проверьте конвертацию путей:

```powershell
# Проверьте конвертацию
wsl wslpath -u "C:\Project\MyApp"
# Должно вывести: /mnt/c/Project/MyApp
```

### Кириллица в путях

**Проблема:** Ошибки с русскими именами папок

**Решение:** Используйте английские имена для проектных папок или убедитесь, что WSL поддерживает UTF-8:

```bash
# В WSL проверьте locale
locale

# Должно быть: LANG=en_US.UTF-8 или ru_RU.UTF-8
```

### Права доступа

**Проблема:** Не могу скопировать в System32

**Решение:** Откройте PowerShell от администратора:

```powershell
# Правой кнопкой на PowerShell → "Запустить от имени администратора"
# Затем выполните:
Copy-Item windows\ww.bat C:\Windows\System32\
```

---

## 💡 Советы и трюки

### Совет 1: Используйте с алиасами

После открытия WezTerm используйте PowerShell алиасы:

```bash
ww           # Открыть WezTerm
# В WezTerm:
gs           # git status
gq acp "msg" # add + commit + push
```

### Совет 2: Комбинация с wa.bat

Установите оба скрипта:
- `wa` — для Alacritty (минималистичный, быстрый)
- `ww` — для WezTerm (с Kitty graphics, inline-изображениями)

### Совет 3: Добавьте в Windows Terminal

Можно добавить профиль в Windows Terminal для запуска WSL через WezTerm, но проще использовать `ww.bat`.

---

## 📚 Связанные документы

- [WEZTERM_SETUP.md](./docs/WEZTERM_SETUP.md) - Полное руководство по WezTerm
- [INSTALL_WA.md](./INSTALL_WA.md) - Установка wa.bat для Alacritty
- [README.md](./README.md) - Общая документация

---

## 🔗 Быстрые ссылки

- **Файл**: `windows/ww.bat`
- **Установка**: `Copy-Item windows\ww.bat C:\Windows\System32\`
- **Использование**: Введите `ww` в адресной строке проводника
- **Контекстное меню**: `windows/wezterm-here.reg`

---

**Версия**: 1.0  
**Дата**: 2025-01-XX  
**Платформа**: Windows 11 + WSL + WezTerm

**Приятного использования! 🚀**

