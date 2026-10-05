# git-eol: окончания строк в любом репо (Windows и macOS)

Одна команда приводит репозиторий к общему правилу:

- в Git (индекс, история) все текстовые файлы хранятся с **LF**;
- в рабочей копии тоже LF, кроме Windows-only файлов (`*.bat`, `*.cmd`, `*.ps1`, `*.reg`, `*.iss`, …), которые остаются с **CRLF**;
- бинарники (`*.png`, `*.exe`, `*.mo`, `*.db`, …) не трогаются.

Результат одинаковый на Windows, macOS, Linux и в CI, независимо от `core.autocrlf` на машине. Пропадает шум `CRLF will be replaced by LF`.

## Команды

| Команда | Что делает |
|---|---|
| `git-eol --check` | только проверка, ничего не меняет; `exit 1`, если есть проблемы |
| `git-eol` | записывает блок в `.gitattributes`, выполняет `git add --renormalize`, освежает рабочую копию. Коммит не делает |
| `git-eol --commit` | то же самое + коммит `Normalize line endings via .gitattributes` |
| `git-eol --scan [DIR]` | `--check` для всех репо в `DIR` (глубина 3). По умолчанию: `~/Project`, на Windows `C:\Project` |
| `git-eol --force` | не требовать чистого дерева. Unstaged правки попадут в индекс, но не потеряются |

На Windows работает и запись `-Commit`, `-Check`.

Push скрипт не делает. После `--commit` выполните `github-push`.

## Старый проект

```bash
cd ~/Project/my-repo        # Windows: cd C:\Project\my-repo
git-eol --check             # что не так
git-eol --commit            # исправить и закоммитить
github-push
```

Все проекты сразу посмотреть:

```bash
git-eol --scan
```

```
Сканирую C:\Project (глубина 3)…
homelab-book                                                 OK
ProjectPython/VPNserverManage                                FIX   блок:нет  индекс:0  рабочая-копия:0
old-tool                                                     FIX   блок:нет  индекс:12  рабочая-копия:40
```

- `блок:нет`: в `.gitattributes` нет правил git-eol;
- `индекс:N`: N файлов закоммичены с CRLF. Исправление создаст коммит;
- `рабочая-копия:N`: файлы на диске с не теми окончаниями (локальный шум). В историю это не попадает.

## Новый проект

Сразу после `git init` (или clone пустого репо):

```bash
git init
git-eol --commit
```

Первый коммит с `.gitattributes` защитит все следующие.

## Что внутри

1. **Блок в `.gitattributes`** из [`gitattributes.template`](gitattributes.template) между маркерами `# >>> git-eol >>>` и `# <<< git-eol <<<`. Блок ставится в начало файла. Существующие правила проекта сохраняются ниже: в `.gitattributes` побеждает последняя совпавшая строка, поэтому правила проекта важнее шаблона. Повторный запуск обновляет только блок.
2. **`git add --renormalize .`** перезаписывает в индекс файлы, закоммиченные с CRLF.
3. **Освежение рабочей копии.** `git checkout -- .` пропускает файлы, у которых совпали метаданные, даже если окончания на диске не те. Поэтому скрипт удаляет только расходящиеся файлы и восстанавливает их из индекса (`git checkout --pathspec-from-file`). Перед этим он требует чистого дерева, так что ничего несохранённого не удаляется.
4. **Проверка** через `git ls-files --eol`: в индексе нет `i/crlf`/`i/mixed`, рабочая копия соответствует атрибутам.

Повторный запуск безопасен: если всё уже в порядке, коммита не будет.

## Подключение

Скрипты: `git-eol.sh` (bash 3.2+, macOS / Linux / WSL / Git Bash) и `git-eol.ps1` (Windows PowerShell 5.1 и pwsh 7). Шаблон один на оба.

- **Windows, PowerShell:** функция `git-eol` в `windows/powershell/Microsoft.PowerShell_profile.ps1`. Обновить профиль: `cd C:\Project\terminal-configs\windows\powershell; .\install.ps1; . $PROFILE`.
- **macOS, zsh:** функция `git-eol` в `macos/zsh/aliases.zsh`. Обновить: `cd ~/Project/terminal-configs/macos && ./install.sh && source ~/.zshrc`.
- **WSL, zsh:** `windows/zsh/aliases.zsh`, ищет и `/mnt/c/Project/terminal-configs`.

Если клон лежит в другом месте:

```powershell
$env:GIT_EOL_HOME = "D:\src\terminal-configs\git-eol"
```

```bash
export GIT_EOL_HOME="$HOME/src/terminal-configs/git-eol"
```

Без профиля:

```powershell
& C:\Project\terminal-configs\git-eol\git-eol.ps1 --check
```

```bash
bash ~/Project/terminal-configs/git-eol/git-eol.sh --check
```

## Подстроить под проект

Свои правила пишите **ниже** блока git-eol, не внутри него. Пример: shell-скрипт, который должен остаться CRLF:

```gitattributes
# >>> git-eol >>>
…
# <<< git-eol <<<

tools/legacy.sh text eol=crlf
vendor/** -text
```

Общий набор правил меняйте в `gitattributes.template`, потом запустите `git-eol --commit` в нужных репо.

## Ограничения

- `git-eol.ps1` с BOM (UTF-8). Без него Windows PowerShell 5.1 ломает кириллицу. Не пересохраняйте файл без BOM.
- Файл, который Git считает текстом, но он на самом деле бинарный, опишите строкой `path -text` ниже блока. Иначе renormalize испортит его.
- Коммит нормализации с большим diff лучше делать отдельно от функциональных правок. Скрипт поэтому требует чистого дерева.
- Submodules не обрабатываются. Запустите `git-eol` внутри каждого.
