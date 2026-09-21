# Шпаргалка: git / GitHub без прокси (Windows и macOS)

Общий шаблон живёт в репозитории **terminal-configs**, не в каждом проекте.

**Корень шаблона:** `terminal-configs/github-proxy/`

Нужен на машинах, где VPN, антивирус или корпоративный клиент ставит `HTTP_PROXY` / `HTTPS_PROXY` / `ALL_PROXY`, из-за чего `git` и `gh` падают:

```
fatal: unable to access 'https://github.com/...': Recv failure: Connection was reset
fatal: unable to access 'https://github.com/...': socks5: ...
error connecting to "socks5h://..."
```

Скрипты чистят proxy **только в текущей сессии** и работают с **текущим каталогом** (тот git-репо, где открыт терминал). Они не делают `cd` в папку шаблона.

Если clone лежит не там, куда смотрит профиль:

```powershell
# Windows
$env:GITHUB_PROXY_HOME = "C:\Project\terminal-configs\github-proxy"
```

```bash
# macOS / zsh
export GITHUB_PROXY_HOME="$HOME/Project/terminal-configs/github-proxy"
```

Типичные пути: `C:\Project\terminal-configs\github-proxy`, `~/Project/terminal-configs/github-proxy`, `~/terminal-configs/github-proxy`.

---

## Команды

После загрузки PowerShell-профиля / zsh aliases:

| Операция | Команда | Что внутри |
|---|---|---|
| `git fetch` каждого remote | `github-fetch` | origin / forgejo; мёртвый URL пропускает |
| `git pull` без прокси | `github-pull` | merge/rebase в текущую ветку |
| `git commit -m` | `github-commit` | только staging; `git add` отдельно; без `--no-verify` |
| `git push -u origin HEAD` без прокси | `github-push` | все push-URL `origin` |
| меню `gh` CLI без прокси | `github-gh` | auth, PR, CI runs |
| как починить «is not recognized» | `github-help` | `. $PROFILE` / install / прямой `.ps1` |

Без профиля, из любого репо:

**Windows:**

```powershell
& C:\Project\terminal-configs\github-proxy\github-fetch.ps1
```

**macOS:**

```bash
"$GITHUB_PROXY_HOME/github-fetch.sh"
# или
~/Project/terminal-configs/github-proxy/github-fetch.sh
```

`git` получает `-c http.proxy= -c https.proxy=`. `gh` смотрит на env — для меню достаточно очистки переменных.

SSH-remote (`git@github.com:...`, Forgejo по SSH) HTTP-прокси не использует. Обёртки всё равно нужны для `gh` (API GitHub — HTTPS) и если рядом есть HTTPS-remote.

---

## Как подключить шаблон

**Windows — PowerShell-профиль** (`terminal-configs/windows/powershell/Microsoft.PowerShell_profile.ps1`, ставится через `windows/powershell/install.ps1`). Функции `github-fetch` / `github-pull` / `github-commit` / `github-push` / `github-gh` ищут `github-proxy` автоматически.

Перезагрузить уже открытый терминал:

```powershell
. $PROFILE
```

Если `github-commit` (или другая `github-*`) «is not recognized» — это не PATH, сессия со старым профилем. Та же команда `. $PROFILE`. Tip без имени — `cd …\windows\powershell; .\install.ps1; . $PROFILE`. Напрямую: `& C:\Project\terminal-configs\github-proxy\github-commit.ps1 "msg"`. Справка: `github-help`.

macOS: `source ~/.zshrc` или `source ~/Project/terminal-configs/github-proxy/env.sh`.

Execution policy, если скрипты запрещены:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

**macOS — zsh aliases** (`terminal-configs/macos/zsh/aliases.zsh`, копируется в `~/.config/zsh/aliases.zsh` при `macos/install.sh`). Блок `source …/github-proxy/env.sh` поднимает те же команды.

`gh` на Mac:

```bash
brew install gh
```

---

## `github-fetch`

Подтягивает с **всех** remote (`origin`, `forgejo`, …) свежие коммиты в `origin/*` / `forgejo/*`, **не сливая** с локальными. Без аргументов — fetch **каждого** remote по очереди: мёртвый URL (`Repository not found`) пропускается с warning, остальные докачиваются. Явный remote: `github-fetch origin` (ошибка этого remote уже не глотается). Сразу печатает текущую ветку и `git status -sb` (до и после fetch).

Когда: посмотреть, что нового; перед checkout; две машины.

---

## `github-pull`

Как обычный `git pull`. Если истории разошлись, может появиться merge-commit. Строгий fast-forward:

```powershell
git -c http.proxy= -c https.proxy= pull --ff-only
```

```bash
git -c http.proxy= -c https.proxy= pull --ff-only
```

---

## `github-commit`

`git commit` для **уже проиндексированных** файлов. **Не** делает `git add`, **не** пушит, **без** `--no-verify`.

Одна строка (кавычки обязательны, иначе хвост уйдёт в shell):

```powershell
git add README.md
github-commit "Document new Windows and macOS setup."
```

Несколько строк — **не** вставлять текст в приглашение zsh/PowerShell. Сначала команда без аргументов:

**macOS / bash / zsh** — вставка, потом Ctrl-D; или heredoc:

```bash
github-commit
# одна строка темы, Ctrl-D  (пустая не нужна; абзац — по желанию)

github-commit <<'EOF'
Subject line

Body paragraph.
EOF

github-commit -e    # $EDITOR
```

**Windows** — пустой вызов, строка темы, потом строка только `.` (пустая не нужна); или `github-commit -e`.

Пустой staging — выход с подсказкой `git add first`.

---

## `github-push`

Пушит текущую ветку в `origin` с `-u`. Несколько push-URL (GitHub + Forgejo) — уйдут **все**. Имя `forgejo` при push **не** используется.

Перед запуском: `git status` и `git branch --show-current`.

`--force` в шаблоне нет. Свой force только так:

```powershell
git -c http.proxy= -c https.proxy= push --force-with-lease
```

---

## Remotes: GitHub + Forgejo

Полный рецепт (свежий clone, сброс битых URL, пример `terminal-configs`) — в корневом [`README.md`](../README.md) раздел **«Связать репо с GitHub и Forgejo»**.

Кратко: `origin` **fetch** = GitHub; у `origin` **два push** (GitHub + `ssh://git@100.64.0.12:2222/mxm/REPO.git`); опционально remote `forgejo` с тем же SSH, чтобы `github-fetch` видел NAS. Веб `:3000` в remotes не пишем.

Проверка **ничего не пушит**:

```powershell
git remote get-url origin
git remote get-url --push --all origin
git --no-pager status -sb
git --no-pager branch -vv
git rev-parse --abbrev-ref --symbolic-full-name "@{u}"
```

| Команда | Ответ, который нужен |
|---|---|
| `get-url origin` | GitHub → отсюда `github-pull` |
| `get-url --push --all origin` | GitHub **и** SSH `:2222` → сюда `github-push` |
| `status -sb` / `@{u}` | `origin/main` (не `forgejo/main`) |

Без `--all` виден только первый push-URL. Tracking на NAS верни так: `git branch --set-upstream-to=origin/main`.

---

## `github-gh`

Интерактивное меню. Пункт «открыть в браузере» — `gh repo view --web` для **текущего** remote.

```
 1) gh auth status
 2) gh auth login
 3) gh auth refresh (scope: workflow)
 4) gh auth refresh (scope: workflow + repo)
 5) gh repo view (открыть в браузере)
 6) gh pr list
 7) gh pr create
 8) gh run list (последние 5)
 9) gh run watch (последний run)
 0) выход
```

---

## Типичный сценарий

Терминал уже стоит в корне нужного репо. Сначала проверь, что команды есть в **этой** сессии:

```powershell
Get-Command github-commit -ErrorAction SilentlyContinue
# пусто → . $PROFILE
# macOS: source ~/.zshrc

github-fetch
git status
github-pull
git add …
github-commit "why"
github-push
github-gh
```

macOS — те же имена команд. Для `git log` / `git diff` глуши pager: `git --no-pager log --oneline -20` или `git log --oneline | cat`.

Это не замена `gq` (add/commit/push из профиля). `gq p` / `gp` **не** чистят proxy. Для GitHub по HTTPS с живым SOCKS — `github-push`, не `gp`.

---

## Когда обёртки не нужны

Убери proxy env навсегда.

**Windows:** «Изменение переменных среды текущего пользователя» → удалить `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY` → перезапустить Cursor.

**macOS:** `~/.zshrc` / `~/.zprofile` и VPN — убрать `export HTTP_PROXY=...`, новый терминал.

Шаблон остаётся запасным вариантом.

---

## Что НЕ делать

- Не копировать `github-*.ps1` / `github-*.sh` в каждый проект — правь только `terminal-configs/github-proxy/`.
- Не путать с `gq` / `gp` / `gl`: они без очистки proxy.
- Не пушить в `main`, не глядя на `git branch --show-current`.
- Не писать в remotes веб Forgejo `:3000`; git только SSH `:2222`.
- Не запускать `git remote set-url --add --push` повторно — появится второй одинаковый Forgejo URL.
- Не добавлять `--force` в шаблон.
- Не комбинировать с `git --no-verify`.
- На Windows для git/GitHub канон — PowerShell + `.ps1`, не Git Bash как основной git.
- Не писать сюда личные GitHub-логины, URL частных репо, токены и домашние имена проектов: `mkurein/terminal-configs` публичный.

---

## Файлы шаблона

| Файл | Роль |
|---|---|
| `github-fetch.ps1` / `.sh` | fetch |
| `github-pull.ps1` / `.sh` | pull |
| `github-commit.ps1` / `.sh` | commit (только staging) |
| `github-push.ps1` / `.sh` | push |
| `github-gh.ps1` / `.sh` | меню gh |
| `_lib.ps1` / `_lib.sh` | очистка env + проверка git-репо |
| `env.sh` | alias/function для zsh/bash (`github-help` там же) |
