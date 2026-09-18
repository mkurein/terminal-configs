# 🖥️ Terminal Configurations

Кроссплатформенный репозиторий конфигураций для терминала с **Alacritty / WezTerm + Zellij + Neovim**.

Публичный канон на GitHub: [mkurein/terminal-configs](https://github.com/mkurein/terminal-configs).  
Домашнее зеркало на NAS: [mxm/terminal-configs](http://100.64.0.12:3000/mxm/terminal-configs) (Forgejo, веб). Git по SSH, не по этой HTTP-ссылке.

Общие git/gh-обёртки без SOCKS-прокси: [`github-proxy/`](./github-proxy/) — подробности в [`github-proxy/GIT_PS_GUIDE.md`](./github-proxy/GIT_PS_GUIDE.md). Этот раздел README — **как работать каждый день**. Скрипты и пункты `github-gh` будем наращивать здесь же.

---

## Как работать с GitHub и Forgejo

### Зачем две копии

| Куда | Зачем | URL для git |
|---|---|---|
| GitHub `mkurein/terminal-configs` | публичный origin, `gh`, PR, Actions | `https://github.com/mkurein/terminal-configs.git` |
| Forgejo `mxm/terminal-configs` | зеркало на NAS, домашний backup | `ssh://git@100.64.0.12:2222/mxm/terminal-configs.git` |

Веб Forgejo (`http://100.64.0.12:3000/mxm/terminal-configs.git`) — **страница в браузере**. `git clone` / `git pull` / `git push` по HTTP `:3000` не используем: пустой репо, логин, прокси. Для git — только SSH `:2222` (из дома тот же хост через Tailscale).

`origin` **скачивает с GitHub** и **пушит сразу в оба** (GitHub + Forgejo), как Lite / ApiHA / homelab-book.

### Один раз на машине

Одного `git clone` **мало**. `. $PROFILE` / новый zsh подхватывают уже **установленный** профиль пользователя — clone его сам не создаёт.

После установки команды работают в **любом** каталоге с `.git` (Lite, ApiHA, homelab-book, …), не только в `terminal-configs`. Они смотрят на **текущий** репо.

| Команда | Что делает |
|---|---|
| `github-fetch` | fetch **каждого** remote этого репо (мёртвый URL пропускает) |
| `github-pull` | `git pull` текущей ветки с tracking (`origin` = GitHub) |
| `github-commit` | commit только **staging**; одна строка в кавычках, много строк — без аргументов (Ctrl-D) или `-e` |
| `github-push` | `git push -u origin HEAD` на **все** push-URL `origin` |
| `github-gh` | меню `gh` CLI без прокси (auth, PR, runs — будем расширять) |

Это не `gq` / `gp` / `gl`: они прокси не чистят. Для GitHub по HTTPS с живым SOCKS — только `github-*`.

#### Команда не распознана (`The term 'github-…' is not recognized`)

Это **не PATH**. Имена живут в профиле. Открытый терминал помнит старую загрузку.

**Windows — в этой же сессии:**

```powershell
. $PROFILE
```

**Что это делает.** `$PROFILE` — путь к файлу профиля этого PowerShell (не команда и не PATH). Обычно `…\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (часто под OneDrive). Точка `.` — выполнить файл **в текущей** сессии (как `source` в zsh).

Профиль читается **один раз при открытии** окна. `github-fetch` / `github-commit` — функции из этого файла, их нет в PATH. После `install.ps1` или правок профиля уже открытый терминал ничего не знает, пока не сделать `. $PROFILE` (или не открыть новое окно). Команда не ставит Git, не клонирует репо и не меняет файлы на диске: только заново объявляет функции **здесь**.

Проверка: `echo $PROFILE` — какой файл; после точки в Tip должны быть все имена, включая `github-commit`. Если нет — профиль на диске старый:

```powershell
cd C:\Project\terminal-configs\windows\powershell
.\install.ps1
. $PROFILE
```

Справка: `github-help`.

Без профиля, из любого `.git`:

```powershell
& C:\Project\terminal-configs\github-proxy\github-commit.ps1 "сообщение"
& C:\Project\terminal-configs\github-proxy\github-fetch.ps1
```

**macOS:**

```bash
source ~/.zshrc
source "$HOME/Project/terminal-configs/github-proxy/env.sh"
# напрямую:
~/Project/terminal-configs/github-proxy/github-commit.sh "сообщение"
```

#### Новая Windows

1. Git for Windows. По желанию GitHub CLI: `winget install GitHub.cli`.
2. Clone в одно из мест, которые профиль ищет сам:

```powershell
git clone https://github.com/mkurein/terminal-configs.git C:\Project\terminal-configs
```

Также подхватываются `~\Project\terminal-configs` и `~\terminal-configs`. Иначе в этой сессии (лучше — в профиле насовсем):

```powershell
$env:GITHUB_PROXY_HOME = "D:\где\лежит\terminal-configs\github-proxy"
```

3. Поставить PowerShell-профиль (копирует шаблон в `$PROFILE`):

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
cd C:\Project\terminal-configs\windows\powershell
.\install.ps1
```

4. Новый терминал или `. $PROFILE`.
5. Для `github-gh` один раз: `gh auth login` (или пункт меню).

Проверка: в любом git-репо `github-fetch` печатает `Fetching origin` (и `Fetching forgejo`, если этот remote есть).

Профиль не «живёт» внутри clone. Если обновился `windows/powershell/Microsoft.PowerShell_profile.ps1` — снова `.\install.ps1`.

#### Новая macOS

1. Git (часто уже есть; иначе `xcode-select --install`). GitHub CLI: `brew install gh`.
2. Clone туда, откуда aliases сами берут `env.sh`:

```bash
git clone https://github.com/mkurein/terminal-configs.git ~/Project/terminal-configs
```

Также ищутся `~/terminal-configs` и `~/terminal-configs-backup`. Иначе в `~/.zshrc`:

```bash
export GITHUB_PROXY_HOME="$HOME/другой/путь/terminal-configs/github-proxy"
```

3. Поставить zsh-алиасы. Полный стек терминала:

```bash
cd ~/Project/terminal-configs/macos
./install.sh
```

Это копирует `zsh/aliases.zsh` → `~/.config/zsh/aliases.zsh`. В `~/.zshrc` должна быть строка (если её ещё нет — добавить):

```bash
[[ -f ~/.config/zsh/aliases.zsh ]] && source ~/.config/zsh/aliases.zsh
```

Минимум без Alacritty/Zellij — только git-обёртки, в `~/.zshrc`:

```bash
source "$HOME/Project/terminal-configs/github-proxy/env.sh"
```

4. Новый терминал или `source ~/.zshrc`.
5. Для `github-gh` один раз: `gh auth login`.

Дальше те же имена, что на Windows: `github-fetch`, `github-pull`, `github-commit`, `github-push`, `github-gh`.

#### Что не ставится само

- Dual GitHub+Forgejo в **другом** проекте. Свежий `git clone` с GitHub даёт только `origin` (один fetch и один push на GitHub). `github-fetch` качает те remote, что уже прописаны в этом `.git`. Второй push на NAS и имя `forgejo` — руками, как ниже.
- `github-push` зеркалит на NAS только если у `origin` есть второй push SSH `:2222`.

#### Связать репо с GitHub и Forgejo

Схема одна для всех проектов (Lite, ApiHA, этот репо, …):

| Роль | URL | Кто пользуется |
|---|---|---|
| `origin` **fetch** | GitHub (HTTPS или `git@github.com:…`) | `github-pull`, tracking ветки (`origin/main`) |
| `origin` **push** №1 | тот же GitHub | `github-push` — публичная копия |
| `origin` **push** №2 | Forgejo SSH `:2222` | тот же `github-push` — зеркало на NAS |
| remote `forgejo` | тот же SSH `:2222` | только чтобы `github-fetch` видел NAS; **pull сюда не ходит** |

Веб Forgejo (`http://100.64.0.12:3000/…`) в remotes **не пишем**. Пустой репо на NAS сначала создай в браузере (без README), git — только `ssh://git@100.64.0.12:2222/mxm/ИМЯ.git`.

**1. Посмотри, что уже есть** (не добавляй Forgejo второй раз — Git просто продублирует URL):

```powershell
cd путь\к\репо
git remote -v
git remote get-url origin
git remote get-url --push --all origin
```

Без `--all` `get-url --push` показывает **только первый** push-URL (часто GitHub) и прячет NAS.

**2. Свежий clone с GitHub** — fetch уже правильный. Добавь зеркало:

```powershell
# подставь свой GitHub и имя на NAS (орг Forgejo: mxm)
$gh = "https://github.com/OWNER/REPO.git"   # или git@github.com:OWNER/REPO.git
$fj = "ssh://git@100.64.0.12:2222/mxm/REPO.git"

git remote set-url --add --push origin $fj
git remote add forgejo $fj     # если имени forgejo ещё нет
```

Если `forgejo` уже есть: `git remote set-url forgejo $fj`.

**3. С нуля / битый URL** (старый owner, HTTP `:3000`, один push не туда). Пример **этого** репо:

```powershell
cd C:\Project\terminal-configs   # на Mac — путь к clone

git remote set-url origin https://github.com/mkurein/terminal-configs.git
git remote set-url --push origin https://github.com/mkurein/terminal-configs.git
git remote set-url --add --push origin ssh://git@100.64.0.12:2222/mxm/terminal-configs.git
git remote remove forgejo 2>$null
git remote add forgejo ssh://git@100.64.0.12:2222/mxm/terminal-configs.git
```

На macOS / zsh то же, только удаление имени: `git remote remove forgejo 2>/dev/null || true`.

После настройки tracking должен смотреть на **GitHub**, не на `forgejo`:

```powershell
git branch --set-upstream-to=origin/main
```

(подставь свою ветку вместо `main`).

Ожидаемый `git remote -v` **этого** репо:

```
forgejo  ssh://git@100.64.0.12:2222/mxm/terminal-configs.git (fetch)
forgejo  ssh://git@100.64.0.12:2222/mxm/terminal-configs.git (push)
origin   https://github.com/mkurein/terminal-configs.git (fetch)
origin   https://github.com/mkurein/terminal-configs.git (push)
origin   ssh://git@100.64.0.12:2222/mxm/terminal-configs.git (push)
```

| Строка | Зачем |
|---|---|
| `origin` fetch GitHub | `github-pull` / `origin/main` качают отсюда |
| `origin` push GitHub | публичная копия |
| `origin` push SSH Forgejo | тот же `github-push` сразу зеркалит на NAS |
| `forgejo` fetch+push SSH | `github-fetch` видит NAS; в `git pull` это имя не участвует |

У Lite / ApiHA / homelab-book имени `forgejo` может не быть: `github-fetch` тогда качает только GitHub, а `github-push` всё равно идёт в оба, если у `origin` два push-URL.

#### Как проверить: откуда pull, куда push

Команды ниже **ничего не отправляют**. Терминал уже в корне репо.

**Откуда будет `github-pull` / `git pull`**

Pull берёт **fetch-URL** remote, на который смотрит текущая ветка (обычно `origin`), не второй push-URL.

```powershell
git remote get-url origin
git --no-pager status -sb
git --no-pager branch -vv
git rev-parse --abbrev-ref --symbolic-full-name "@{u}"
```

| Что увидишь | Значит |
|---|---|
| `get-url origin` → `github.com/…` | pull с GitHub |
| `get-url origin` → `:3000` или только Forgejo | **неправильно** — pull не с GitHub |
| `## main...origin/main` | tracking = `origin` (GitHub) |
| `## main...forgejo/main` | tracking на NAS — `github-pull` пойдёт в Forgejo; верни `git branch --set-upstream-to=origin/main` |
| `@{u}` → `origin/main` | так и должно |
| `[behind N]` | нужно pull |
| `[ahead N]` | нужно push |
| `[ahead N, behind N]` | истории разошлись |

**Куда будет `github-push`**

Push идёт на **все** push-URL **`origin`** (имя `forgejo` при `github-push` не используется).

```powershell
git remote get-url --push --all origin
git remote -v
```

| Что увидишь | Куда уйдёт `github-push` |
|---|---|
| одна строка GitHub | только GitHub, NAS не обновится |
| GitHub **и** `ssh://git@100.64.0.12:2222/…` | GitHub + Forgejo — это цель |
| есть `:3000` | убери, замени на SSH `:2222` |
| две одинаковые строки Forgejo | `--add --push` запускали дважды; лишнюю убери (`git remote set-url --delete --push origin URL`) |

В `git remote -v` смотри подписи `(fetch)` и `(push)` у **`origin`**: одна fetch-строка = pull, все push-строки = цели push.

Живая проверка без слияния: `github-fetch` печатает `Fetching origin` (GitHub) и `Fetching forgejo` (NAS), если имя `forgejo` есть. После `github-push` в выводе Git два `To https://github.com/…` и `To ssh://…:2222/…`. Веб `:3000` обновляется только после успешного push на SSH.

### Обычный день

Терминал уже в нужном проекте (`terminal-configs`, Lite, ApiHA, …).

Сначала проверь, что `github-*` есть **в этой** сессии (профиль грузится один раз при открытии окна; после правок шаблона старый терминал их не видит).

```powershell
Get-Command github-commit -ErrorAction SilentlyContinue
# нет вывода / is not recognized → подгрузить профиль (см. выше, что делает . $PROFILE):
. $PROFILE
# macOS: source ~/.zshrc

github-fetch          # GitHub + Forgejo, без слияния
git status
github-pull           # влить origin/текущая-ветка
# … правки …
git add path/to/file
github-commit "краткое why"
# много строк: github-commit   затем вставить текст, Ctrl-D
# или: github-commit -e
git branch --show-current    # не пушить main вслепую
github-push           # GitHub и NAS одним разом
github-gh             # PR / auth / CI, когда нужно
```

В Tip после `. $PROFILE` должны быть все имена, включая `github-commit`. Если нет — `install.ps1`, снова `. $PROFILE`. Справка: `github-help`.

macOS: те же имена команд. Если Forgejo в браузере пустой — туда ещё не было `github-push` (или push шёл только на GitHub). После успешного push страница `:3000` показывает те же коммиты.

### `github-commit` — одна строка и несколько строк

Только **уже в staging** (`git add` сам не делает). Не пушит, без `--no-verify`.

**Одна строка** — всегда в кавычках. Без кавычек хвост сообщения станет командами zsh/PowerShell:

```bash
github-commit "краткое why"
```

**Несколько строк нельзя вставлять в приглашение shell** (после `❯` / `PS>`). Сначала запусти `github-commit` **без аргументов**, потом вставляй текст.

Первая строка — тема, пустая строка, дальше тело.

**macOS / zsh:**

```bash
git add path/to/file
github-commit
# вставить тему, пустую строку, тело — закончить Ctrl-D
```

или heredoc (хвост не уйдёт в zsh):

```bash
github-commit <<'EOF'
Тема коммита

Первый абзац.
Второй абзац.
EOF
```

Редактор: `github-commit -e`.

**Windows:** `github-commit` без аргументов, строки сообщения, последняя строка только `.` — или `github-commit -e`.

Подробности: [`github-proxy/GIT_PS_GUIDE.md`](./github-proxy/GIT_PS_GUIDE.md) раздел **github-commit**.

### `github-gh` (заготовка)

Сейчас: статус логина, login/refresh, открыть репо, список/создание PR, последние Actions.  
Дальше: больше повседневных `gh` и CLI (релизы, issues, workflow). Канон меню — `github-proxy/github-gh.ps1` и `.sh`, описание — этот README + `GIT_PS_GUIDE.md`.

---

## Содержание


### 🍎 [macOS](./macos/)
Конфигурация для macOS с:
- **Alacritty** - GPU-ускоренный терминал
- **Zellij** - современный terminal multiplexer
- **Neovim** с Lazy.nvim + Neo-tree
- **Zsh** с Oh My Zsh

📖 **Документация**: [ZELLIJ_SETUP_MACOS.md](./macos/docs/ZELLIJ_SETUP_MACOS.md)

**Версия**: 2.2 (терминал, 2025-11-11); репо **2.4** — `github-proxy` (2026-09-18)

**Особенности**:
- Изолированный автозапуск Zellij только в Alacritty
- Готовые workspace layouts (40/60 и 50/50)
- Интерактивное меню выбора layout
- Автоматический запуск Neovim в проектах
- ✨ **NEW**: Productivity Tools - 6 скриптов + 35+ алиасов/функций
- ✨ **NEW**: Finder Integration - Quick Action для открытия Alacritty

---

### 🪟 [Windows](./windows/)
Полная конфигурация для Windows 11 + WSL Ubuntu.

📖 **Документация**: 
- [COMPLETE_SETUP_GUIDE.md](./windows/docs/COMPLETE_SETUP_GUIDE.md) - полное руководство
- [USEFUL_ALIASES.md](./windows/docs/USEFUL_ALIASES.md) - справочник команд
- [WEZTERM_SETUP.md](./windows/docs/WEZTERM_SETUP.md) - установка и настройка WezTerm
- [INSTALL_WA.md](./windows/INSTALL_WA.md) - установка команды `wa`
- [INSTALL_WW.md](./windows/INSTALL_WW.md) - установка команды `ww`

**Версия**: 2.3 (терминал, 2025-11-27); репо **2.4** — `github-proxy` (2026-09-18)

**Особенности**:
- 🚀 **Alacritty** и **WezTerm** в Windows с полной интеграцией WSL Ubuntu
- ⚡ **Быстрый запуск**: команды `wa` и `ww` из любой папки проводника
- 🎯 Zellij с Alt+стрелки навигацией
- 💻 LazyVim с полной настройкой (автозапуск `nvim .` в layouts)
- 📐 Готовые workspace layouts (40/60 и 50/50)
- 🎨 Автоматическое меню выбора layout при старте терминала
- 📦 Автоматическая установка конфигураций при первом запуске `wa`/`ww`
- 🛠️ Productivity Tools - 9 скриптов + 32+ алиасов
- 📚 Полный справочник команд и workflows
- 🎮 WezTerm с GPU-ускорением, Kitty graphics и inline-изображениями
- 🔧 Поддержка Ubuntu и Debian WSL дистрибутивов
- ✨ **NEW**: Улучшенные bat-файлы без зависимости от `wsl wslpath`

---

## 🚀 Быстрый старт

### macOS

1. **Клонируйте репозиторий**:
```bash
git clone https://github.com/mkurein/terminal-configs.git ~/terminal-configs
cd ~/terminal-configs
```

2. **Запустите установку**:
```bash
cd macos
./install.sh
```

3. **Откройте Alacritty** и наслаждайтесь! 🎉

---

### Windows + WSL

1. **Установите WSL и зависимости** (в WSL):
```bash
# Основные компоненты
sudo apt update && sudo apt install zsh neovim htop build-essential -y

# Zellij (через Cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install zellij
```

2. **Клонируйте репозиторий** (в WSL):
```bash
git clone https://github.com/mkurein/terminal-configs.git ~/terminal-configs
cd ~/terminal-configs
```

3. **Запустите установку WSL конфигов**:
```bash
cd windows
./install.sh
```

4. **Установите терминал в Windows**:

**Вариант A: Alacritty** (рекомендуется)
```powershell
# PowerShell
scoop install alacritty

# Конфигурация установится автоматически при первом запуске!
# Или скопируйте вручную:
Copy-Item windows\alacritty\*.toml $env:USERPROFILE\.config\alacritty\
```

**Вариант B: WezTerm** (GPU-ускорение, inline-изображения)
```powershell
scoop install wezterm

# Конфигурация установится автоматически при первом запуске!
# Или скопируйте вручную:
Copy-Item windows\wezterm\wezterm.lua $env:USERPROFILE\.config\wezterm\
```

5. **Установите быстрые команды** (опционально):
```powershell
# PowerShell от администратора
# Для Alacritty
Copy-Item windows\wa.bat C:\Windows\System32\

# Для WezTerm  
Copy-Item windows\ww.bat C:\Windows\System32\
```

Теперь можно запускать терминал из любой папки:
- **Alacritty**: введите `wa` в адресной строке проводника
- **WezTerm**: введите `ww` в адресной строке проводника

6. **Откройте терминал** и наслаждайтесь! 🎉

---

## 📁 Структура репозитория

```
terminal-configs/
├── README.md                              # Главный README
├── macos/                                 # Конфигурация для macOS
│   ├── README.md                          # README для macOS
│   ├── install.sh                         # Скрипт установки
│   ├── alacritty/
│   │   └── alacritty.toml                 # Конфигурация Alacritty
│   ├── zellij/
│   │   └── layouts/
│   │       ├── workspaceVPNmanage.kdl     # Layout 40/60
│   │       └── workspaceVPNmanage-5050.kdl # Layout 50/50
│   ├── scripts/
│   │   ├── alacritty-start.sh             # Wrapper для автозапуска
│   │   ├── start-zellij-choose.sh         # Меню выбора layout
│   │   ├── start-vpn-manage.sh            # Прямой запуск 40/60
│   │   ├── start-vpn-manage-5050.sh       # Прямой запуск 50/50
│   │   ├── open-alacritty-here.sh         # Открыть Alacritty в папке Finder
│   │   ├── open-alacritty-here-simple.sh  # Упрощенная версия
│   │   └── install-finder-service.sh      # Установка Quick Action
│   ├── zsh/
│   │   └── aliases.zsh                    # Алиасы (n=nvim)
│   └── docs/
│       └── ZELLIJ_SETUP_MACOS.md          # Полная документация
└── windows/                               # Конфигурация для Windows + WSL
    ├── README.md                          # README для Windows
    ├── install.sh                         # Скрипт установки (WSL)
    ├── alacritty/
    │   ├── alacritty.toml                 # Основная конфигурация Alacritty
    │   ├── alacritty-ubuntu.toml          # Конфигурация для WSL Ubuntu
    │   └── alacritty-debian.toml          # Конфигурация для WSL Debian
    ├── wezterm/
    │   └── wezterm.lua                    # Конфигурация WezTerm (GPU + Kitty)
    ├── zellij/
    │   ├── config.kdl                     # Конфигурация Zellij (WSL)
    │   └── layouts/
    │       ├── workspacePrjSnabjenie.kdl  # Layout 40/60
    │       └── my-workspace.kdl           # Layout 50/50
    ├── scripts/
    │   ├── start-zellij-choose.sh         # Меню выбора layout
    │   ├── start-prj-snabjenie.sh         # Прямой запуск 40/60
    │   └── start-simple.sh                # Прямой запуск 50/50
    ├── zsh/
    │   └── aliases.zsh                    # Алиасы (n=nvim)
    ├── powershell/
    │   ├── Microsoft.PowerShell_profile.ps1  # Профиль PowerShell
    │   └── install.ps1                    # Установка профиля PowerShell
    ├── wa.bat                             # 🚀 Alacritty из текущей папки
    ├── wa-ubuntu.bat                      # 🚀 Alacritty + WSL Ubuntu
    ├── wa-debian.bat                      # 🚀 Alacritty + WSL Debian
    ├── ww.bat                             # 🚀 WezTerm из текущей папки
    ├── alacritty-desktop.bat              # Запуск Alacritty с рабочего стола
    ├── wezterm-desktop.bat                # Запуск WezTerm с рабочего стола
    ├── alacritty-here.reg                 # Добавление Alacritty в контекстное меню
    ├── wezterm-here.reg                   # Добавление WezTerm в контекстное меню
    ├── INSTALL_WA.md                      # Установка команды wa
    ├── INSTALL_WW.md                      # Установка команды ww
    └── docs/
        ├── COMPLETE_SETUP_GUIDE.md        # Полное руководство (1281 строка)
        ├── LAZYVIM_SETUP.md               # Руководство по LazyVim
        ├── PRODUCTIVITY_TOOLS.md          # Инструменты продуктивности
        ├── WEZTERM_SETUP.md               # Руководство по WezTerm
        ├── WSL_FILE_OPERATIONS.md         # Работа с файлами WSL ↔ Windows
        └── USEFUL_ALIASES.md              # Справочник команд и алиасов (32+)
```

---

## 🔧 Требования

### macOS
- macOS 10.15+
- Homebrew
- Alacritty
- Zellij (через Cargo или Homebrew)
- Neovim 0.9+
- Zsh + Oh My Zsh
- htop

### Windows + WSL
- Windows 11 (или Windows 10 с WSL2)
- WSL2 с Ubuntu (или Debian)
- **Alacritty** или **WezTerm** (для Windows)
- Zellij (через Cargo в WSL)
- Neovim 0.9+ (в WSL)
- Zsh (в WSL)
- Rust + Cargo (для Zellij)
- htop (в WSL)
- PowerShell 7+ (для скриптов)

---

## 🔧 Настройка под себя

### 🪟 Windows + WSL

#### Добавить свои алиасы

Алиасы находятся в файле `~/.config/zsh/aliases.zsh` в WSL (или `windows/zsh/aliases.zsh` в репозитории).

**Добавление нового алиаса:**

1. Откройте файл в WSL:
```bash
# В WSL
nvim ~/.config/zsh/aliases.zsh
# или
n ~/.config/zsh/aliases.zsh
```

2. Добавьте алиас в нужную секцию:
```bash
# Git shortcuts
alias g='git'
alias gs='git status'
alias gb='git branch'              # ваш новый алиас
alias gba='git branch -a'          # ещё один
# ... и т.д.
```

3. Сохраните файл и перезагрузите конфигурацию:
```bash
source ~/.zshrc
```

4. Или откройте новое окно Alacritty - алиасы загрузятся автоматически.

**Примеры полезных алиасов:**
```bash
# Git
alias gco='git checkout'
alias gcb='git checkout -b'
alias gst='git stash'
alias gsp='git stash pop'

# Навигация
alias ll='ls -lah'
alias la='ls -la'

# WSL специфичные
alias explorer='explorer.exe .'    # открыть текущую папку в Windows Explorer
alias code='code .'                 # открыть в VSCode
```

**Важно:** После добавления алиасов в репозиторий:
```bash
# В WSL
cd ~/terminal-configs/windows
./install.sh

# Или вручную
cp windows/zsh/aliases.zsh ~/.config/zsh/aliases.zsh
```

#### Добавить горячие клавиши в Alacritty (Windows)

Горячие клавиши настраиваются в `%APPDATA%\alacritty\alacritty.toml` (Windows) или `~/.config/alacritty/alacritty.toml` (WSL).

**Добавление новой горячей клавиши:**

1. Откройте конфигурацию:
```powershell
# В PowerShell
notepad $env:APPDATA\alacritty\alacritty.toml

# Или в WSL
n ~/.config/alacritty/alacritty.toml
```

2. Найдите секцию `[[keyboard.bindings]]` и добавьте новую привязку:
```toml
# Пример: Ctrl+Shift+T для нового окна
[[keyboard.bindings]]
key = "T"
mods = "Control|Shift"
action = "SpawnNewInstance"

# Пример: F12 для полноэкранного режима
[[keyboard.bindings]]
key = "F12"
action = "ToggleFullscreen"

# Пример: Alt+стрелки для Zellij (уже есть в конфиге)
[[keyboard.bindings]]
key = "Left"
mods = "Alt"
chars = "\u001b[1;3D"
```

3. Перезапустите Alacritty - изменения применятся автоматически.

**Доступные действия:**
- `SpawnNewInstance` - новое окно Alacritty
- `ToggleFullscreen` - полноэкранный режим
- `IncreaseFontSize` / `DecreaseFontSize` - размер шрифта
- `Copy` / `Paste` - копирование/вставка
- `chars = "..."` - отправить символы/escape-последовательности (для Zellij)

**Модификаторы:**
- `Control` или `Ctrl`
- `Shift`
- `Alt`
- `Command` или `Super` (на Windows обычно не используется)

**Примеры полезных привязок для Windows:**
```toml
# Увеличение/уменьшение шрифта
[[keyboard.bindings]]
key = "Plus"
mods = "Control"
action = "IncreaseFontSize"

[[keyboard.bindings]]
key = "Minus"
mods = "Control"
action = "DecreaseFontSize"

# Копирование/вставка (Windows стиль)
[[keyboard.bindings]]
key = "C"
mods = "Control|Shift"
action = "Copy"

[[keyboard.bindings]]
key = "V"
mods = "Control|Shift"
action = "Paste"
```

#### Добавить горячие клавиши в Zellij (WSL)

Горячие клавиши Zellij настраиваются в `~/.config/zellij/config.kdl` в WSL.

**Добавление новой привязки:**

1. Откройте конфигурацию в WSL:
```bash
n ~/.config/zellij/config.kdl
```

2. Найдите секцию `keybinds` и добавьте новую привязку:
```kdl
keybinds {
    shared {
        // Ваша новая привязка
        bind "Ctrl g" { SwitchToMode "Normal"; }
        bind "Ctrl h" { GoToNextTab; }
    }
}
```

3. Перезапустите Zellij или нажмите `Ctrl + p` → `r` для перезагрузки конфигурации.

**Полезные привязки для Zellij:**
```kdl
keybinds {
    shared {
        // Быстрое переключение между табами
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        
        // Создание новой панели
        bind "Ctrl n" { NewPane; }
        bind "Ctrl Shift n" { NewPane "Down"; }
        
        // Закрытие панели
        bind "Ctrl x" { ClosePane; }
        
        // Переключение между панелями (Alt+стрелки уже настроены в Alacritty)
        bind "Alt Left" { MoveFocus "Left"; }
        bind "Alt Right" { MoveFocus "Right"; }
    }
}
```

**Режимы Zellij:**
- `Normal` - обычный режим
- `Locked` - заблокированный режим
- `Resize` - режим изменения размера
- `Pane` - режим работы с панелями
- `Tab` - режим работы с табами
- `Scroll` - режим прокрутки

**Важно:** Горячие клавиши для Zellij работают через Alacritty, поэтому:
1. Сначала настройте привязку в Alacritty (`alacritty.toml`) для отправки нужных escape-последовательностей
2. Затем настройте обработку этих последовательностей в Zellij (`config.kdl`)

### 🍎 macOS

См. подробные инструкции в [macos/README.md](./macos/README.md#-настройка-под-себя):
- Добавить свои алиасы
- Добавить горячие клавиши в Alacritty
- Добавить горячие клавиши в Zellij

---

## 📝 Changelog

### v2.4 - 2026-09-18 (общий)

- 🚀 **`github-proxy/`** — общие обёртки `github-fetch` / `github-pull` / `github-commit` / `github-push` / `github-gh` без SOCKS (PowerShell и zsh), в любом `.git`
- ✅ Канон: публичный GitHub [`mkurein/terminal-configs`](https://github.com/mkurein/terminal-configs) + зеркало Forgejo SSH `:2222` (`origin` fetch с GitHub, push в оба)
- ✅ README: как прописать remotes у любого репо и **проверить, откуда pull и куда push**
- ✅ `github-fetch` идёт по каждому remote, мёртвый URL пропускает; пустой splat в PowerShell больше не схлопывается в обычный `git fetch`
- ✅ `github-commit` — только staging, без `git add` / push / `--no-verify`
- ✅ «is not recognized» — в каждом скрипте и README: `. $PROFILE`, иначе `install.ps1`, иначе прямой `.ps1`
- 🔒 Обезличены домашние пути в docs, Zellij layouts и `wezterm-desktop.bat`

### v2.3 - 2025-11-27 (Windows)
- 🚀 **Переработаны `wa.bat` и `ww.bat`** — автоустановка конфигов + поиск терминала в Scoop/PATH/стандартных путях
- ✅ Исправлена проблема с `wsl wslpath` (прокси-предупреждения, кодировка) — теперь конвертация пути на чистом CMD
- ✅ WezTerm теперь сразу запускает Zellij + LazyVim меню (как Alacritty)
- ✅ Zellij layouts используют `nvim .` напрямую (не алиас `n`)
- ✅ Убрана кириллица из bat-файлов для совместимости с разными кодировками консоли

### v2.2 - 2025-11-17 (Windows)
- 🚀 **Автоматическая установка конфигураций** при первом запуске bat-файлов
- ✅ Исправлен `ww.bat` - теперь корректно запускается в WSL с zsh
- ✅ Улучшены все bat-файлы: автоматическое создание директорий и копирование конфигов
- ✅ Обновлена конфигурация WezTerm для Ubuntu WSL (было Debian)
- ✅ Добавлены `wa-ubuntu.bat` и `wa-debian.bat` для разных дистрибутивов
- ✅ Добавлены `alacritty-desktop.bat` и `wezterm-desktop.bat`
- ✅ Улучшена структура конфигураций: `~/.config/alacritty/` и `~/.config/wezterm/`
- ✅ Расширенный поиск исполняемых файлов (PATH, Scoop, стандартные пути)
- 📚 Обновлена документация с актуальными командами и путями

### v2.1 - 2025-11-10 (Windows)
- ✅ Добавлен полный справочник команд и алиасов (USEFUL_ALIASES.md)
- ✅ Обновлена конфигурация для Ubuntu WSL (было Debian)
- ✅ Документированы все 32+ алиасов и функций
- ✅ Добавлены готовые workflows для типичных задач
- ✅ Полная интеграция Zellij + LazyVim + Productivity Tools

### v2.0 - 2025-11-09 (Windows)
- ✅ Сохранены все конфигурационные файлы с рабочей машины
- ✅ Alacritty (Windows) + Zellij (WSL) + LazyVim интеграция
- ✅ Готовые workspace layouts (40/60 и 50/50)
- ✅ Скрипт установки для WSL (install.sh)
- ✅ Alt+стрелки для навигации в Zellij
- ✅ Полная документация и примеры

### v1.0 - 2025-11-08 (Windows)
- 📚 Добавлено полное руководство по настройке (1281 строка)
- Объединены 3 источника: WSL, Alacritty, Neovim
- Готова структура для конфигурационных файлов

### v2.1 - 2025-11-08 (macOS)
- 🔧 Исправлена проблема с PATH для Zellij (установлен через Cargo)
- Добавлен `export PATH="$HOME/.cargo/bin:$PATH"` во все скрипты
- Обновлена документация

### v2.0 - 2025-11-06 (macOS)
- Изоляция автозапуска Zellij только для Alacritty
- Замена nvim-tree на Neo-tree с превью
- Упрощение layout 50/50
- Добавлена полная документация

---

## 🤝 Contributing

Это персональный репозиторий конфигураций, но вы можете использовать его как основу для своих настроек.

---

## 📄 License

MIT License - используйте как хотите!

---

**Автор**: [@your-username](https://github.com/your-username)
**Дата создания**: 2025-11-08

