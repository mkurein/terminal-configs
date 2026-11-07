#!/usr/bin/env python3
"""Cursor 3.29.9: диагностика по умолчанию; изменения только с --apply."""
import argparse
from datetime import datetime
import json
from pathlib import Path
import platform
import shutil
import sqlite3
import subprocess

PREFERENCES = {
    'cursor/userWindowRestorationPreference': 'lastUsedWindows',
    'cursor/userOpenAgentsWindowOnStartupPreference': 'false',
}


def read_object(path):
    if not path.exists():
        return {}
    result = json.loads(path.read_text(encoding='utf-8'))
    if not isinstance(result, dict):
        raise ValueError(f'Ожидался JSON-объект: {path}')
    return result


def cursor_running():
    result = subprocess.run(['ps', '-axo', 'comm='], capture_output=True,
                            text=True, check=True)
    return any(line.strip().endswith('/Contents/MacOS/Cursor')
               or line.strip() == 'Cursor' for line in result.stdout.splitlines())


def apply(data, archive=False):
    if cursor_running():
        raise RuntimeError('Полностью завершите Cursor перед изменениями.')
    user = data / 'User'
    settings = user / 'settings.json'
    state = user / 'globalStorage/storage.json'
    staging = state.with_name('storage.json.vsctmp')
    database = user / 'globalStorage/state.vscdb'
    if not database.is_file():
        raise RuntimeError('База Cursor не найдена. Проверьте путь и версию.')
    # Все проверки формата — до создания копий и изменения файлов.
    config = read_object(settings)
    storage = read_object(state) if archive else None
    if archive:
        read_object(staging)
    preset = read_object(Path(__file__).with_name('settings.json'))
    db = sqlite3.connect(database.as_uri() + '?mode=rw', uri=True)
    try:
        db.execute('SELECT key, value FROM ItemTable LIMIT 1').fetchall()
        if cursor_running():
            raise RuntimeError('Cursor запущен во время проверки. Изменения отменены.')
        backup = user / ('startup-backup-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
        backup.mkdir()
        for source in (settings, state, staging):
            if source.exists():
                shutil.copy2(source, backup / source.name)
        with sqlite3.connect(backup / 'state.vscdb') as target:
            db.backup(target)
        print(f'Резервная копия: {backup}', flush=True)
        if archive:
            workspaces = data / 'Workspaces'
            if workspaces.exists():
                workspaces.rename(backup / 'Workspaces')
            workspaces.mkdir(exist_ok=True)
            storage['windowsState'] = {
                'openedWindows': [],
                'lastActiveWindow': {'uiState': {
                    'mode': 1, 'x': 80, 'y': 80, 'width': 1280,
                    'height': 800, 'glassMode': False,
                }},
            }
            storage['backupWorkspaces'] = {
                'workspaces': [], 'folders': [], 'emptyWindows': [],
            }
            content = json.dumps(storage, indent=4, ensure_ascii=False) + '\n'
            state.write_text(content, encoding='utf-8')
            if staging.exists():
                staging.write_text(content, encoding='utf-8')
        config.update(preset)
        settings.write_text(json.dumps(config, indent=4, ensure_ascii=False) + '\n',
                            encoding='utf-8')
        with db:
            db.executemany('INSERT OR REPLACE INTO ItemTable (key,value) VALUES (?,?)',
                           PREFERENCES.items())
        assert all(read_object(settings).get(k) == v for k, v in preset.items())
        for key, value in PREFERENCES.items():
            assert db.execute('SELECT value FROM ItemTable WHERE key=?',
                              (key,)).fetchone() == (value,)
        print('Настройки проверены. Запустите Cursor и проверьте одно окно IDE.')
        return backup
    finally:
        db.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true', help='Применить настройки')
    parser.add_argument('--archive-workspaces', action='store_true',
                        help='Перенести временную сессию в резервную копию')
    args = parser.parse_args()
    if platform.system() != 'Darwin':
        parser.error('Скрипт предназначен только для macOS.')
    if args.archive_workspaces and not args.apply:
        parser.error('--archive-workspaces требует --apply')
    data = Path.home() / 'Library/Application Support/Cursor'
    print(f'Данные Cursor: {data}')
    try:
        if args.apply:
            apply(data, args.archive_workspaces)
        else:
            print('Cursor запущен:', cursor_running())
            directory = data / 'Workspaces'
            print('Временных рабочих пространств:',
                  len(list(directory.glob('*/workspace.json'))))
            print('Изменений нет. Для настройки: --apply; для старой сессии: '
                  '--apply --archive-workspaces')
    except (OSError, ValueError, sqlite3.Error, RuntimeError,
            subprocess.CalledProcessError) as error:
        parser.exit(1, f'Ошибка: {error}\nЕсли резервная копия уже создана, '
                       'её путь напечатан выше. См. раздел отката в README.\n')


if __name__ == '__main__':
    main()
