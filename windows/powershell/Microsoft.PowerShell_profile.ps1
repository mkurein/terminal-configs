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
        "s" { git status }
        "status" { git status }

        "a" {
            git add .
            Write-Host "All files staged" -ForegroundColor Green
        }
        "add" {
            git add .
            Write-Host "All files staged" -ForegroundColor Green
        }

        "c" {
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "Commit message"
            }
            if ($msg) {
                git commit -m $msg
            } else {
                Write-Host "Commit message cannot be empty" -ForegroundColor Red
            }
        }
        "commit" {
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "Commit message"
            }
            if ($msg) {
                git commit -m $msg
            } else {
                Write-Host "Commit message cannot be empty" -ForegroundColor Red
            }
        }

        "p" {
            $branch = git branch --show-current
            Write-Host "Push $branch..." -ForegroundColor Cyan
            git push origin $branch
        }
        "push" {
            $branch = git branch --show-current
            Write-Host "Push $branch..." -ForegroundColor Cyan
            git push origin $branch
        }

        "l" { git log --oneline --graph --decorate --all -20 }
        "log" { git log --oneline --graph --decorate --all -20 }

        "ac" {
            git add .
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "Commit message"
            }
            if ($msg) {
                git commit -m $msg
                Write-Host "Committed: $msg" -ForegroundColor Green
            }
        }
        "quick" {
            git add .
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "Commit message"
            }
            if ($msg) {
                git commit -m $msg
                Write-Host "Committed: $msg" -ForegroundColor Green
            }
        }

        "acp" {
            git add .
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "Commit message"
            }
            if ($msg) {
                git commit -m $msg
                $branch = git branch --show-current
                git push origin $branch
                Write-Host "Pushed" -ForegroundColor Green
            } else {
                Write-Host "Commit message cannot be empty" -ForegroundColor Red
            }
        }
        "full" {
            git add .
            if ([string]::IsNullOrWhiteSpace($msg)) {
                $msg = Read-Host "Commit message"
            }
            if ($msg) {
                git commit -m $msg
                $branch = git branch --show-current
                git push origin $branch
                Write-Host "Pushed" -ForegroundColor Green
            } else {
                Write-Host "Commit message cannot be empty" -ForegroundColor Red
            }
        }

        "sync" {
            $branch = git branch --show-current
            Write-Host "Sync with main/master..." -ForegroundColor Cyan
            git fetch origin
            git pull origin main 2>$null
            if ($LASTEXITCODE -ne 0) {
                git pull origin master 2>$null
            }
            Write-Host "Sync done" -ForegroundColor Green
        }

        "undo" {
            Write-Host "Undo last commit (keep changes)" -ForegroundColor Yellow
            $confirm = Read-Host "Continue? [y/N]"
            if ($confirm -eq "y" -or $confirm -eq "Y") {
                git reset --soft HEAD~1
                Write-Host "Commit undone" -ForegroundColor Green
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
    wsl bash -lc "sudo apt update && sudo apt upgrade -y"
}

function htop { wsl -d Debian -- htop }
function btop { wsl -d Debian -- btop }

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

# ===== GITHUB WITHOUT PROXY (shared template: terminal-configs/github-proxy) =====
# See github-proxy/GIT_PS_GUIDE.md. Works on the current directory's git repo.
function Get-GitHubProxyHome {
    if ($env:GITHUB_PROXY_HOME -and (Test-Path (Join-Path $env:GITHUB_PROXY_HOME "github-fetch.ps1"))) {
        return $env:GITHUB_PROXY_HOME
    }
    $candidates = @(
        "C:\Project\terminal-configs\github-proxy",
        (Join-Path $HOME "Project\terminal-configs\github-proxy"),
        (Join-Path $HOME "terminal-configs\github-proxy")
    )
    foreach ($c in $candidates) {
        if (Test-Path (Join-Path $c "github-fetch.ps1")) {
            return $c
        }
    }
    return $null
}

function Invoke-GitHubProxy {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Script,
        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]$ScriptArgs
    )
    $root = Get-GitHubProxyHome
    if (-not $root) {
        Write-Host "github-proxy template not found. Clone terminal-configs or set GITHUB_PROXY_HOME." -ForegroundColor Red
        return
    }
    $path = Join-Path $root $Script
    $pass = @($ScriptArgs | Where-Object { $null -ne $_ -and "$_".Trim() -ne "" })
    if ($pass.Count -gt 0) {
        & $path @pass
    } else {
        & $path
    }
}

function github-fetch { Invoke-GitHubProxy "github-fetch.ps1" @args }
function github-pull { Invoke-GitHubProxy "github-pull.ps1" @args }
function github-commit { Invoke-GitHubProxy "github-commit.ps1" @args }
function github-push { Invoke-GitHubProxy "github-push.ps1" @args }
function github-gh { Invoke-GitHubProxy "github-gh.ps1" @args }

# Unique prefixes: github-fetc → github-fetch (github-pu остаётся неоднозначным).
$script:GitHubProxyCommands = @(
    "github-fetch", "github-pull", "github-commit", "github-push", "github-gh", "github-help"
)

function Resolve-GitHubProxyCommandName {
    param([Parameter(Mandatory = $true)][string]$Name)
    if ($script:GitHubProxyCommands -contains $Name) { return $Name }
    $hits = @($script:GitHubProxyCommands | Where-Object { $_ -like "$Name*" })
    if ($hits.Count -eq 1) { return $hits[0] }
    return $null
}

Set-Alias -Name github-fetc -Value github-fetch

function github-help {
    Write-Host "github-* — функции профиля, не PATH. Скрипты лежат в github-proxy/." -ForegroundColor Cyan
    Write-Host "  github-fetch / github-pull / github-commit / github-push / github-gh" -ForegroundColor White
    Write-Host "  короткие префиксы: github-fetc → github-fetch (если имя однозначное)" -ForegroundColor White
    Write-Host ""
    Write-Host "«The term 'github-…' is not recognized» — сессия со старым профилем:" -ForegroundColor Yellow
    Write-Host '  . $PROFILE' -ForegroundColor White
    Write-Host "Tip без нужной команды — переустановить профиль:" -ForegroundColor Yellow
    Write-Host "  cd C:\Project\terminal-configs\windows\powershell" -ForegroundColor White
    Write-Host "  .\install.ps1" -ForegroundColor White
    Write-Host '  . $PROFILE' -ForegroundColor White
    $root = Get-GitHubProxyHome
    if (-not $root) { $root = "C:\Project\terminal-configs\github-proxy" }
    Write-Host "Напрямую из любого .git:" -ForegroundColor Yellow
    Write-Host "  & `"$root\github-commit.ps1`" `"msg`"" -ForegroundColor White
    Write-Host "  & `"$root\github-fetch.ps1`"" -ForegroundColor White
}

try {
    $ExecutionContext.InvokeCommand.CommandNotFoundAction = {
        param($CommandName, $EventArgs)
        if ($CommandName -notlike "github-*") { return }

        $resolved = $null
        if (Get-Command Resolve-GitHubProxyCommandName -ErrorAction SilentlyContinue) {
            $resolved = Resolve-GitHubProxyCommandName $CommandName
        }

        if ($resolved) {
            $cmd = Get-Command $resolved -ErrorAction SilentlyContinue
            if (-not $cmd) {
                $hintRoot = $null
                if (Get-Command Get-GitHubProxyHome -ErrorAction SilentlyContinue) {
                    $hintRoot = Get-GitHubProxyHome
                }
                if (-not $hintRoot) { $hintRoot = "C:\Project\terminal-configs\github-proxy" }
                $scriptPath = Join-Path $hintRoot "$resolved.ps1"
                if (Test-Path $scriptPath) {
                    $cmd = Get-Command $scriptPath -ErrorAction SilentlyContinue
                }
            }
            if ($cmd) {
                if ($resolved -ne $CommandName) {
                    Write-Host "→ $resolved" -ForegroundColor DarkGray
                }
                $EventArgs.Command = $cmd
                return
            }
        }

        $hits = @()
        if ($script:GitHubProxyCommands) {
            $hits = @($script:GitHubProxyCommands | Where-Object { $_ -like "$CommandName*" })
        }
        if ($hits.Count -gt 1) {
            Write-Host "Неоднозначно: $($hits -join ', '). Допишите имя, например github-pull." -ForegroundColor Yellow
            return
        }

        Write-Host ""
        Write-Host "Команда '$CommandName' не в этой сессии (не PATH)." -ForegroundColor Yellow
        Write-Host "Исправление:" -ForegroundColor Cyan
        Write-Host '  . $PROFILE' -ForegroundColor White
        Write-Host "Если Tip без этой команды:" -ForegroundColor Cyan
        Write-Host "  cd C:\Project\terminal-configs\windows\powershell; .\install.ps1; . `$PROFILE" -ForegroundColor White
        $hintRoot = $null
        if (Get-Command Get-GitHubProxyHome -ErrorAction SilentlyContinue) {
            $hintRoot = Get-GitHubProxyHome
        }
        if (-not $hintRoot) { $hintRoot = "C:\Project\terminal-configs\github-proxy" }
        Write-Host "Напрямую:" -ForegroundColor Cyan
        Write-Host "  & `"$hintRoot\github-fetch.ps1`"" -ForegroundColor White
        Write-Host "Справка: github-help" -ForegroundColor Cyan
        Write-Host ""
    }
} catch {
    # PS без CommandNotFoundAction — достаточно github-help и . $PROFILE
}

# ===== GIT QUICK COMMANDS HELP =====
function Show-GqHelp {
    gq menu
}
Set-Alias -Name gq-help -Value Show-GqHelp

# Default PowerShell prompt is only "PS C:\path>" — no git branch/status.
# Cursor/VS Code wraps Prompt at session start and keeps that snapshot;
# after `. $PROFILE` we refresh OriginalPrompt so an already-open tab picks this up.
function global:__GitBranchPrompt {
    $loc = $executionContext.SessionState.Path.CurrentLocation.Path
    $gitSummary = ''
    $savedExit = $global:LASTEXITCODE
    $savedPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'SilentlyContinue'
        if (Get-Variable PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
            $PSNativeCommandUseErrorActionPreference = $false
        }
        # One local read; never refresh the index or contact remotes from the prompt.
        $lines = @(git --no-optional-locks status --porcelain=v1 --branch --untracked-files=normal 2>$null)
        if ($LASTEXITCODE -eq 0 -and $lines.Count -gt 0) {
            $header = [string]$lines[0]
            $branch = ($header -replace '^## ', '') -replace '\.\.\..*$', ''
            $branch = $branch -replace '^(No commits yet on |Initial commit on )', ''
            $staged = 0; $modified = 0; $deleted = 0; $untracked = 0; $conflicts = 0
            foreach ($line in $lines) {
                if ($line.Length -lt 2 -or $line.StartsWith('##')) { continue }
                $xy = $line.Substring(0, 2)
                if ($xy -eq '??') { $untracked++; continue }
                if ($xy -in @('DD','AU','UD','UA','DU','AA','UU')) { $conflicts++; continue }
                if ($xy[0] -ne ' ' -and $xy[0] -ne '?') { $staged++ }
                if ($xy[1] -eq 'D') { $deleted++ }
                elseif ($xy[1] -ne ' ' -and $xy[1] -ne '?') { $modified++ }
            }
            $parts = @($branch)
            if ($staged) { $parts += "S:$staged" }
            if ($modified) { $parts += "M:$modified" }
            if ($deleted) { $parts += "D:$deleted" }
            if ($untracked) { $parts += "?:$untracked" }
            if ($conflicts) { $parts += "!:$conflicts" }
            if ($header -match 'ahead (\d+)') { $parts += "ahead:$($Matches[1])" }
            if ($header -match 'behind (\d+)') { $parts += "behind:$($Matches[1])" }
            $esc = [char]27
            $color = if ($conflicts) { '31' } elseif ($staged + $modified + $deleted + $untracked) { '33' } else { '32' }
            $gitSummary = " ${esc}[${color}m[$($parts -join ' ')]${esc}[0m"
        }
    } catch {
        # Missing Git or a non-repository directory must never break the terminal.
    } finally {
        $ErrorActionPreference = $savedPreference
        $global:LASTEXITCODE = $savedExit
    }
    "PS $loc$gitSummary> "
}

if ($Global:__VSCodeState -and $Global:__VSCodeState.ContainsKey("OriginalPrompt")) {
    $Global:__VSCodeState.OriginalPrompt = $function:__GitBranchPrompt
} else {
    function global:prompt { __GitBranchPrompt }
}

Write-Host "✅ PowerShell aliases loaded!" -ForegroundColor Green
Write-Host "💡 Tip: github-fetch / github-pull / github-commit / github-push / github-gh  |  github-help  |  gq-help" -ForegroundColor Cyan

