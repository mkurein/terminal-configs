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
function gl { git log --oneline --graph --decorate -20 }
function gd { git diff }
function glog { git log --oneline --graph --decorate --all }

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

