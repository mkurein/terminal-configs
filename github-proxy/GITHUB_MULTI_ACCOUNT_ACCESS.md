# GitHub: ошибка 403 при нескольких сохранённых аккаунтах

## Симптом и проверенное решение

`git push` по HTTPS возвращает `Permission ... denied` / HTTP 403, хотя нужный
аккаунт уже авторизован в GitHub CLI. В проверенном случае Git использовал активный
аккаунт без права записи. Другой сохранённый аккаунт имел право `push`.
Выбор этого аккаунта через локальный credential helper исправил отправку.
После исправления коммит успешно отправлен в GitHub и зеркало Forgejo.

Все имена аккаунтов, репозиториев и серверов ниже — placeholders.
Токены, реальные адреса и вывод личных настроек не включены.

## 1. Проверить аккаунты и адрес назначения

Выполняйте команды из нужного репозитория:

```bash
git remote -v
gh auth status
git config --show-origin --get-all credential.https://github.com.helper
```

Убедитесь, что GitHub CLI уже содержит нужный аккаунт. Если его нет,
выполните `gh auth login --hostname github.com` и авторизуйтесь самостоятельно.
Не публикуйте вывод с личными именами и не выводите токен в терминал.

Чтобы проверить права конкретного сохранённого аккаунта, замените
`ACCOUNT_WITH_ACCESS` и `OWNER/REPOSITORY`:

```bash
(
  set +x
  account_token=$(gh auth token --hostname github.com --user ACCOUNT_WITH_ACCESS) || exit 1
  [ -n "$account_token" ] || exit 1
  GH_TOKEN="$account_token" gh api repos/OWNER/REPOSITORY \
    --jq '{full_name, permissions, default_branch}'
)
```

Токен передаётся только процессу `gh`; команда не печатает его и не сохраняет в файле.
В `permissions` должно быть `push: true`. Повторите проверку для другого
сохранённого аккаунта при необходимости. Не обходите отсутствие прав: если
подходящего аккаунта нет, владелец должен предоставить доступ.

## 2. Закрепить аккаунт только за этим проектом

Следующий способ предназначен для HTTPS, GitHub CLI и оболочки macOS/Linux.
Он не меняет глобальный активный аккаунт `gh` и настройки других репозиториев.
Перед применением запомните существующие локальные helper-настройки для отката:

```bash
git config --local --get-all credential.https://github.com.helper
```

Замените `ACCOUNT_WITH_ACCESS` внутри команды. `gh` должен быть доступен в PATH
того приложения, из которого запускается Git. При необходимости укажите полный
путь к `gh` в обоих местах.

```bash
git config --local --replace-all credential.https://github.com.helper ''
git config --local --add credential.https://github.com.helper \
  '!f() { account_token=$(gh auth token --hostname github.com --user ACCOUNT_WITH_ACCESS) || return 1; [ -n "$account_token" ] || return 1; GH_TOKEN="$account_token" gh auth git-credential "$@"; }; f'
```

Пустой первый helper сбрасывает унаследованный список помощников для GitHub.
Второй получает токен выбранного аккаунта из хранилища GitHub CLI при обращении.
В `.git/config` сохраняется команда и имя аккаунта, а не токен. Этот локальный файл
не входит в коммит. Не запускайте helper с трассировкой команд (`set -x`).
Настройка относится ко всем HTTPS-адресам `github.com` в данном локальном репозитории.

Для отката удалите добавленные значения и восстановите прежние локальные значения,
если они были:

```bash
git config --local --unset-all credential.https://github.com.helper
```

## 3. Отправить и проверить оба репозитория

Посмотрите `git remote -v` и используйте фактические имена remotes и ветки.
Например, если `github` и `forgejo` настроены как отдельные назначения:

```bash
git push github main
git push forgejo main
git rev-parse HEAD
git ls-remote github refs/heads/main
git ls-remote forgejo refs/heads/main
```

Хеши ветки должны совпадать с отправленным коммитом. Не используйте force push
для исправления ошибки доступа. Если у `origin` несколько push URL, команда
`git push origin main` отправляет в эти назначения, но результаты нужно проверять
по каждому: успех одного не означает успех другого.

Изменение аккаунта для GitHub не меняет SSH-доступ к Forgejo.
