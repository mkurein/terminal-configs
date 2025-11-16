# 🚀 PowerShell Aliases and Functions
# Аналоги алиасов из WSL zsh для PowerShell

# ===== QUICK ALIASES =====
Set-Alias -Name c -Value Clear-Host
Set-Alias -Name n -Value nvim
Set-Alias -Name g -Value git

# Навигация (функции, т.к. алиасы не поддерживают параметры)
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ~ { Set-Location $HOME }

# Просмотр файлов
function l { Get-ChildItem -Force | Format-Table -AutoSize }
function ll { Get-ChildItem | Format-Table -AutoSize }
function la { Get-ChildItem -Force -File | Format-Table -AutoSize }

# ===== GIT SHORTCUTS =====
function gs { git status }
function ga { git add . }
function gc { param([string]$message) git commit -m $message }
function gp { git push }
function gl { git pull }
function glog { git log --oneline --graph --decorate --all }
function gll { git log --oneline --graph --decorate -20 }
function gd { git diff }
function gco { param([string]$branch) git checkout $branch }
function gb { 
    param([switch]$a, [switch]$v)
    if ($a) { 
        git branch -a 
    } elseif ($v) {
        git branch -v
    } else { 
        git branch 
    }
}
function gba { git branch -a }
function gbv { git branch -v }

# ===== WINDOWS INTEGRATION =====
function open { param([string]$path = ".") explorer.exe $path }
function clip { $input | Set-Clipboard }
function paste { Get-Clipboard }

# ===== GIT QUICK (PowerShell Native) =====
function gq {
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$cmd = "menu",
        [Parameter(Position=1)]
        [string]$msg = ""
    )
    
    switch ($cmd.ToLower()) {
        { $_ -in "s", "status" } {
            git status
        }
        
        { $_ -in "a", "add" } {
            git add .
            Write-Host "✓ Все файлы добавлены в staging" -ForegroundColor Green
        }
        
        { $_ -in "c", "commit" } {
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "📝 Сообщение коммита"
            }
            if ($msg) {
                git commit -m $msg
            } else {
                Write-Host "✗ Сообщение коммита не может быть пустым" -ForegroundColor Red
            }
        }
        
        { $_ -in "p", "push" } {
            $branch = git branch --show-current
            Write-Host "📤 Push в $branch..." -ForegroundColor Cyan
            git push origin $branch
        }
        
        { $_ -in "l", "log" } {
            git log --oneline --graph --decorate --all -20
        }
        
        { $_ -in "ac", "quick" } {
            git add .
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "📝 Сообщение коммита"
            }
            if ($msg) {
                git commit -m $msg
                Write-Host "✓ Коммит создан: $msg" -ForegroundColor Green
            }
        }
        
        { $_ -in "acp", "full" } {
            git add .
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "📝 Сообщение коммита"
            }
            if ($msg) {
                git commit -m $msg
                $branch = git branch --show-current
                git push origin $branch
                Write-Host "✓ Изменения запушены!" -ForegroundColor Green
            } else {
                Write-Host "✗ Сообщение коммита не может быть пустым" -ForegroundColor Red
            }
        }
        
        { $_ -eq "sync" } {
            $branch = git branch --show-current
            Write-Host "🔄 Синхронизация с main/master..." -ForegroundColor Cyan
            git fetch origin
            git pull origin main 2>$null
            if ($LASTEXITCODE -ne 0) {
                git pull origin master 2>$null
            }
            Write-Host "✓ Синхронизация завершена" -ForegroundColor Green
        }
        
        { $_ -eq "undo" } {
            Write-Host "⚠️  Отменить последний коммит (сохранив изменения)" -ForegroundColor Yellow
            $confirm = Read-Host "Продолжить? [y/N]"
            if ($confirm -eq "y" -or $confirm -eq "Y") {
                git reset --soft HEAD~1
                Write-Host "✓ Коммит отменен" -ForegroundColor Green
            }
        }
        
        default {
            Write-Host "⚡ Git Quick Commands" -ForegroundColor Green
            Write-Host ""
            Write-Host "Использование: gq [команда] [сообщение]" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Команды:" -ForegroundColor Yellow
            Write-Host "  s, status     - git status"
            Write-Host "  a, add        - git add ."
            Write-Host "  c, commit     - git commit с сообщением"
            Write-Host "  p, push       - git push"
            Write-Host "  l, log        - красивый git log"
            Write-Host "  ac, quick     - add + commit"
            Write-Host "  acp, full     - add + commit + push ⭐" -ForegroundColor Green
            Write-Host "  sync          - синхронизация с main/master"
            Write-Host "  undo          - отменить последний коммит"
            Write-Host ""
            Write-Host "Примеры:" -ForegroundColor Yellow
            Write-Host "  gq s                    # статус"
            Write-Host "  gq c 'Fix bug'          # коммит"
            Write-Host "  gq acp 'Update docs'    # add + commit + push ⭐" -ForegroundColor Green
        }
    }
}

# ===== CUSTOM SCRIPTS (WSL) =====
# Эти команды работают через WSL (требуют установки скриптов в WSL)
function ps { wsl ~/project-switcher.sh }
function backup { wsl ~/backup-configs.sh }
function sync { wsl ~/sync-dotfiles.sh }
function devenv { wsl ~/dev-env.sh }
function clean { wsl ~/clean-system.sh }

# ===== FUNCTIONS =====

# Создать папку и перейти в неё
function mkcd {
    param([string]$folder)
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
    Set-Location $folder
}

# Поиск файлов по имени
function ff {
    param([string]$name)
    Get-ChildItem -Recurse -Filter "*$name*" -ErrorAction SilentlyContinue
}

# Поиск в содержимом файлов
function search {
    param([string]$text)
    Select-String -Path * -Pattern $text -Recurse
}

# Размер папки
function dirsize {
    param([string]$path = ".")
    $size = (Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue | 
             Measure-Object -Property Length -Sum).Sum
    $sizeMB = [math]::Round($size / 1MB, 2)
    Write-Host "$sizeMB MB"
}

# Веб-сервер
function serve {
    param([int]$port = 8000)
    python -m http.server $port
}

# IP адрес
function myip {
    (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress
}

# Открытые порты
function ports {
    Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"} | 
    Select-Object LocalAddress, LocalPort, State | Format-Table
}

# Обновление системы (WSL)
function update {
    wsl sudo apt update && wsl sudo apt upgrade -y
}

# Установка пакетов (WSL)
function install {
    param([string]$pkg)
    wsl sudo apt install $pkg -y
}

# История команд
function h {
    Get-History | Format-Table -AutoSize
}

# Поиск процессов по имени
function psgrep {
    param([string]$name)
    Get-Process | Where-Object {$_.ProcessName -like "*$name*"} | Format-Table -AutoSize
}

# Открыть в VSCode
function code {
    param([string]$path = ".")
    if (Get-Command code -ErrorAction SilentlyContinue) {
        & code $path
    } else {
        $codePath = "${env:ProgramFiles}\Microsoft VS Code\Code.exe"
        if (Test-Path $codePath) {
            & $codePath $path
        } else {
            Write-Host "VSCode не найден. Установите VSCode или добавьте в PATH." -ForegroundColor Red
        }
    }
}

# Генератор паролей
function pwgen {
    param([int]$length = 20)
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#%^&*()_+=-{}[]:;<>,.?/"
    $password = ""
    for ($i = 0; $i -lt $length; $i++) {
        $password += $chars[(Get-Random -Maximum $chars.Length)]
    }
    return $password
}

# Извлечь архив
function extract {
    param([string]$file)
    if (-not (Test-Path $file)) {
        Write-Host "Файл не найден: $file" -ForegroundColor Red
        return
    }
    
    $extension = [System.IO.Path]::GetExtension($file).ToLower()
    $destination = [System.IO.Path]::GetDirectoryName($file)
    
    switch ($extension) {
        ".zip" {
            Expand-Archive -Path $file -DestinationPath $destination -Force
            Write-Host "✓ ZIP архив извлечен" -ForegroundColor Green
        }
        ".7z" {
            if (Get-Command 7z -ErrorAction SilentlyContinue) {
                & 7z x $file -o"$destination" -y
                Write-Host "✓ 7Z архив извлечен" -ForegroundColor Green
            } else {
                Write-Host "7z не установлен. Установите 7-Zip." -ForegroundColor Red
            }
        }
        ".rar" {
            if (Get-Command unrar -ErrorAction SilentlyContinue) {
                & unrar x $file $destination
                Write-Host "✓ RAR архив извлечен" -ForegroundColor Green
            } else {
                Write-Host "unrar не установлен. Установите WinRAR или unrar." -ForegroundColor Red
            }
        }
        ".tar" {
            if (Get-Command tar -ErrorAction SilentlyContinue) {
                & tar -xf $file -C $destination
                Write-Host "✓ TAR архив извлечен" -ForegroundColor Green
            } else {
                Write-Host "tar не найден" -ForegroundColor Red
            }
        }
        ".gz" {
            if (Get-Command tar -ErrorAction SilentlyContinue) {
                & tar -xzf $file -C $destination
                Write-Host "✓ GZ архив извлечен" -ForegroundColor Green
            } else {
                Write-Host "tar не найден" -ForegroundColor Red
            }
        }
        default {
            Write-Host "Неподдерживаемый формат архива: $extension" -ForegroundColor Red
            Write-Host "Поддерживаются: .zip, .7z, .rar, .tar, .gz" -ForegroundColor Yellow
        }
    }
}

# Размер папок (du)
function du {
    param([string]$path = ".")
    if (-not (Test-Path $path)) {
        Write-Host "Путь не найден: $path" -ForegroundColor Red
        return
    }
    
    if ((Get-Item $path).PSIsContainer) {
        $size = (Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue | 
                 Measure-Object -Property Length -Sum).Sum
        $sizeGB = [math]::Round($size / 1GB, 2)
        $sizeMB = [math]::Round($size / 1MB, 2)
        
        if ($sizeGB -ge 1) {
            Write-Host "$sizeGB GB  $path"
        } else {
            Write-Host "$sizeMB MB  $path"
        }
    } else {
        $size = (Get-Item $path).Length
        $sizeMB = [math]::Round($size / 1MB, 2)
        Write-Host "$sizeMB MB  $path"
    }
}

# ===== SYSTEM INFO =====
function df {
    Get-PSDrive -PSProvider FileSystem | 
    Select-Object Name, @{Name="Used(GB)";Expression={[math]::Round($_.Used/1GB,2)}}, 
                   @{Name="Free(GB)";Expression={[math]::Round($_.Free/1GB,2)}} | 
    Format-Table -AutoSize
}

# ===== DOCKER (если установлен) =====
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Set-Alias -Name d -Value docker
    Set-Alias -Name dc -Value docker-compose
    function dps { docker ps }
    function dpa { docker ps -a }
}

# ===== PYTHON =====
Set-Alias -Name py -Value python
Set-Alias -Name pip -Value pip

# Создание виртуального окружения
function venv {
    python -m venv venv
    .\venv\Scripts\Activate.ps1
}

# Активация виртуального окружения
function activate {
    .\venv\Scripts\Activate.ps1
}

# ===== WSL PATH CONVERSION =====
function wslpath {
    param([string]$path)
    if ($path) {
        wsl wslpath -u $path
    } else {
        wsl wslpath -u $(Get-Location)
    }
}

function winpath {
    param([string]$path)
    if ($path) {
        wsl wslpath -w $path
    } else {
        wsl wslpath -w $(wsl pwd)
    }
}

# ===== GIT QUICK COMMANDS HELP =====
function gq-help {
    gq menu
}

Write-Host "✅ PowerShell aliases loaded!" -ForegroundColor Green
Write-Host "💡 Tip: Use 'gq-help' to see Git Quick commands" -ForegroundColor Cyan

