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
gl              # git log (красиво)
gd              # git diff
gb              # git branch (локальные ветки)
gb -a           # git branch -a (все ветки)
glog            # git log --all --graph
```

### Git Quick (через WSL)

```powershell
gq status           # git status
gq add              # git add .
gq commit "msg"     # git commit -m "msg"
gq push             # git push
gq acp "message"    # add + commit + push (SUPER COMMAND!)
gq-help             # Показать справку
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
serve 3000          # Запустить веб-сервер на порту 3000
myip                # Показать IP адрес
ports               # Показать открытые порты
update              # Обновить систему WSL
install pkg         # Установить пакет в WSL
h                   # История команд
df                  # Место на дисках
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

## ⚠️ Важные замечания

1. **WSL команды**: Некоторые команды (`gq`, `ps`, `backup`, и т.д.) работают через WSL, поэтому требуют установленного WSL.

2. **Git Quick**: Команда `gq acp` работает через WSL и требует установленных скриптов в `~/` в WSL.

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

**Версия**: 1.0  
**Дата**: 2025-01-XX  
**Платформа**: Windows 11 + PowerShell

