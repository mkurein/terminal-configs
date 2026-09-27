# Напоминание: команды и алиасы терминала MacBook

Источник: `terminal-configs/macos/zsh/aliases.zsh`, `tailscale.zsh`, `github-proxy/env.sh` и показанный ранее локальный `homelab-book.zsh`. Состояние на 26.09.2026. Новый Tailscale-файл пока есть в локальном коммите `0b88707`: отправка в GitHub и установка на MacBook ещё не выполнены. На MacBook старые команды `exit-home`, `exit-vps`, `exit-srv` уже определялись после восстановления `homelab-book.zsh`. Некоторые команды ниже требуют соответствующих программ и файлов.

## Сначала проверить

```zsh
type exit-srv              # есть ли команда в этой сессии
type github-push
alias                     # все активные алиасы, включая Oh My Zsh
functions | less          # функции (длинный список)
source ~/.zshrc           # заново загрузить конфигурацию
```

## Tailscale и выход в интернет

| Команда | Действие |
| --- | --- |
| `mesh-on` | Включить Tailscale (`tailscale up`). |
| `mesh-off` | Отключить Tailscale (`tailscale down`). |
| `mesh-st` | Показать состояние Tailscale. |
| `mesh-lan` | Принимать опубликованные маршруты подсетей (`--accept-routes=true`). |
| `exit-home` / `mesh-home` | Выбрать NAS `tnas` (`100.64.0.12`) как Exit Node, сохраняя доступ к локальной сети. |
| `exit-vps` / `mesh-vps` | Выбрать VPS `vps45379` (`100.64.0.13`) с доступом к локальной сети. |
| `exit-srv` / `mesh-srv` | Выбрать сервер `srv015890413` (`100.64.0.11`) с доступом к локальной сети. |
| `exit-off` / `mesh-direct` | Отключить только Exit Node; Tailscale остаётся включённым. |
| `exit-ip` | Показать текущий публичный IPv4 через api.ipify.org. |
| `hl-aliases` | Справка по этим командам. |

Пример: `exit-srv`, затем `mesh-st` и `exit-ip`. Переключение на NAS: `exit-home`. Прямой интернет: `exit-off`. Команд `ts11lan`, `ts12lan`, `ts13lan`, `tsexit` в восстановленном исходном наборе **нет**.

## Git и GitHub

| Команда | Действие |
| --- | --- |
| `g` | `git` |
| `gs` | `git status` |
| `ga` | `git add .` (текущий каталог; для всех изменений проекта используют `git add -A`) |
| `gc "сообщение"` | `git commit -m "сообщение"` |
| `gp` | `git push` обычным способом |
| `gl` | Граф последних 20 коммитов |
| `gd` | `git diff` |
| `gb` | Локальные ветки |
| `gba` | Все ветки |
| `gbv` | Локальные ветки с последними коммитами |
| `github-fetch` / `github-fetc` | Скрипт `github-fetch.sh` проекта |
| `github-pull` | Скрипт `github-pull.sh` проекта |
| `github-commit` | Скрипт `github-commit.sh` проекта |
| `github-push` | Скрипт `github-push.sh` проекта; проверьте его поведение и remotes перед запуском |
| `github-gh` | Скрипт `github-gh.sh` проекта |
| `github-help` | Справка по `github-*` |
| `gq` | В `aliases.zsh`: `~/git-quick.sh`. В старом `homelab-book.zsh`: функция `gq acp "сообщение"`. Если оба файла загружены, `type gq` покажет фактически выбранную реализацию. |
| `gq-help` | Справка старой функции из `homelab-book.zsh`, если она загружена. |

**Важно:** `gp` и `github-push` — разные команды. Функции `github-*` появляются, если `aliases.zsh` нашёл `github-proxy/env.sh` в одном из предусмотренных каталогов.

## Переходы, редактор и терминал

| Команда | Действие |
| --- | --- |
| `n` | `nvim` |
| `c` | Очистить экран |
| `..` / `...` / `....` | Подняться на 1 / 2 / 3 каталога |
| `~` | Перейти домой |
| `here` | Открыть новое окно Alacritty в текущем каталоге |
| `mkcd имя` | Создать каталог и перейти в него |
| `code путь` | Открыть VS Code (CLI или приложение) |
| `ff часть_имени` | Найти файл по части имени под текущим каталогом |
| `search текст` | Поиск текста в файлах под текущим каталогом |
| `dirsize [каталог]` | Размер каталога |
| `extract архив` | Распаковать архив подходящей программой |

## Python, Docker, процессы

| Команда | Действие |
| --- | --- |
| `py` / `pip` | `python3` / `pip3` |
| `venv` | Создать `venv` в текущем каталоге и активировать |
| `activate` | Активировать существующий `venv` |
| `serve [порт]` | Запустить `python3 -m http.server` (по умолчанию 8000) |
| `d` | `docker` |
| `dc` | `docker-compose` (нужна именно эта команда; на некоторых установках есть только `docker compose`) |
| `dps` / `dpa` | `docker ps` / `docker ps -a` |
| `psgrep имя` | Показать процессы с совпадением по имени |
| `pwgen [длина]` | Сгенерировать пароль; по умолчанию 20 символов |

## macOS, сеть и локальные скрипты

| Команда | Действие |
| --- | --- |
| `showfiles` / `hidefiles` | Показать / скрыть скрытые файлы Finder и перезапустить Finder |
| `flushdns` | Очистить DNS cache (запрашивает `sudo`) |
| `myip` | Показать локальный IP и публичный IP через ifconfig.me |
| `check-ip` | Скрипт `~/Project/homelab-book/tools/check-ip/check-ip.sh`; был в старом `homelab-book.zsh`, если файл ещё активен |
| `ps` | `~/project-switcher.sh` |
| `backup` | `~/backup-configs.sh` |
| `sync` | `~/sync-dotfiles.sh` |
| `devenv` | `~/dev-env.sh` |
| `clean` | `~/clean-system.sh` |

## Где искать определения

```text
~/.zshrc
  └─ ~/.config/zsh/aliases.zsh
       ├─ ~/.config/zsh/tailscale.zsh  (после установки нового коммита)
       └─ ~/Project/terminal-configs/github-proxy/env.sh  (если найден)

~/.oh-my-zsh/custom/homelab-book.zsh  (локальный файл, если он есть)
```

Новый `macos/install.sh` копирует `aliases.zsh` и `tailscale.zsh` в `~/.config/zsh/`, предварительно сохраняя старые копии. Уже имеющийся локальный `homelab-book.zsh` может повторно определять Tailscale-команды. Для проверки конкретной команды: `type имя` и `alias имя`. Список **всех фактически активных** алиасов на MacBook можно получить только на самом MacBook командой `alias`; системные плагины Oh My Zsh здесь не видны.

Чтобы положить эту шпаргалку на рабочий стол после скачивания, перемести файл `ALIASES_MACBOOK_CHEATSHEET_RU.md` в `~/Desktop/` через Finder либо выполни `mv ~/Downloads/ALIASES_MACBOOK_CHEATSHEET_RU.md ~/Desktop/` (если браузер сохранил файл в Downloads).
