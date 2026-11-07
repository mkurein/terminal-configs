"""Изолированные тесты: реальные настройки Cursor не читаются и не изменяются."""
import contextlib
import io
import json
from pathlib import Path
import sqlite3
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import cursor_startup as fix


class StartupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.data = Path(self.temp.name) / 'Пользователь с пробелом' / 'Cursor'
        self.user = self.data / 'User'
        self.global_dir = self.user / 'globalStorage'
        self.global_dir.mkdir(parents=True)
        self.settings = self.user / 'settings.json'
        self.settings.write_text('\ufeff{"editor.fontSize":17}', encoding='utf-8')
        self.state = self.global_dir / 'storage.json'
        self.state.write_text(json.dumps({'unrelated': 42, 'windowsState': {
            'openedWindows': [1]}, 'backupWorkspaces': {'workspaces': [1]}}))
        self.staging = self.global_dir / 'storage.json.vsctmp'
        self.staging.write_bytes(self.state.read_bytes())
        self.workspace = self.data / 'Workspaces/123/workspace.json'
        self.workspace.parent.mkdir(parents=True)
        self.workspace.write_text('{"folders":[]}')
        self.unsaved = self.data / 'Backups/unsaved'
        self.unsaved.parent.mkdir()
        self.unsaved.write_text('preserve')
        self.database = self.global_dir / 'state.vscdb'
        with contextlib.closing(sqlite3.connect(self.database)) as db:
            db.execute('CREATE TABLE ItemTable (key TEXT PRIMARY KEY, value BLOB)')
            db.execute("INSERT INTO ItemTable VALUES ('unrelated','keep')")
            db.commit()

    def snapshot(self):
        return {str(p.relative_to(self.data)): p.read_bytes()
                for p in self.data.rglob('*') if p.is_file()}

    def apply(self, archive=False, running=lambda: False):
        with contextlib.redirect_stdout(io.StringIO()):
            return fix.apply(self.data, archive, running)

    def test_settings_only_preserves_workspace_and_other_settings(self):
        old_state = self.state.read_bytes()
        backup = self.apply()
        self.assertTrue(self.workspace.exists())
        self.assertEqual(self.state.read_bytes(), old_state)
        self.assertEqual(fix.read_object(self.settings)['editor.fontSize'], 17)
        self.assertEqual(fix.read_object(self.settings)['window.restoreWindows'], 'none')
        self.assertEqual(self.unsaved.read_text(), 'preserve')
        with contextlib.closing(sqlite3.connect(self.database)) as db:
            self.assertEqual(db.execute("SELECT value FROM ItemTable WHERE key='unrelated'").fetchone(), ('keep',))
            for key, value in fix.PREFERENCES.items():
                self.assertEqual(db.execute('SELECT value FROM ItemTable WHERE key=?', (key,)).fetchone(), (value,))
        with contextlib.closing(sqlite3.connect(backup / 'state.vscdb')) as db:
            self.assertEqual(db.execute('SELECT COUNT(*) FROM ItemTable').fetchone(), (1,))

    def test_archive_and_repeat_preserve_original_backup(self):
        backup = self.apply(True)
        saved = backup / 'Workspaces/123/workspace.json'
        self.assertTrue(saved.exists())
        self.assertFalse(self.workspace.exists())
        self.assertEqual(fix.read_object(self.state)['unrelated'], 42)
        self.assertEqual(fix.read_object(self.state)['windowsState']['openedWindows'], [])
        self.assertEqual(self.state.read_bytes(), self.staging.read_bytes())
        self.assertNotEqual(backup, self.apply(True))
        self.assertTrue(saved.exists())
        self.assertEqual(self.unsaved.read_text(), 'preserve')

    def test_running_cursor_refuses_without_changes(self):
        before = self.snapshot()
        with self.assertRaises(RuntimeError):
            self.apply(True, lambda: True)
        self.assertEqual(self.snapshot(), before)

    def test_cursor_starts_during_preflight(self):
        before = self.snapshot()
        answers = iter([False, True])
        with self.assertRaises(RuntimeError):
            self.apply(True, lambda: next(answers))
        self.assertEqual(self.snapshot(), before)

    def test_jsonc_refuses_without_changes(self):
        self.settings.write_text('{ // comment\n}')
        before = self.snapshot()
        with self.assertRaises(ValueError):
            self.apply(True)
        self.assertEqual(self.snapshot(), before)

    def test_process_query_error_does_not_modify_files(self):
        before = self.snapshot()
        with patch.object(fix.subprocess, 'run', side_effect=OSError('tasklist failed')):
            with self.assertRaises(OSError):
                self.apply(True, fix.windows_cursor_running)
        self.assertEqual(self.snapshot(), before)

    def test_wal_is_included_in_database_backup(self):
        with contextlib.closing(sqlite3.connect(self.database)) as db:
            db.execute('PRAGMA journal_mode=WAL')
            db.execute("INSERT INTO ItemTable VALUES ('wal-only','saved')")
            db.commit()
            backup = self.apply()
            with contextlib.closing(sqlite3.connect(backup / 'state.vscdb')) as copy:
                self.assertEqual(copy.execute("SELECT value FROM ItemTable WHERE key='wal-only'").fetchone(), ('saved',))

    def test_windows_process_csv(self):
        for output, expected in [(b'"Cursor.exe","123","Console","1","100 K"\r\n', True),
                                 (b'"CURSOR.EXE","124"\r\n', True),
                                 ('ИНФОРМАЦИЯ: Задачи отсутствуют.'.encode('cp866'), False)]:
            with self.subTest(output=output), patch.object(fix.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, output)) as run:
                self.assertEqual(fix.windows_cursor_running(), expected)
                self.assertTrue(run.call_args.kwargs['check'])
        with patch.object(fix.subprocess, 'run', side_effect=subprocess.CalledProcessError(1, 'tasklist')):
            with self.assertRaises(subprocess.CalledProcessError):
                fix.windows_cursor_running()

    def test_windows_appdata_path(self):
        with patch.dict(fix.os.environ, {'APPDATA': str(self.data.parent)}):
            self.assertEqual(fix.windows_data_path(), self.data)
        with patch.dict(fix.os.environ, {'APPDATA': ''}):
            with self.assertRaises(RuntimeError):
                fix.windows_data_path()

    def test_windows_entrypoint_dry_run(self):
        before = self.snapshot()
        with patch.object(fix.platform, 'system', return_value='Windows'), \
             patch.object(fix, 'windows_data_path', return_value=self.data), \
             patch.object(fix, 'windows_cursor_running', return_value=False), \
             patch.object(sys, 'argv', ['fix-startup-windows.py']), \
             contextlib.redirect_stdout(io.StringIO()):
            fix.main('Windows')
        self.assertEqual(self.snapshot(), before)


if __name__ == '__main__':
    unittest.main()
