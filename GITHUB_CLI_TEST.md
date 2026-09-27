# GitHub Actions CI + GitHub CLI — практическое руководство

Этот документ объясняет, **что мы делаем**, когда «гоняем тесты и проверки на GitHub», **зачем** это нужно, и **как с этим работать** из терминала через утилиту `gh`.

Это не справочник — это введение для разработчика, который недавно вернулся к CI-теме или собирается передавать проект коллеге.

---

## 1. Что такое GitHub Actions и зачем оно нам

**GitHub Actions** — встроенный в GitHub движок CI/CD (continuous integration / continuous delivery). Идея простая: при определённом событии в репозитории (push, открытие pull request, тег, расписание) GitHub запускает на своих виртуальных машинах сценарий, описанный в `.github/workflows/*.yml`. Если сценарий упал — этот коммит/PR помечается как сломанный.

### Зачем именно нам

В проекте UGCTL раньше был **только** один workflow — `release.yml`, который срабатывал на git-тег и собирал Windows-installer и macOS DMG. То есть CI запускался **уже после** релиза, не до.

Это значит, что в `main` можно было влить коммит, который:
- не проходит `cargo clippy -D warnings`;
- не проходит `cargo fmt --check`;
- ломает `cargo test` из-за регрессии;
- собирается у одного разработчика и не собирается у другого (например, новая версия `clippy` ловит больше лайнтов).

Все эти штуки реально обнаруживались **постфактум**, уже после пуша — в этом и была причина завести CI.

Поэтому в Phase 0 мы добавили **`.github/workflows/rust-ci.yml`** — workflow, который запускается **на каждом pull request** и проверяет:

1. `cargo fmt --all -- --check` — форматирование.
2. `cargo clippy --workspace --all-targets -- -D warnings` — статический анализ.
3. `cargo test --workspace` — все тесты Rust-кода.

Это «вход в `main`». Если CI красный — PR нельзя мержить (политика обсуждается, но как минимум видно красную галочку).

### Где описаны наши workflow

| Файл | Когда срабатывает | Что делает |
|---|---|---|
| `.github/workflows/rust-ci.yml` | **Пауза** (только ручной `workflow_dispatch`, jobs `if: false`) | fmt + clippy + tests на windows-latest |
| `.github/workflows/release.yml` | **Пауза** (не тег `v*`; только ручной `workflow_dispatch`, jobs `if: false`) | Собирает Windows-installer и macOS .dmg, создаёт GitHub Release |

`rust-ci.yml` запускается на runner-е **`windows-latest`** (не Ubuntu) — потому что Named Pipe (`rust_proxy/src/named_pipe.rs`) существует только в Windows, и только там его код компилируется целиком. Сама сборка крейтов кросс-платформенная: на macOS/Linux модуль подменяется no-op заглушкой — см. `rust_proxy/docx/CROSS_PLATFORM_BUILD_RU.md`.

### Сколько это стоит

GitHub Actions для публичных репозиториев — **бесплатно**, без ограничений. Для приватных есть квота (2000 минут/месяц на free plan). Минуты на windows-runner-е считаются **×2** по сравнению с Ubuntu — поэтому мы стараемся не запускать CI на каждый чих (фильтр `paths:` в workflow ограничивает запуск только релевантными изменениями).

---

## 2. Что такое GitHub CLI (`gh`)

**GitHub CLI** (бинарь `gh`) — официальный консольный клиент GitHub. Делает почти всё то же, что веб-интерфейс GitHub, но из терминала: PR, issues, runs, релизы, чтение файлов из репо и т.д.

Установлен? Проверка:

```bash
gh --version
# gh version 2.68.0 (2025-03-05)
```

Если нет — `winget install GitHub.cli` (Windows) / `brew install gh` (macOS) / см. https://cli.github.com.

### Первичная авторизация (один раз)

```bash
gh auth login
# выбрать: GitHub.com → HTTPS → Login with a web browser
# браузер откроется, скопировать одноразовый код, подтвердить
```

После этого `gh` работает без явных токенов.

### Зачем нужен — а не браузер?

Главная польза: **смотреть результаты CI и логи провалившихся прогонов прямо из терминала**, не переключаясь в браузер. Когда CI-итераций несколько подряд (как у нас в Phase 0 — F0-5/F0-6/F0-7), браузер замедляет.

Также удобно:
- запускать CI повторно (`gh run rerun`);
- скачивать артефакты;
- открыть веб-страницу нужного PR/run одной командой (`gh pr view --web`);
- создавать PR из терминала.

---

## 3. Базовые сценарии — на примере того, что мы делали в Phase 0

### 3.1. Я запушил, хочу узнать — CI зелёный или красный

```bash
gh run list --branch feature/rust-server-standalone-prep --limit 5
```

Вывод (упрощённо):
```
in_progress         Rust CI   feature/rust-server-standalone-prep   pull_request   26740321756   6m46s   ...
completed  failure  Rust CI   feature/rust-server-standalone-prep   pull_request   26739591760   3m59s   ...
completed  failure  Rust CI   feature/rust-server-standalone-prep   pull_request   26739494918   3m22s   ...
completed  success  Rust CI   ...
```

Числа `26740321756` — это run-id, понадобятся для просмотра логов.

### 3.2. CI красный — хочу логи провалившегося прогона

```bash
# Логи только провалившихся шагов конкретного run
gh run view 26739591760 --log-failed
```

Это то, как я получал текст ошибки `collapsible_match` в недавних итерациях — без открытия браузера.

Если хочется всё (включая успешные шаги), `--log` вместо `--log-failed`. Лог обычно большой — стоит грепать:

```bash
gh run view 26739591760 --log-failed | grep -i "error\|warning" | head -20
```

### 3.3. Хочу открыть страницу прогона в браузере (если лог запутанный)

```bash
gh run view 26739591760 --web
```

### 3.4. Хочу перезапустить упавший прогон (без нового коммита)

```bash
gh run rerun 26739591760            # повторить только failed jobs
gh run rerun 26739591760 --failed   # эквивалент выше, явный флаг
```

Полезно, если падение явно транзиентное (сетевой глюк при `cargo fetch`, или флакающий тест), а не из-за кода.

### 3.5. Хочу посмотреть мой PR не выходя из терминала

```bash
gh pr list --head feature/rust-server-standalone-prep
# 3   Feature/rust server standalone prep   feature/rust-server-standalone-prep   OPEN

gh pr view 3                  # описание + статус CI
gh pr view 3 --web            # открыть в браузере
gh pr checks 3                # таблица всех CI-проверок этого PR
```

### 3.6. Я только что запушил — хочу следить за прогоном в реалтайме

```bash
# Подождать завершения последнего run-а ветки и показать статус
gh run watch
```

(Запускается без аргументов — берёт самый свежий run на текущей ветке.)

---

## 4. Локальное воспроизведение CI — почему это важно

В Phase 0 у нас была ситуация: CI падает на лайнте, которого нет локально (F0-6, F0-7). Это из-за **version drift** — на CI стоял `clippy 1.96`, локально `1.94`. Лекарство — синхронизация версий:

```bash
rustup toolchain uninstall stable
rustup toolchain install stable
rustc --version  # должно совпадать с тем, что показывает CI
```

После этого `make rust-clippy` ловит ровно те же ошибки, что и CI. Это **сильно** сокращает количество итераций «починил → запушил → упало на следующем лайнте».

Полный локальный аналог нашего CI-job-а:

```bash
make rust-fmt-check     # = cargo fmt --all -- --check
make rust-clippy        # = cargo clippy --workspace --all-targets -- -D warnings
make rust-test-all      # = cargo test --workspace
```

или одной командой:

```bash
make rust-check         # fmt-check + clippy + tests
```

**Правило:** перед push — всегда `make rust-check` локально. Если зелёное локально, должно быть зелёное и на CI (если версии toolchain-а совпадают).

---

## 5. Как читать CI-фейлы — шаблон действия

1. **Увидел красный/жёлтый статус** в `gh pr view` или в браузере.
2. **Скопировал run-id** из `gh run list --branch <ветка> --limit 3`.
3. **Логи провалившихся шагов:**
   ```bash
   gh run view <run-id> --log-failed | tail -80
   ```
4. **Идентифицировал тип ошибки:**
   - `error: ...` — компиляция, clippy, fmt.
   - `test result: FAILED. ...` — упавший тест.
   - `Error: Process completed with exit code N` — общий маркер; ищи выше первое `error:` или панику.
5. **Воспроизвёл локально** соответствующей make-командой:
   - clippy: `make rust-clippy`
   - fmt: `make rust-fmt-check`
   - tests: `make rust-test-all`
6. **Если локально не воспроизводится** — проверь:
   - совпадает ли `rustc --version` с CI;
   - не Linux/macOS-only ли это поведение (на CI windows-latest);
   - не флакающий ли тест (тогда `gh run rerun <run-id> --failed`).
7. **Починил → закоммитил → push → новый прогон CI стартует автоматически.**

---

## 6. Полезные команды (cheat sheet)

```bash
# === Списки и просмотр ===
gh run list                                        # последние 20 прогонов в этом репо
gh run list --branch <branch> --limit 10           # только по ветке
gh run list --workflow=rust-ci.yml --limit 10      # только Rust CI
gh run list --status=failure --limit 10            # только провалившиеся

gh run view <run-id>                               # обзор шагов и статусов
gh run view <run-id> --log                         # ВСЕ логи (большой объём)
gh run view <run-id> --log-failed                  # только провалившиеся шаги
gh run view <run-id> --web                         # открыть в браузере

# === Управление прогонами ===
gh run rerun <run-id>                              # перезапустить failed jobs
gh run rerun <run-id> --failed                     # явно failed only
gh run cancel <run-id>                             # отменить выполняющийся
gh run watch                                       # следить за активным (по текущей ветке)

# === Pull Requests ===
gh pr list                                         # открытые PR в репо
gh pr list --head <branch>                         # PR из конкретной ветки
gh pr view <pr-number>                             # описание + статус
gh pr view <pr-number> --web                       # открыть в браузере
gh pr checks <pr-number>                           # CI-checks тaблицей
gh pr create --draft --title "..." --body "..."    # создать PR из текущей ветки

# === Артефакты (если workflow их публикует) ===
gh run download <run-id>                           # скачать все артефакты
gh run download <run-id> -n <artifact-name>        # скачать конкретный

# === API напрямую (для скриптов) ===
gh api repos/:owner/:repo/actions/runs --paginate \
   --jq '.workflow_runs[] | select(.conclusion=="failure") | .id'
```

---

## 7. Что НЕ делать

- **Не push-ить «на удачу», надеясь на CI.** Сначала `make rust-check` локально. CI-минуты на windows-runner-е — не бесплатные, а скорость итерации больно медленная (5–8 минут на прогон).
- **Не game-ить CI** (`#[allow(...)]`, `--no-verify`, `continue-on-error: true` без причины). Если хочется пропустить проверку — это либо обсуждается явно (как мы делали с `#[ignore]` для stale-тестов в F0-4), либо это плохой сигнал.
- **Не делать `gh pr merge` без зелёного CI** — даже если можно технически. Политика Rust-веток: **не мержим** до полной готовности всех трёх Rust-крейтов (см. `rust_server/CONTRIBUTING.md` и `rust_proxy/CONTRIBUTING.md`, раздел «Ветка и политика мержа»).
- **Не редактировать workflow-файлы в `main` напрямую.** `.github/workflows/*.yml` — это код, который запускается на чужой машине с правами доступа. Меняй через PR, как любой другой код.

---

## 8. Где сейчас наш CI

- **Workflow:** [.github/workflows/rust-ci.yml](.github/workflows/rust-ci.yml)
- **Runner:** `windows-latest` (см. F0-5 в плане).
- **Триггеры:** пауза с 2026-09-17. Автозапуск с push/PR/тега `v*` снят; yaml отвечает только на `workflow_dispatch`, джобы с `if: false`. Вернуть автотриггеры — раскомментировать `on:` в workflow-файлах и убрать `if: false`.
- **Текущий PR этой ветки:** `gh pr view 3` (или `gh pr view 3 --web`).
- **Последние прогоны:** `gh run list --branch feature/rust-server-standalone-prep --limit 5`.

---

## Связанные документы

- [CLAUDE.md](CLAUDE.md) — общие правила работы в репо (включая блок «Common Commands» с `make rust-check`).
- [rust_server/README.md](rust_server/README.md), [rust_debug_client/README.md](rust_debug_client/README.md) — самостоятельные README двух Rust-крейтов.

## Официальная документация

- GitHub Actions: https://docs.github.com/actions
- `gh` CLI: https://cli.github.com/manual/
- Workflow syntax: https://docs.github.com/actions/using-workflows/workflow-syntax-for-github-actions
