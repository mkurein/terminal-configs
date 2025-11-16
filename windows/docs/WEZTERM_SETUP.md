# 🚀 WezTerm Setup для Windows + WSL

Полное руководство по настройке **WezTerm** как альтернативы Alacritty для Windows 11 + WSL.

## 📋 Содержание

- [Что такое WezTerm](#что-такое-wezterm)
- [Преимущества WezTerm](#преимущества-wezterm)
- [Установка](#установка)
- [Конфигурация](#конфигурация)
- [Интеграция с WSL](#интеграция-с-wsl)
- [Интеграция с Zellij](#интеграция-с-zellij)
- [Горячие клавиши](#горячие-клавиши)
- [Темы и шрифты](#темы-и-шрифты)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Что такое WezTerm

**WezTerm** — современный GPU-ускоренный кроссплатформенный терминал, написанный на Rust.

### Основные возможности:

- ✅ GPU-ускорение (WebGPU)
- ✅ Встроенная поддержка мультиплексора
- ✅ Kitty graphics protocol (inline-изображения)
- ✅ Лигатуры и Nerd Fonts
- ✅ Конфигурация на Lua
- ✅ Кроссплатформенность (Windows, macOS, Linux)
- ✅ Быстрая работа с WSL

---

## 🆚 Преимущества WezTerm

### WezTerm vs Alacritty

| Функция | WezTerm | Alacritty |
|---------|---------|-----------|
| GPU-ускорение | ✅ WebGPU | ✅ OpenGL |
| Конфигурация | Lua (программируемая) | TOML (статичная) |
| Встроенные вкладки | ✅ Да | ❌ Нет |
| Kitty graphics | ✅ Да | ❌ Нет |
| Inline-изображения | ✅ Да | ❌ Нет |
| Размер | ~30 MB | ~8 MB |
| Скорость | Очень быстрый | Самый быстрый |

### Когда выбрать WezTerm:

- Нужны inline-изображения (Neovim с image.nvim)
- Хотите программируемую конфигурацию (Lua)
- Нужна встроенная поддержка вкладок/панелей
- Работаете с rich-контентом

### Когда выбрать Alacritty:

- Нужна максимальная скорость
- Хотите минималистичный терминал
- Используете внешний мультиплексор (Zellij, tmux)

---

## 📦 Установка

### Вариант 1: Scoop (рекомендуется)

```powershell
scoop install wezterm
```

### Вариант 2: Chocolatey

```powershell
choco install wezterm
```

### Вариант 3: Winget

```powershell
winget install wez.wezterm
```

### Вариант 4: Прямая загрузка

Скачайте с [GitHub Releases](https://github.com/wez/wezterm/releases).

---

## 🔧 Конфигурация

### Установка конфигурации из репозитория

```powershell
# Создайте директорию конфигурации
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\wezterm"

# Скопируйте конфигурацию
Copy-Item windows\wezterm\wezterm.lua "$env:USERPROFILE\.config\wezterm\wezterm.lua"
```

### Структура конфигурации

**Путь к конфигу**: `%USERPROFILE%\.config\wezterm\wezterm.lua`

```lua
local wezterm = require 'wezterm'

return {
  default_prog = { "wsl.exe", "-d", "Debian", "--cd", "~" },
  font = wezterm.font("Hack Nerd Font"),
  font_size = 11.0,
  color_scheme = "Catppuccin Mocha",
  -- ... остальные настройки
}
```

---

## 🐧 Интеграция с WSL

### Запуск Debian WSL

```lua
default_prog = { "wsl.exe", "-d", "Debian", "--cd", "~" }
```

### Запуск Ubuntu WSL

```lua
default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" }
```

### Запуск с автостартом в определённой директории

```lua
default_prog = { "wsl.exe", "-d", "Debian", "--cd", "/mnt/c/Project" }
```

---

## 🔥 Интеграция с Zellij

### Автозапуск Zellij при старте терминала

```lua
default_prog = { 
  "wsl.exe", 
  "-d", "Debian", 
  "--cd", "~", 
  "--exec", "/usr/bin/zsh", 
  "-l", 
  "-c", "~/start-zellij-choose.sh" 
}
```

### Отключение панели вкладок WezTerm

Так как используется Zellij, встроенная панель вкладок не нужна:

```lua
enable_tab_bar = false
```

---

## ⌨️ Горячие клавиши

### Встроенные горячие клавиши WezTerm

```
Ctrl + Shift + C        # Копировать
Ctrl + Shift + V        # Вставить
Ctrl + Plus/Minus       # Изменить размер шрифта
Ctrl + 0                # Сбросить размер шрифта
F11                     # Полноэкранный режим
```

### Настройка горячих клавиш

В конфигурации `wezterm.lua`:

```lua
keys = {
  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'F11', mods = '', action = wezterm.action.ToggleFullScreen },
}
```

---

## 🎨 Темы и шрифты

### Встроенные темы

WezTerm поставляется с 200+ встроенными темами:

```lua
color_scheme = "Catppuccin Mocha"  -- Тёмная, современная
-- color_scheme = "Gruvbox Dark"   -- Классическая
-- color_scheme = "Tokyo Night"    -- Популярная
-- color_scheme = "Nord"            -- Минималистичная
-- color_scheme = "Dracula"         -- Яркая
```

### Список всех тем

```powershell
wezterm ls-fonts
```

### Установка Nerd Fonts

**Рекомендуемые шрифты:**

- Hack Nerd Font
- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- CaskaydiaCove Nerd Font (Cascadia Code)

**Установка через Scoop:**

```powershell
scoop bucket add nerd-fonts
scoop install Hack-NF FiraCode-NF JetBrainsMono-NF CascadiaCode-NF
```

**Конфигурация шрифтов с fallback:**

```lua
font = wezterm.font_with_fallback({
  "Hack Nerd Font",
  "FiraCode Nerd Font",
  "JetBrainsMono Nerd Font",
}),
font_size = 11.0,
```

---

## 🖼️ Kitty Graphics Protocol

WezTerm поддерживает inline-изображения через Kitty graphics protocol.

### Включение в конфигурации

```lua
enable_kitty_graphics = true
```

### Использование с Neovim

Установите плагин `image.nvim` для отображения изображений прямо в редакторе:

```lua
-- ~/.config/nvim/lua/plugins/image.lua
return {
  "3rd/image.nvim",
  opts = {
    backend = "kitty",
    integrations = {
      markdown = {
        enabled = true,
        only_render_image_at_cursor = true,
      },
    },
  },
}
```

---

## ⚡ GPU-ускорение

### Настройка производительности

```lua
-- Высокая производительность GPU
webgpu_power_preference = "HighPerformance"
front_end = "WebGpu"
```

### Проверка GPU

```powershell
wezterm --version
```

---

## 🚀 Быстрый запуск из проводника

### Создание .bat скрипта для запуска WezTerm

**Файл**: `ww.bat` (аналог `wa.bat` для Alacritty)

Скрипт автоматически:
1. Получает текущую Windows директорию
2. Конвертирует в WSL путь
3. Определяет дефолтный WSL дистрибутив
4. Запускает WezTerm с WSL в этой директории

**Установка:**

```powershell
# Скопируйте в System32 для доступа из любой папки
Copy-Item windows\ww.bat C:\Windows\System32\
```

**Использование:**

1. Откройте любую папку в проводнике Windows
2. Кликните в адресную строку
3. Введите: `ww`
4. Нажмите Enter
5. WezTerm откроется в WSL в этой папке! 🚀

### Добавление в контекстное меню

**Файл**: `wezterm-here.reg`

```reg
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\WeztermHere]
@="Open WezTerm Here"
"Icon"="C:\\Program Files\\WezTerm\\wezterm-gui.exe"

[HKEY_CLASSES_ROOT\Directory\Background\shell\WeztermHere\command]
@="\"C:\\Project\\terminal-configs\\windows\\ww.bat\""
```

**Установка:**

1. Отредактируйте путь к `ww.bat` в файле
2. Двойной клик на `wezterm-here.reg`
3. Подтвердите добавление в реестр
4. Теперь ПКМ в папке → "Open WezTerm Here" ✨

---

## 🛠️ Troubleshooting

### WezTerm не запускается

```powershell
# Проверьте установку
wezterm --version

# Проверьте путь к конфигу
Test-Path "$env:USERPROFILE\.config\wezterm\wezterm.lua"
```

### Ошибка в конфигурации

```powershell
# Проверьте синтаксис Lua
wezterm -c "$env:USERPROFILE\.config\wezterm\wezterm.lua"
```

### Шрифт не отображается

```powershell
# Проверьте установленные шрифты
wezterm ls-fonts
```

### WSL не запускается

```powershell
# Проверьте дистрибутивы WSL
wsl -l -v

# Убедитесь, что указан правильный дистрибутив в конфигурации
# default_prog = { "wsl.exe", "-d", "Debian", "--cd", "~" }
```

### Низкая производительность

```lua
-- Включите GPU-ускорение
webgpu_power_preference = "HighPerformance"
front_end = "WebGpu"
```

---

## 📚 Дополнительные ресурсы

- [WezTerm официальный сайт](https://wezfurlong.org/wezterm/)
- [WezTerm GitHub](https://github.com/wez/wezterm)
- [WezTerm документация](https://wezfurlong.org/wezterm/config/files.html)
- [Встроенные темы](https://wezfurlong.org/wezterm/colorschemes/index.html)

---

## 🔗 Связанные документы

- [COMPLETE_SETUP_GUIDE.md](./COMPLETE_SETUP_GUIDE.md) - Полное руководство по настройке терминала
- [USEFUL_ALIASES.md](./USEFUL_ALIASES.md) - Полезные алиасы и команды
- [../README.md](../README.md) - Общая документация Windows конфигурации

---

**Версия**: 1.0  
**Дата**: 2025-01-XX  
**Платформа**: Windows 11 + WSL + WezTerm

**Приятного использования! 🚀**

