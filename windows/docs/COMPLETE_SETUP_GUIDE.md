# 🖥️ Полное руководство: Alacritty + Neovim на Windows/WSL и macOS

## 📋 Содержание

1. [Введение](#введение)
2. [Windows + WSL: Начальная настройка](#windows--wsl-начальная-настройка)
3. [Alacritty: Установка и настройка](#alacritty-установка-и-настройка)
4. [Neovim: Установка и конфигурация](#neovim-установка-и-конфигурация)
5. [Менеджеры плагинов](#менеджеры-плагинов)
6. [LSP и автодополнение](#lsp-и-автодополнение)
7. [Готовые конфигурации](#готовые-конфигурации)
8. [Полезные советы](#полезные-советы)

---

## Введение

### 🎯 Что это за руководство?

Это объединенное руководство по настройке современного терминального окружения для разработки:
- **Alacritty** — быстрый GPU-ускоренный терминал
- **Neovim** — мощный настраиваемый редактор
- **WSL2** — Linux-подсистема для Windows (опционально)

### ✨ Зачем это нужно?

- **Скорость**: GPU-ускорение в Alacritty, быстрый запуск Neovim
- **Кроссплатформенность**: Одинаковые конфиги на Windows, macOS, Linux
- **Гибкость**: Настройте все под себя
- **Продуктивность**: Современные инструменты разработки

---

## Windows + WSL: Начальная настройка

> 💡 **Для пользователей macOS/Linux**: Пропустите этот раздел и переходите к [Alacritty](#alacritty-установка-и-настройка)

### 1. Установка WSL2

**Откройте PowerShell от администратора** и выполните:

```powershell
wsl --install
```

После установки:
1. Перезагрузите компьютер
2. Выберите дистрибутив (рекомендуется **Ubuntu** или **Debian**)
3. Создайте пользователя и установите пароль

### 2. Первичная настройка WSL

```bash
# Обновление системы
sudo apt update && sudo apt upgrade -y

# Установка базовых инструментов
sudo apt install git curl wget build-essential unzip zip -y
```

### 3. Настройка Git

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global core.quotePath false
git config --global alias.st status
```

### 4. Установка дополнительных инструментов

```bash
# Инструменты для разработки
sudo apt install tmux zsh ripgrep fd-find -y

# Oh My Zsh (опционально)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 5. Структура конфигов

Создайте директории для хранения конфигурационных файлов:

```bash
mkdir -p ~/.config/{nvim,tmux,zsh,alacritty}
```

### 6. Настройка автозапуска Zsh в WSL

Если хотите автоматически запускать Zsh при старте WSL, добавьте в `~/.bashrc`:

```bash
# В конец файла ~/.bashrc
if [ -t 1 ]; then
  exec zsh
fi
```

---

## Alacritty: Установка и настройка

### 🖥️ Что такое Alacritty?

**Alacritty** — самый быстрый терминал, использующий GPU для отрисовки текста.

**Преимущества:**
- ⚡ Невероятная скорость благодаря GPU-ускорению
- 🎨 Полная кастомизация через конфиг
- 🌍 Кроссплатформенность (macOS, Linux, Windows)
- 📦 Легковесный и современный (написан на Rust)

### Установка

#### macOS

```bash
# Через Homebrew (рекомендуется)
brew install --cask alacritty

# Или скачайте .dmg с GitHub
# https://github.com/alacritty/alacritty/releases
```

#### Linux

```bash
# Ubuntu/Debian
sudo apt install alacritty

# Arch Linux
sudo pacman -S alacritty

# Fedora
sudo dnf install alacritty
```

#### Windows

**Вариант 1: Scoop**
```powershell
scoop install alacritty
```

**Вариант 2: Chocolatey**
```powershell
choco install alacritty
```

**Вариант 3:** Скачайте установщик с [GitHub Releases](https://github.com/alacritty/alacritty/releases)

### Создание конфигурационного файла

#### macOS и Linux

```bash
# Создайте директорию
mkdir -p ~/.config/alacritty

# Создайте файл конфига
touch ~/.config/alacritty/alacritty.toml

# Откройте в редакторе
nvim ~/.config/alacritty/alacritty.toml
```

#### Windows

```powershell
# Создайте директорию
New-Item -ItemType Directory -Force -Path $env:APPDATA\alacritty

# Создайте файл
New-Item -ItemType File -Path $env:APPDATA\alacritty\alacritty.toml

# Откройте в Блокноте
notepad $env:APPDATA\alacritty\alacritty.toml
```

### 🎨 Базовая конфигурация Alacritty

#### Минимальная конфигурация (для начала)

```toml
# ~/.config/alacritty/alacritty.toml

# ===== ОКНО =====
[window]
opacity = 0.95
padding = { x = 10, y = 10 }
dynamic_padding = true

# ===== ШРИФТ =====
[font]
size = 13.0

[font.normal]
family = "JetBrains Mono"
style = "Regular"

# ===== ЦВЕТА (Catppuccin Mocha) =====
[colors.primary]
background = "#1e1e2e"
foreground = "#cdd6f4"

[colors.cursor]
cursor = "#f5e0dc"
text = "#1e1e2e"

[colors.normal]
black = "#45475a"
red = "#f38ba8"
green = "#a6e3a1"
yellow = "#f9e2af"
blue = "#89b4fa"
magenta = "#f5c2e7"
cyan = "#94e2d5"
white = "#bac2de"

[colors.bright]
black = "#585b70"
red = "#f38ba8"
green = "#a6e3a1"
yellow = "#f9e2af"
blue = "#89b4fa"
magenta = "#f5c2e7"
cyan = "#94e2d5"
white = "#a6adc8"

# ===== ГОРЯЧИЕ КЛАВИШИ =====
# macOS: используйте "Command"
# Windows/Linux: используйте "Control"

[[keyboard.bindings]]
key = "V"
mods = "Command"  # или Control на Windows/Linux
action = "Paste"

[[keyboard.bindings]]
key = "C"
mods = "Command"
action = "Copy"

[[keyboard.bindings]]
key = "N"
mods = "Command"
action = "SpawnNewInstance"

[[keyboard.bindings]]
key = "Plus"
mods = "Command"
action = "IncreaseFontSize"

[[keyboard.bindings]]
key = "Minus"
mods = "Command"
action = "DecreaseFontSize"

[[keyboard.bindings]]
key = "Key0"
mods = "Command"
action = "ResetFontSize"
```

#### Настройка для WSL (только Windows)

```toml
# Добавьте в alacritty.toml для запуска WSL

[shell]
program = 'C:\Windows\System32\wsl.exe'
args = ['~']

# Или для конкретного дистрибутива:
# program = 'C:\Windows\System32\wsl.exe'
# args = ['-d', 'Ubuntu', '~']
```

### 🔤 Установка Nerd Fonts

**Почему Nerd Fonts?**
- Содержат иконки для файлов, Git, и т.д.
- Необходимы для Neo-tree, Lualine и других плагинов

#### macOS

```bash
brew tap homebrew/cask-fonts

# JetBrains Mono Nerd Font (рекомендуется)
brew install --cask font-jetbrains-mono-nerd-font

# Или Hack Nerd Font
brew install --cask font-hack-nerd-font

# Или Fira Code
brew install --cask font-fira-code-nerd-font
```

#### Linux

```bash
# Ubuntu/Debian
sudo apt install fonts-jetbrains-mono

# Или вручную:
mkdir -p ~/.fonts
cd ~/.fonts
# Скачайте шрифт с nerdfonts.com и распакуйте сюда
fc-cache -fv
```

#### Windows

1. Перейдите на [nerdfonts.com](https://www.nerdfonts.com/)
2. Скачайте нужный шрифт (например, JetBrainsMono)
3. Распакуйте архив
4. ПКМ на .ttf файлах → "Установить"

### 📊 Полная продвинутая конфигурация Alacritty

```toml
# ===== ОКНО =====
[window]
dimensions = { columns = 120, lines = 40 }
padding = { x = 15, y = 15 }
dynamic_padding = true
decorations = "Full"  # Full, None, Transparent, Buttonless
opacity = 0.92
blur = true  # Только macOS
startup_mode = "Windowed"  # Windowed, Maximized, Fullscreen

# ===== СКРОЛЛИНГ =====
[scrolling]
history = 10000
multiplier = 3

# ===== ШРИФТ =====
[font]
size = 14.0

[font.normal]
family = "JetBrains Mono Nerd Font"
style = "Regular"

[font.bold]
family = "JetBrains Mono Nerd Font"
style = "Bold"

[font.italic]
family = "JetBrains Mono Nerd Font"
style = "Italic"

[font.bold_italic]
family = "JetBrains Mono Nerd Font"
style = "Bold Italic"

# ===== КУРСОР =====
[cursor]
style = { shape = "Block", blinking = "On" }
unfocused_hollow = true
blink_interval = 750

# ===== ЦВЕТА (Tokyo Night) =====
[colors.primary]
background = "#1a1b26"
foreground = "#c0caf5"

[colors.cursor]
cursor = "#c0caf5"
text = "#1a1b26"

[colors.selection]
background = "#33467C"
text = "#c0caf5"

[colors.normal]
black = "#15161e"
red = "#f7768e"
green = "#9ece6a"
yellow = "#e0af68"
blue = "#7aa2f7"
magenta = "#bb9af7"
cyan = "#7dcfff"
white = "#a9b1d6"

[colors.bright]
black = "#414868"
red = "#f7768e"
green = "#9ece6a"
yellow = "#e0af68"
blue = "#7aa2f7"
magenta = "#bb9af7"
cyan = "#7dcfff"
white = "#c0caf5"

# ===== ГОРЯЧИЕ КЛАВИШИ =====
[[keyboard.bindings]]
key = "V"
mods = "Command"
action = "Paste"

[[keyboard.bindings]]
key = "C"
mods = "Command"
action = "Copy"

[[keyboard.bindings]]
key = "N"
mods = "Command"
action = "SpawnNewInstance"

[[keyboard.bindings]]
key = "F"
mods = "Command"
action = "ToggleFullscreen"

[[keyboard.bindings]]
key = "K"
mods = "Command"
action = "ClearHistory"

[[keyboard.bindings]]
key = "Equals"
mods = "Command"
action = "IncreaseFontSize"

[[keyboard.bindings]]
key = "Minus"
mods = "Command"
action = "DecreaseFontSize"

[[keyboard.bindings]]
key = "Key0"
mods = "Command"
action = "ResetFontSize"

# ===== МЫШЬ =====
[mouse]
hide_when_typing = true

[[mouse.bindings]]
mouse = "Middle"
action = "PasteSelection"

# ===== HINTS (клик по URL) =====
[[hints.enabled]]
regex = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+"
command = "open"  # macOS
# command = "xdg-open"  # Linux
# command = "explorer"  # Windows
mouse = { enabled = true }

# ===== ОБОЛОЧКА =====
[shell]
program = "/bin/zsh"  # macOS/Linux
# program = "C:\\Windows\\System32\\wsl.exe"  # Windows + WSL
# args = ["~"]

# ===== КОЛОКОЛЬЧИК =====
[bell]
animation = "EaseOutExpo"
duration = 0  # 0 = отключено
```

### 🎨 Популярные цветовые схемы

**Catppuccin Mocha** (мягкая, современная):
```toml
[colors.primary]
background = "#1e1e2e"
foreground = "#cdd6f4"
```

**Dracula** (классическая):
```toml
[colors.primary]
background = "#282a36"
foreground = "#f8f8f2"
```

**Nord** (холодная, минималистичная):
```toml
[colors.primary]
background = "#2e3440"
foreground = "#d8dee9"
```

**Gruvbox** (теплая, ретро):
```toml
[colors.primary]
background = "#282828"
foreground = "#ebdbb2"
```

> 💡 **Совет**: Больше тем на [github.com/alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme)

---

## Neovim: Установка и конфигурация

### 🚀 Почему Neovim?

- ⚡ Быстрый терминальный редактор
- 🔌 Современная архитектура плагинов
- 🎯 Мощные возможности кастомизации
- 🆓 Бесплатный и open-source
- 💻 Крутая альтернатива JetBrains/VSCode

### Установка Neovim

#### macOS

```bash
brew install neovim
```

#### Linux

```bash
# Ubuntu/Debian (может быть старая версия)
sudo apt install neovim

# Или через snap (свежая версия)
sudo snap install --classic nvim

# Arch Linux
sudo pacman -S neovim

# Fedora
sudo dnf install neovim
```

#### Windows (WSL)

```bash
# В WSL Ubuntu
sudo apt install neovim

# Или через snap
sudo snap install --classic nvim
```

**Проверка установки:**
```bash
nvim --version
# Должна быть версия 0.9.0+
```

### 📁 Структура конфигурации Neovim

#### Базовая структура

```
~/.config/nvim/
├── init.lua                 # Главный конфиг
└── lua/
    ├── settings.lua         # Настройки Vim
    ├── keymaps.lua          # Горячие клавиши
    ├── plugins.lua          # Менеджер плагинов
    └── lsp.lua             # LSP конфигурация
```

### 🔧 Создание базовой конфигурации

#### 1. Создайте структуру

```bash
mkdir -p ~/.config/nvim/lua
cd ~/.config/nvim
```

#### 2. Главный файл: `init.lua`

```lua
-- ~/.config/nvim/init.lua

-- Загрузка модулей
require("settings")
require("keymaps")
require("plugins")
require("lsp")

-- Вывод при старте
print("✨ Neovim loaded!")
```

#### 3. Базовые настройки: `lua/settings.lua`

```lua
-- ~/.config/nvim/lua/settings.lua

-- Номера строк
vim.o.number = true                    -- Показывать номера строк
vim.o.relativenumber = true            -- Относительные номера

-- Отступы и табы
vim.o.tabstop = 4                      -- Ширина таба
vim.o.shiftwidth = 4                   -- Ширина отступа
vim.o.expandtab = true                 -- Пробелы вместо табов
vim.o.smartindent = true               -- Умные отступы

-- Поиск
vim.o.ignorecase = true                -- Игнорировать регистр при поиске
vim.o.smartcase = true                 -- Учитывать регистр если есть большие буквы
vim.o.hlsearch = true                  -- Подсветка результатов поиска
vim.o.incsearch = true                 -- Инкрементальный поиск

-- Внешний вид
vim.o.termguicolors = true             -- Поддержка 24-bit цветов
vim.o.wrap = false                     -- Не переносить длинные строки
vim.o.cursorline = true                -- Подсветка текущей строки
vim.o.signcolumn = "yes"               -- Всегда показывать колонку знаков

-- Буфер обмена
vim.o.clipboard = "unnamedplus"        -- Системный буфер обмена

-- Файлы
vim.o.swapfile = false                 -- Не создавать swap файлы
vim.o.backup = false                   -- Не создавать backup
vim.o.undofile = true                  -- Сохранять историю отмены

-- Производительность
vim.o.updatetime = 250                 -- Быстрее обновление
vim.o.timeoutlen = 300                 -- Меньше задержка для комбинаций

-- Разделение окон
vim.o.splitright = true                -- Новые окна справа
vim.o.splitbelow = true                -- Новые окна снизу

-- Мышь
vim.o.mouse = "a"                      -- Включить мышь

-- Скроллинг
vim.o.scrolloff = 8                    -- Отступ при скроллинге
vim.o.sidescrolloff = 8
```

#### 4. Горячие клавиши: `lua/keymaps.lua`

```lua
-- ~/.config/nvim/lua/keymaps.lua

-- Лидер-клавиша (пробел)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ===== Основные =====
-- Сохранить файл
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("i", "<C-s>", "<Esc>:w<CR>a", opts)

-- Выйти
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

-- ===== Навигация =====
-- Перемещение между окнами
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Изменение размера окон
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- ===== Буферы =====
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>x", ":bdelete<CR>", opts)

-- ===== Визуальный режим =====
-- Перемещение блоков
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Сохранение отступа при сдвиге
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- ===== Файловый менеджер (Neo-tree) =====
keymap("n", "<leader>e", ":Neotree toggle<CR>", opts)
keymap("n", "<leader>o", ":Neotree focus<CR>", opts)

-- ===== Телескоп (поиск файлов) =====
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- ===== LSP =====
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "K", vim.lsp.buf.hover, opts)
keymap("n", "gr", vim.lsp.buf.references, opts)
keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)

-- ===== Прочее =====
-- Отключить подсветку поиска
keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Быстрый выход из терминала
keymap("t", "<Esc>", "<C-\\><C-n>", opts)
```

---

## Менеджеры плагинов

### 🔌 Lazy.nvim (рекомендуется)

**Lazy.nvim** — современный менеджер плагинов с быстрой загрузкой.

#### Установка Lazy.nvim

Добавьте в начало `~/.config/nvim/lua/plugins.lua`:

```lua
-- ~/.config/nvim/lua/plugins.lua

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- Настройка плагинов
require("lazy").setup({
  -- ===== Файловый менеджер =====
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 30,
        },
      })
    end,
  },

  -- ===== Telescope (поиск файлов) =====
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ===== Treesitter (подсветка синтаксиса) =====
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "rust", "go" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- ===== LSP =====
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- ===== Автодополнение =====
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- ===== Git интеграция =====
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ===== Цветовая тема =====
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  -- Или Catppuccin
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd([[colorscheme catppuccin-mocha]])
  --   end,
  -- },

  -- ===== Statusline =====
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
      })
    end,
  },

  -- ===== Autopairs =====
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- ===== Комментирование =====
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- ===== Which-key (подсказки клавиш) =====
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
})
```

#### Команды Lazy.nvim

```vim
:Lazy          " Открыть UI Lazy.nvim
:Lazy update   " Обновить все плагины
:Lazy sync     " Синхронизировать (установить/обновить/удалить)
:Lazy clean    " Удалить неиспользуемые плагины
:Lazy profile  " Профилирование времени загрузки
```

---

## LSP и автодополнение

### 🔌 Что такое LSP?

**Language Server Protocol** обеспечивает:
- ✅ Автодополнение
- ✅ Диагностика ошибок
- ✅ Jump to definition
- ✅ Hover информация
- ✅ Рефакторинг

### Настройка LSP с Mason

#### 1. Конфигурация LSP: `lua/lsp.lua`

```lua
-- ~/.config/nvim/lua/lsp.lua

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",       -- Lua
    "pyright",      -- Python
    "tsserver",     -- TypeScript/JavaScript
    "rust_analyzer",-- Rust
    "gopls",        -- Go
  },
  automatic_installation = true,
})

-- Настройка автодополнения
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Общие настройки для всех LSP
local on_attach = function(client, bufnr)
  -- Включаем форматирование при сохранении
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Настройка отдельных LSP серверов
local lspconfig = require("lspconfig")

-- Lua
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- Python
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- TypeScript/JavaScript
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Rust
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
```

#### 2. Установка LSP серверов через Mason

После настройки, откройте Neovim:

```vim
:Mason
```

В интерфейсе Mason:
- Найдите нужный LSP сервер
- Нажмите `i` для установки
- Или установите автоматически (уже настроено в конфиге выше)

### 📦 Установка LSP вручную

Если нужно установить LSP серверы вручную:

```bash
# Python
pip install python-lsp-server
# или
npm install -g pyright

# TypeScript/JavaScript
npm install -g typescript typescript-language-server

# Go
go install golang.org/x/tools/gopls@latest

# Rust
rustup component add rust-analyzer

# Lua (через Mason или cargo)
cargo install lua-language-server
```

### 🔧 Настройка буфера обмена (Windows + WSL)

Для корректной работы копирования между WSL и Windows:

```bash
# Скачайте win32yank
# https://github.com/equalsraf/win32yank/releases

# Переместите в PATH (например, в ~/.local/bin)
mkdir -p ~/.local/bin
mv win32yank.exe ~/.local/bin/
chmod +x ~/.local/bin/win32yank.exe

# Добавьте в PATH (в ~/.bashrc или ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"
```

В Neovim добавьте:

```lua
-- В lua/settings.lua или init.lua
vim.g.clipboard = {
  name = 'win32yank',
  copy = {
    ['+'] = 'win32yank.exe -i --crlf',
    ['*'] = 'win32yank.exe -i --crlf',
  },
  paste = {
    ['+'] = 'win32yank.exe -o --lf',
    ['*'] = 'win32yank.exe -o --lf',
  },
  cache_enabled = true,
}
```

---

## Готовые конфигурации

### 🎁 LazyVim (готовая сборка)

**LazyVim** — это готовая конфигурация Neovim с предустановленными плагинами.

#### Установка LazyVim

```bash
# Backup существующей конфигурации
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Клонирование LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Удалите .git для создания своего репозитория
rm -rf ~/.config/nvim/.git

# Запустите Neovim
nvim
```

При первом запуске LazyVim автоматически установит все плагины.

#### Настройка LazyVim

LazyVim использует структуру:
```
~/.config/nvim/
├── lua/
│   ├── config/
│   │   ├── options.lua    # Ваши настройки
│   │   ├── keymaps.lua    # Ваши клавиши
│   │   └── autocmds.lua   # Автокоманды
│   └── plugins/
│       └── *.lua          # Ваши плагины
└── init.lua
```

**Добавление поддержки языков:**

```vim
:LazyExtras
```

Выберите нужный язык (Python, Go, Rust, и т.д.) и нажмите `x` для включения.

### 📝 Пример простого плагина

Создайте свой плагин для подсветки:

```lua
-- ~/.config/nvim/lua/custom/highlight.lua

local M = {}

function M.highlight_rust()
  vim.cmd("syntax match RustKeyword /rust/i")
  vim.cmd("highlight RustKeyword guibg=#cc5425 guifg=#ffffff")
  print("✨ Rust highlighting loaded!")
end

return M
```

Использование:

```lua
-- В init.lua
require("custom.highlight").highlight_rust()
```

---

## Полезные советы

### 🎯 Быстрый старт

1. **Начните с минимальной конфигурации** — не добавляйте все плагины сразу
2. **Изучайте по одному плагину** — освойте базу перед продвинутыми функциями
3. **Используйте Which-Key** — он покажет доступные комбинации клавиш
4. **Практикуйтесь** — используйте Neovim для реальных проектов

### ⌨️ Основные команды Vim

```vim
" Режимы
i         " Режим вставки
Esc       " Нормальный режим
v         " Визуальный режим
:         " Командный режим

" Навигация
h j k l   " Влево, вниз, вверх, вправо
w         " Следующее слово
b         " Предыдущее слово
0         " Начало строки
$         " Конец строки
gg        " Начало файла
G         " Конец файла

" Редактирование
dd        " Удалить строку
yy        " Копировать строку
p         " Вставить
u         " Отменить
Ctrl+r    " Повторить

" Сохранение/выход
:w        " Сохранить
:q        " Выйти
:wq       " Сохранить и выйти
:q!       " Выйти без сохранения
```

### 🔍 Диагностика проблем

```vim
:checkhealth          " Проверка здоровья Neovim
:Mason                " Проверка LSP серверов
:Lazy                 " Проверка плагинов
:messages             " Показать сообщения
:lua print(vim.inspect(vim.lsp.buf_get_clients()))  " LSP клиенты
```

### 📚 Полезные ресурсы

- **Neovim официальный сайт:** [neovim.io](https://neovim.io)
- **LazyVim:** [lazyvim.org](https://www.lazyvim.org)
- **Awesome Neovim:** [github.com/rockerBOO/awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
- **Neovim Discord:** [discord.com/invite/neovim](https://discord.com/invite/neovim)
- **Alacritty темы:** [github.com/alacritty/alacritty-theme](https://github.com/alacritty/alacritty-theme)
- **Nerd Fonts:** [nerdfonts.com](https://www.nerdfonts.com)

### 🐛 Типичные проблемы

#### Alacritty: шрифт не применяется
```bash
# Проверьте установленные шрифты
# macOS
system_profiler SPFontsDataType | grep -i "jetbrains"

# Linux
fc-list | grep -i "jetbrains"

# Windows
# Панель управления → Шрифты
```

#### Neovim: LSP не работает
```vim
:LspInfo              " Информация о LSP
:Mason                " Проверить установку серверов
:checkhealth lsp      " Диагностика LSP
```

#### Neovim: медленный запуск
```vim
:Lazy profile         " Профилирование плагинов
```

Отключите ненужные плагины или настройте lazy loading.

#### WSL: проблемы с буфером обмена
- Убедитесь, что win32yank установлен и в PATH
- Проверьте настройки clipboard в конфиге

---

## 🎉 Заключение

Теперь у вас есть полное руководство по настройке современного терминального окружения!

**Что мы настроили:**
- ✅ WSL2 (для Windows)
- ✅ Alacritty — быстрый терминал
- ✅ Neovim — мощный редактор
- ✅ Плагины и LSP
- ✅ Автодополнение и навигацию

**Следующие шаги:**
1. Начните с базовой конфигурации
2. Постепенно добавляйте плагины
3. Настраивайте под свои нужды
4. Практикуйтесь и изучайте новые возможности

**Удачи в настройке! 🚀**

---

**Версия**: 1.0
**Дата**: 2025-11-08
**Платформа**: Windows/WSL, macOS, Linux
**Источники**: Guide_NeovimWindows_WSL.md, alacritty-detailed-guide.md, Neovim_LazyVim.md

