# Tailscale / Headscale на macOS: подключение и автозапуск

## Проверенный случай

Графическое приложение показывало **Not Connected**, хотя VPN работал.
`tailscale status` показывал активные соединения, macOS — `Connected`,
а состояние backend было `Running` без ошибок Health.
Перезапуск графического приложения восстановил корректное отображение;
после перезапуска работа VPN была проверена, исправление окна подтверждено пользователем.
После перезагрузки проблема повторилась: VPN подключился автоматически, но окно
снова показывало отключение. Добавлен однократный перезапуск интерфейса через
пользовательский LaunchAgent. При первом запуске агент завершился с кодом `0`,
VPN остался `Connected` / `Running` без ошибок Health; пользователь подтвердил,
что окно исправилось. Повторная перезагрузка **после установки агента пока не проверена**.
Это обходное решение, а не исправление причины ошибки в Tailscale.

Все адреса и имена ниже — примеры. Вывод реального устройства и скриншоты не включены.

## Диагностика

```bash
tailscale status
scutil --nc list
tailscale status --json
```

В JSON проверьте `BackendState` (`Running`) и `Health` (отсутствие сообщений).
Полный JSON может содержать сведения о сети — не публикуйте его без обезличивания.
Если macOS и backend подтверждают подключение, но окно показывает отключение,
сначала перезапустите приложение. Не переключайте VPN вслепую: переключатель может
отключить уже работающий туннель.

Для установленной в `/Applications` standalone-версии:

```bash
# Завершить только процесс приложения, не системное сетевое расширение.
pkill -TERM -x Tailscale
open -a Tailscale
```

После этого повторите проверки состояния и посмотрите статус в окне.
Перезапуск может кратковременно прервать связь; выполняйте его с локальным доступом.
Не удаляйте VPN-профиль и не сбрасывайте авторизацию для исправления одного лишь отображения.

## Ошибка login-server

Если `tailscale up` выдаёт:

```text
can't change --login-server without --force-reauth
```

проверьте адрес настроенного сервера. При использовании Headscale явно передайте
его существующий URL. Не добавляйте `--force-reauth` без намерения пройти авторизацию заново.

```bash
# Замените пример реальным адресом своего Headscale.
tailscale up --login-server=https://headscale.example.com
```

При наличии других нестандартных настроек `up` может потребовать перечислить их.
Сохраните текущие значения; не используйте `--reset` для обхода этой проверки.
Например, только если уже используются выходной узел, маршруты и доступ к LAN:

```bash
# Замените оба примера своими значениями.
tailscale up \
  --login-server=https://headscale.example.com \
  --accept-routes \
  --exit-node=YOUR_EXISTING_EXIT_NODE \
  --exit-node-allow-lan-access
```

У `tailscale set` нет параметра `--state=running`. Эту команду использовать нельзя.
Проверяйте доступные параметры через `tailscale up --help` и `tailscale set --help`.

## Автоматическое включение

В настройках Tailscale включите запуск при входе в систему (Start on Login)
и VPN On Demand для нужных сетей Wi-Fi / Ethernet. Проверьте разрешение фонового
элемента Tailscale в настройках macOS «Основные → Объекты входа и расширения».

Для standalone-версии сохранённую настройку можно проверить:

```bash
defaults read io.tailscale.ipn.macsys TailscaleStartOnLogin
```

Значение `1` означает включённую настройку. Оно само по себе не доказывает успешный
запуск после перезагрузки: проверьте подключение после следующего входа в macOS.
В описанном случае автозапуск и VPN On Demand уже были включены; после перезагрузки
подключение подтвердилось, но статус GUI вновь оказался неверным.

Запуск **после входа пользователя** и **до входа пользователя** различаются.
GUI-версии запускаются в пользовательской сессии. Для работы до входа требуется
отдельная настройка системной службы `tailscaled`; не устанавливайте второй клиент
параллельно без плана перехода.

## Обход повторения ошибки при входе в macOS

Для standalone-версии используется [tailscale-gui-refresh.zsh](../scripts/tailscale-gui-refresh.zsh).
Скрипт ждёт 30 секунд, затем до 60 раз с интервалом 2 секунды проверяет,
что macOS показывает подключённый VPN Tailscale. Если приложение запущено,
один раз завершает его процесс и открывает снова в фоне. Он не меняет сервер,
авторизацию, выходной узел и VPN On Demand. Постоянного наблюдения и циклического
перезапуска нет: агент запускается один раз при входе, а также при первоначальной загрузке.
Если VPN не подключился за время ожидания или приложение закрыто, скрипт ничего не делает.
Сам скрипт не определяет, ошибочен ли статус окна: после каждого входа он обновляет
запущенный GUI при выполнении условий выше. Возможен кратковременный перерыв связи.

### Установка

Выполните из корня клона `terminal-configs`; для установки нужен Python 3.
Существующие файлы с этими именами не перезаписываются. Общий `macos/install.sh`
не устанавливает этот обход автоматически.

```bash
python3 - <<'PYINSTALL'
from pathlib import Path
import plistlib
import shutil

home = Path.home()
source = Path('macos/scripts/tailscale-gui-refresh.zsh')
script = home / 'Library/Application Support/TailscaleGUIRefresh/refresh.zsh'
agent = home / 'Library/LaunchAgents/local.tailscale.gui-refresh.plist'
if not source.is_file():
    raise SystemExit('Run from the terminal-configs repository root')
if script.exists() or agent.exists():
    raise SystemExit('Existing workaround found; inspect it before replacing')
script.parent.mkdir(parents=True, exist_ok=True)
agent.parent.mkdir(parents=True, exist_ok=True)
shutil.copyfile(source, script)
script.chmod(0o700)
agent.write_bytes(plistlib.dumps({
    'Label': 'local.tailscale.gui-refresh',
    'ProgramArguments': ['/bin/zsh', str(script)],
    'RunAtLoad': True,
    'ProcessType': 'Background',
}))
PYINSTALL
```

Если установка завершилась успешно, проверьте файлы и загрузите агент:

```bash
/bin/zsh -n "$HOME/Library/Application Support/TailscaleGUIRefresh/refresh.zsh"
plutil -lint "$HOME/Library/LaunchAgents/local.tailscale.gui-refresh.plist"
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/local.tailscale.gui-refresh.plist"
```

Через 30 секунд или после готовности VPN проверьте:

```bash
launchctl print "gui/$(id -u)/local.tailscale.gui-refresh"
scutil --nc list
tailscale status --json
```

`runs = 1`, `last exit code = 0` и `state = not running` нормальны для завершённого
одноразового агента. Код `0` сам по себе не доказывает перезапуск: скрипт также
завершается успешно, если условия не выполнены. Проверьте окно и состояние VPN.
Повторите проверку после следующей перезагрузки и входа в учётную запись.

### Удаление обходного решения

```bash
launchctl bootout "gui/$(id -u)/local.tailscale.gui-refresh"
rm "$HOME/Library/LaunchAgents/local.tailscale.gui-refresh.plist"
rm "$HOME/Library/Application Support/TailscaleGUIRefresh/refresh.zsh"
rmdir "$HOME/Library/Application Support/TailscaleGUIRefresh"
```

Удаление затрагивает только этот агент и скрипт. Штатные настройки Tailscale сохраняются.

## Источники

- [Аналогичный случай неверного статуса GUI](https://github.com/tailscale/tailscale/issues/21753)
- [Варианты Tailscale для macOS](https://tailscale.com/docs/concepts/macos-variants)
- [Настройка запуска при входе](https://tailscale.com/docs/features/tailscale-system-policies)
