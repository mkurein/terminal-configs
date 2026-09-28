# 🪟 PowerShell Aliases

PowerShell версия алиасов из WSL zsh для использования в Windows PowerShell.

## 📋 Установка

### Автоматическая установка

```powershell
# Проверьте путь к профилю
$PROFILE

# Если профиль не существует, создайте его
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# Скопируйте профиль
Copy-Item windows\powershell\Microsoft.PowerShell_profile.ps1 $PROFILE

# Перезагрузите профиль
. $PROFILE
```

### Ручная установка

1. Откройте PowerShell
2. Проверьте путь к профилю:
   ```powershell
   $PROFILE
   ```
3. Скопируйте содержимое `Microsoft.PowerShell_profile.ps1` в файл профиля
4. Если файл не существует, создайте его:
   ```powershell
   New-Item -ItemType File -Path $PROFILE -Force
   ```
5. Перезагрузите профиль:
   ```powershell
   . $PROFILE
   ```

Если `github-commit` (или другая `github-*`) пишет `is not recognized` — сессия старая, не PATH. Снова `. $PROFILE`. Tip без команды — `.\install.ps1`, потом `. $PROFILE`. Справка: `github-help`. Напрямую: `& C:\Project\terminal-configs\github-proxy\github-commit.ps1 "msg"`.

## 🚀 Доступные команды

### Навигация

```powershell
..              # Перейти на уровень вверх
...             # Перейти на 2 уровня вверх
....            # Перейти на 3 уровня вверх
~               # Перейти в домашнюю директорию
c               # Очистить экран
```

### Просмотр файлов

```powershell
l               # Список файлов (подробно)
ll              # Список файлов
la              # Все файлы включая скрытые
```

### Git команды

```powershell
g               # git
gs              # git status
ga              # git add .
gc "message"   # git commit -m "message"
gp              # git push
gl              # git pull
gll             # git log --oneline --graph --decorate -20
glog            # git log --all --graph --decorate
gd              # git diff
gco branch      # git checkout branch
gb              # git branch (локальные ветки)
gb -a           # git branch -a (все ветки)
gb -v           # git branch -v (с последним коммитом)
gba             # git branch -a (все ветки)
gbv             # git branch -v (с последним коммитом)
```

### Git Quick (PowerShell Native)

```powershell
gq status           # git status
gq add              # git add .
gq commit "msg"     # git commit -m "msg"
gq push             # git push
gq acp "message"    # add + commit + push (SUPER COMMAND!)
gq sync             # Синхронизация с main/master
gq undo             # Отменить последний коммит
gq-help             # Показать справку
github-fetch        # git fetch без прокси (шаблон terminal-configs/github-proxy)
github-pull
github-commit "msg" # git commit, только staging
github-help         # если команда не распознана: . $PROFILE
github-push
github-gh           # меню gh CLI без прокси
```

### Windows интеграция

```powershell
open .              # Открыть текущую папку в проводнике
open file.txt       # Открыть файл
clip                # Копировать в буфер обмена (через pipe)
paste               # Вставить из буфера обмена
```

### Productivity Tools (через WSL)

```powershell
ps                  # Project Switcher
backup              # Backup конфигов
sync                # Синхронизация с Git
devenv              # Настройка окружения
clean               # Очистка системы WSL
```

### Функции

```powershell
mkcd folder         # Создать папку и перейти в неё
ff name             # Найти файл по имени
search text         # Поиск в содержимом файлов
dirsize             # Размер текущей папки
du path             # Размер папки/файла (альтернатива dirsize)
serve 3000          # Запустить веб-сервер на порту 3000
myip                # Показать IP адрес
ports               # Показать открытые порты
update              # Обновить систему WSL
install pkg         # Установить пакет в WSL
h                   # История команд
df                  # Место на дисках
psgrep name         # Найти процессы по имени
code .              # Открыть в VSCode
extract file.zip    # Извлечь архив (.zip, .7z, .rar, .tar, .gz)
pwgen 20            # Сгенерировать пароль (20 символов)
```

### Python

```powershell
py                  # python
pip                 # pip
venv                # Создать виртуальное окружение
activate            # Активировать виртуальное окружение
```

### Docker (если установлен)

```powershell
d                   # docker
dc                  # docker-compose
dps                 # docker ps
dpa                 # docker ps -a
```

### Приглашение (состояние Git)

По умолчанию PowerShell пишет только `PS C:\path>` и **не** показывает Git. В профиле есть git-prompt: ветка плюс локальные счётчики `S:` / `M:` / `D:` / `?:` / `!:` и `ahead:` / `behind:`:

```text
PS C:\Project\my-project [main S:2 M:3 D:1 ?:4 ahead:1]>
```

Чистая ветка — зелёным, изменения — жёлтым, конфликты — красным. Новый терминал загружает профиль сам. Уже открытое окно Cursor/VS Code подхватит prompt только после `. $PROFILE` (или нового терминала).

На **macOS** те же маркеры даёт `macos/zsh/git-prompt.zsh` (через `aliases.zsh`). См. корневой [`README.md`](../../README.md).

`git pull` не копирует шаблон в `$PROFILE`. На другом ПК:

```powershell
git pull --ff-only
.\windows\powershell\install.ps1
. $PROFILE
```

`$PROFILE` у PowerShell 5.1 и 7 обычно разный. Подробности — в начале корневого [`README.md`](../../README.md) (раздел «Терминал: Git-состояние в prompt и `. $PROFILE`»).

### Автодополнение и подсказки

На macOS подсказки по веткам и файлам даёт **oh-my-zsh** — он ставится отдельно
от этого репозитория, поэтому «на Маке есть, на Windows нет». В PowerShell
аналога по умолчанию нет, и его нужно включать явно. С 2026-09-28 это делает
профиль, а модули доставляет `install.ps1`.

| Что нужно | macOS | Windows |
| --- | --- | --- |
| Tab по веткам, remote'ам и файлам git | git-плагин oh-my-zsh + `compinit` | **posh-git** |
| Подсказка из истории серым | `zsh-autosuggestions` | **PSReadLine**, `PredictionSource History` |
| Меню вариантов по Tab | меню zsh | `Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete` |

Как это работает после установки:

- `git checkout ` + **Tab** — перебор веток; повторный Tab листает меню.
- `git add ` + **Tab** — перебор изменённых файлов.
- начать команду и нажать **↑** — поиск по истории **с учётом набранного**
  префикса, а не просто предыдущая команда.
- серая подсказка справа — продолжение из истории, принимается стрелкой **→**.

Порядок в профиле важен: `Import-Module posh-git` стоит **до** секции prompt.
posh-git при импорте перехватывает `prompt` на себя, а наш
`__GitBranchPrompt` определяется ниже и возвращает приглашение с `[branch]`
обратно. Если поменять местами — пропадёт привычный вид строки.

Проверка, что всё на месте:

```powershell
Get-Module -ListAvailable posh-git, PSReadLine | Select-Object Name, Version
Get-PSReadLineOption | Select-Object PredictionSource, PredictionViewStyle
```

Если `PredictionSource` = `None` или posh-git не найден — профиль на диске
старый, нужен `install.ps1` и `. $PROFILE`.

Подсказка показывается инлайном (`InlineView`). Если хочется списком под
строкой — `Set-PSReadLineOption -PredictionViewStyle ListView`.

### Локальные переопределения: `profile.local.ps1`

Репозиторий публичный, поэтому имён узлов, подсетей и приватных путей в нём
нет. Всё, что специфично для конкретной машины, живёт в отдельном файле рядом
с профилем:

```powershell
# путь: (Split-Path $PROFILE)\profile.local.ps1
$global:MeshExitHomeNode = 'имя-домашнего-узла'
$global:MeshExitVpsNode  = 'имя-vps-узла'
$global:MeshLanLabel     = '192.168.0.0/24'
```

Профиль подхватывает этот файл в самом конце, поэтому переопределения
перекрывают значения по умолчанию. Функции `exit-home` / `exit-vps` читают
переменные в момент вызова, так что порядок загрузки роли не играет.

Главное свойство: **`install.ps1` этот файл не трогает.** Можно сколько угодно
раз обновлять профиль из репозитория, локальные настройки останутся.

Что удобно туда класть: реальные имена узлов mesh, личные алиасы, пути к
рабочим проектам, переменные окружения конкретной машины.

Настройка новой машины целиком:

```powershell
git clone https://github.com/mkurein/terminal-configs
cd terminal-configs\windows\powershell
.\install.ps1
notepad (Join-Path (Split-Path $PROFILE) 'profile.local.ps1')   # свои значения
. $PROFILE
```

Без `profile.local.ps1` всё работает, просто `exit-home` / `exit-vps` будут
ссылаться на несуществующие узлы-плейсхолдеры.

## ⚠️ Важные замечания

1. **WSL команды**: Некоторые команды (`ps`, `backup`, `sync`, `devenv`, `clean`) работают через WSL, поэтому требуют установленного WSL.

2. **Git Quick**: Команда `gq` работает нативно в PowerShell и не требует WSL. Это полнофункциональная реализация Git Quick команд.

3. **Пути**: Команды работают с Windows путями, но WSL команды автоматически конвертируют пути.

4. **Профиль**: Если профиль не загружается автоматически, проверьте политику выполнения:
   ```powershell
   Get-ExecutionPolicy
   # Если Restricted, выполните:
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## 🔧 Кастомизация

Отредактируйте файл профиля:

```powershell
notepad $PROFILE
# или
code $PROFILE
```

После изменений перезагрузите:

```powershell
. $PROFILE
```

## 📚 Связанные документы

- [USEFUL_ALIASES.md](../docs/USEFUL_ALIASES.md) - Полный справочник WSL алиасов
- [README.md](../README.md) - Общая документация Windows конфигурации

---

**Версия**: 1.1  
**Дата**: 2025-11-14  
**Платформа**: Windows 11 + PowerShell

### Что нового в v1.1:
- ✅ Добавлены все алиасы из zsh конфигурации
- ✅ Git Quick работает нативно в PowerShell (не требует WSL)
- ✅ Новые функции: `psgrep`, `code`, `extract`, `pwgen`, `du`
- ✅ Дополнительные Git алиасы: `gl` (pull), `gll` (log), `gco`, `gba`, `gbv`

