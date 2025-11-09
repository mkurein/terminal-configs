# 🚀 LazyVim Setup для WSL

Краткое руководство по настройке LazyVim в WSL.

## 📦 Что такое LazyVim?

**LazyVim** — это готовая конфигурация Neovim с предустановленными плагинами и настройками.

**Преимущества:**
- ⚡ Быстрая установка "из коробки"
- 🔌 Готовые плагины: LSP, автодополнение, файловый менеджер
- 🎨 Современный интерфейс
- 📦 Менеджер плагинов Lazy.nvim
- ⌨️ Продуманные горячие клавиши

---

## 🚀 Установка LazyVim

### 1. Подготовка

```bash
# Удалите старую конфигурацию (если есть)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. Установка LazyVim Starter

```bash
# Клонируйте starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Удалите .git для создания своего репозитория
rm -rf ~/.config/nvim/.git
```

### 3. Первый запуск

```bash
# Запустите Neovim
nvim
```

При первом запуске LazyVim автоматически:
- Установит Lazy.nvim
- Скачает все плагины
- Настроит LSP серверы

**Подождите 1-2 минуты** пока все установится.

---

## 📁 Структура LazyVim

```
~/.config/nvim/
├── init.lua                    # Главный конфиг
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # Автокоманды
│   │   ├── keymaps.lua         # Горячие клавиши
│   │   ├── lazy.lua            # Настройка Lazy.nvim
│   │   └── options.lua         # Настройки Vim
│   └── plugins/
│       └── example.lua         # Ваши плагины
├── lazy-lock.json              # Версии плагинов
└── stylua.toml                 # Форматирование Lua
```

---

## ⌨️ Основные горячие клавиши

### Общие

| Клавиши | Действие |
|---------|----------|
| `Space` | Лидер-клавиша (leader) |
| `Space + Space` | Найти файл |
| `Space + ,` | Переключить буфер |
| `Space + e` | Открыть файловый менеджер (Neo-tree) |
| `Space + /` | Поиск по содержимому (grep) |
| `Ctrl + h/j/k/l` | Навигация между окнами |

### Файловый менеджер (Neo-tree)

| Клавиши | Действие |
|---------|----------|
| `Space + e` | Открыть/закрыть Neo-tree |
| `a` | Создать файл/папку |
| `d` | Удалить |
| `r` | Переименовать |
| `c` | Копировать |
| `x` | Вырезать |
| `p` | Вставить |
| `Space + fe` | Открыть Neo-tree в floating окне |

### LSP (Language Server Protocol)

| Клавиши | Действие |
|---------|----------|
| `gd` | Перейти к определению |
| `gr` | Показать все ссылки |
| `K` | Показать документацию (hover) |
| `Space + ca` | Действия кода (code actions) |
| `Space + cr` | Переименовать (rename) |
| `[d` / `]d` | Предыдущая/следующая ошибка |

### Telescope (поиск)

| Клавиши | Действие |
|---------|----------|
| `Space + Space` | Найти файл |
| `Space + /` | Поиск по содержимому (live grep) |
| `Space + fb` | Найти буфер |
| `Space + fr` | Недавние файлы |
| `Space + gc` | Git commits |

### Буферы и табы

| Клавиши | Действие |
|---------|----------|
| `Space + ,` | Переключить буфер |
| `[b` / `]b` | Предыдущий/следующий буфер |
| `Space + bd` | Удалить буфер |
| `<S-h>` / `<S-l>` | Переключение буферов |

### Терминал

| Клавиши | Действие |
|---------|----------|
| `Space + ft` | Открыть терминал (floating) |
| `Ctrl + /` | Открыть терминал в split |
| `Esc` | Выход из терминала в нормальный режим |

---

## 🔌 Установка LSP серверов

### Через Mason (рекомендуется)

```vim
" В Neovim
:Mason
```

В интерфейсе Mason:
- Найдите нужный LSP сервер (например, `pyright` для Python)
- Нажмите `i` для установки
- Нажмите `g?` для справки

### Автоматическая установка

LazyVim автоматически предложит установить LSP при открытии файла нужного типа.

### Популярные LSP серверы

| Язык | LSP сервер | Установка в Mason |
|------|-----------|-------------------|
| Python | `pyright` | `:Mason` → `pyright` → `i` |
| JavaScript/TypeScript | `typescript-language-server` | `:Mason` → `tsserver` → `i` |
| Lua | `lua-language-server` | Установлен по умолчанию |
| Rust | `rust-analyzer` | `:Mason` → `rust_analyzer` → `i` |
| Go | `gopls` | `:Mason` → `gopls` → `i` |
| C/C++ | `clangd` | `:Mason` → `clangd` → `i` |

---

## 🎨 Добавление языков и плагинов

### Добавить поддержку языка

```vim
:LazyExtras
```

Выберите нужный язык:
- `lang.python` - Python
- `lang.typescript` - TypeScript/JavaScript
- `lang.rust` - Rust
- `lang.go` - Go
- и т.д.

Нажмите `x` для включения/выключения.

### Добавить свой плагин

Создайте файл `~/.config/nvim/lua/plugins/my-plugins.lua`:

```lua
return {
  -- Пример: добавление темы
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
    },
  },

  -- Пример: добавление плагина для Git
  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
}
```

Перезапустите Neovim - плагины установятся автоматически.

---

## 🔧 Кастомизация

### Изменить настройки

Редактируйте `~/.config/nvim/lua/config/options.lua`:

```lua
-- Примеры настроек
vim.opt.relativenumber = true    -- Относительные номера строк
vim.opt.wrap = false              -- Не переносить длинные строки
vim.opt.scrolloff = 8             -- Отступ при скроллинге
vim.opt.tabstop = 4               -- Ширина таба
```

### Добавить горячие клавиши

Редактируйте `~/.config/nvim/lua/config/keymaps.lua`:

```lua
local map = vim.keymap.set

-- Пример: быстрое сохранение
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })

-- Пример: закрыть буфер без выхода
map("n", "<leader>q", ":bd<CR>", { desc = "Close buffer" })
```

---

## 🐛 Устранение неполадок

### Плагины не установились

```vim
:Lazy sync
:Lazy restore
```

### LSP не работает

```vim
:LspInfo          " Информация о LSP
:Mason            " Проверить установку серверов
:checkhealth      " Диагностика всех компонентов
```

### Медленный запуск

```vim
:Lazy profile
```

Проверьте какие плагины загружаются медленно и настройте lazy loading.

### Treesitter: ошибки парсинга

```vim
:TSUpdate         " Обновить парсеры
:TSInstall python " Установить для конкретного языка
```

---

## 💡 Полезные советы

### 1. Which-Key

Нажмите `Space` и подождите 1 секунду - появится список доступных команд.

### 2. Telescope

В Telescope используйте:
- `Ctrl + /` - показать справку по клавишам
- `Ctrl + q` - отправить результаты в quickfix list
- `Ctrl + n/p` - навигация

### 3. LSP сниппеты

При автодополнении:
- `Tab` - следующий вариант
- `Shift + Tab` - предыдущий вариант
- `Ctrl + Space` - показать автодополнение
- `Enter` - выбрать вариант

### 4. Сохранение сессий

```vim
:SessionSave      " Сохранить сессию
:SessionLoad      " Загрузить сессию
```

---

## 📚 Дополнительные ресурсы

- [LazyVim официальный сайт](https://www.lazyvim.org)
- [LazyVim документация](https://lazyvim.github.io/LazyVim/)
- [Список плагинов LazyVim](https://www.lazyvim.org/plugins)
- [Neovim документация](https://neovim.io/doc/)
- [Awesome Neovim плагины](https://github.com/rockerBOO/awesome-neovim)

---

## 🎓 Обучение

### Первые шаги

1. Откройте Neovim: `nvim`
2. Пройдите встроенный туториал: `:Tutor`
3. Изучите Which-Key: нажмите `Space` и посмотрите команды
4. Попробуйте открыть файл: `Space + Space`
5. Попробуйте Neo-tree: `Space + e`

### Практика

- Используйте Neovim для реальных проектов
- Изучайте по одной функции в день
- Настраивайте под себя постепенно
- Используйте `:checkhealth` для диагностики

---

**Версия**: 1.0  
**Дата**: 2025-11-09  
**Платформа**: WSL (Debian/Ubuntu)  
**Компонент**: LazyVim (Neovim distribution)

**Удачи в освоении LazyVim! 🚀**

