# Git / GitHub без прокси

Скрипты **не лежат в этом репо**. Общий шаблон — clone **terminal-configs**:

- Windows: `C:\Project\terminal-configs\github-proxy\`
- macOS: `~/Project/terminal-configs/github-proxy` или `~/terminal-configs/github-proxy`

Полная шпаргалка: `terminal-configs/github-proxy/GIT_PS_GUIDE.md`

После загрузки профиля, **из корня любого git-репо**:

| Операция | Команда |
|---|---|
| fetch без прокси | `github-fetch` |
| pull без прокси | `github-pull` |
| commit (только staging; много строк — без аргументов + Ctrl-D, не в zsh) | `github-commit` |
| push текущей ветки | `github-push` |
| меню `gh` | `github-gh` |

«The term 'github-…' is not recognized» — не PATH, старая сессия:

```powershell
. $PROFILE
```

Tip без команды: `cd C:\Project\terminal-configs\windows\powershell; .\install.ps1; . $PROFILE`.  
Справка: `github-help`. Напрямую: `& C:\Project\terminal-configs\github-proxy\github-commit.ps1 "msg"`.  
macOS: `source ~/.zshrc` или `source ~/Project/terminal-configs/github-proxy/env.sh`.

Без профиля:

```powershell
& C:\Project\terminal-configs\github-proxy\github-fetch.ps1
```

```bash
~/Project/terminal-configs/github-proxy/github-fetch.sh
```

Это не `gq` / `gp`: обычные git-алиасы proxy не чистят.

`github-fetch` без аргументов не роняет сессию, если один remote 404: его пропускает.

На этом Mac два GitHub-аккаунта (это **приватный** репо — не копировать таблицу в публичный terminal-configs):

| Куда | Как ходить | Lite |
|---|---|---|
| `kureinmaxim` | HTTPS (`gh` active) | remote `kureinmaxim` |
| `maximkurein` | SSH `git@github.com:...` | remote `maximkurein` |

Оба зеркала **private**. Публичный канон terminal-configs остаётся `mkurein` и туда эти логины не пишем.

Не копируй `github-*.ps1` сюда. Правки — только в `terminal-configs/github-proxy/`.
