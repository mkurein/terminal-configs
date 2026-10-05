# git-eol — единые окончания строк в git-репо (Windows PowerShell 5.1 / pwsh 7).
#
#   git-eol              блок в .gitattributes + renormalize индекса + освежить рабочую копию
#   git-eol --commit     то же + коммит (push не делает: дальше github-push)
#   git-eol --check      только проверить, ничего не менять (exit 1 при проблемах)
#   git-eol --scan [DIR] проверить все репо в DIR (по умолчанию C:\Project или ~\Project)
#   git-eol --force      не требовать чистого дерева (unstaged правки попадут в индекс!)
#
# Ключи можно писать и как -Commit / -Check. Без профиля:
#   & C:\Project\terminal-configs\git-eol\git-eol.ps1 --check
# В индексе всегда LF; *.bat/*.cmd/*.ps1/*.reg/*.iss — CRLF в рабочей копии.

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2

$Template = Join-Path $PSScriptRoot "gitattributes.template"
$BeginMark = "# >>> git-eol >>>"
$EndMark = "# <<< git-eol <<<"
$CommitMsg = "Normalize line endings via .gitattributes"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Show-Usage {
    Get-Content -LiteralPath $PSCommandPath -TotalCount 11 |
        Select-Object -Skip 1 |
        ForEach-Object { $_ -replace '^# ?', '' }
}

function Stop-GitEol([string]$Message) {
    Write-Host "git-eol: $Message" -ForegroundColor Red
    exit 1
}

function Enter-RepoRoot {
    $top = (git rev-parse --show-toplevel 2>$null | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or -not $top) {
        Stop-GitEol "не git-репозиторий (cwd: $(Get-Location))"
    }
    Set-Location -LiteralPath $top
}

function Read-LfLines([string]$Path) {
    $text = [System.IO.File]::ReadAllText($Path)
    $text = $text -replace "`r", ""
    if ($text.EndsWith("`n")) { $text = $text.Substring(0, $text.Length - 1) }
    if ($text -eq "") { return ,@() }
    return ,($text -split "`n")
}

function Test-GitEolBlock {
    if (-not (Test-Path -LiteralPath ".gitattributes")) { return $false }
    $lines = Read-LfLines (Join-Path (Get-Location) ".gitattributes")
    return (($lines -contains $BeginMark) -and ($lines -contains $EndMark))
}

# Returns $true if .gitattributes changed.
function Write-GitEolBlock {
    $attrPath = Join-Path (Get-Location) ".gitattributes"
    $tpl = Read-LfLines $Template
    $out = New-Object System.Collections.Generic.List[string]

    if (Test-GitEolBlock) {
        $skip = $false
        foreach ($line in (Read-LfLines $attrPath)) {
            if ($line -eq $BeginMark) { $out.AddRange([string[]]$tpl); $skip = $true; continue }
            if ($line -eq $EndMark) { $skip = $false; continue }
            if (-not $skip) { $out.Add($line) }
        }
    } else {
        $out.AddRange([string[]]$tpl)
        if (Test-Path -LiteralPath $attrPath) {
            $old = Read-LfLines $attrPath
            if ($old.Count -gt 0) {
                $out.Add("")
                $out.AddRange([string[]]$old)
            }
        }
    }

    $newText = ([string]::Join("`n", $out.ToArray())) + "`n"
    if (Test-Path -LiteralPath $attrPath) {
        $oldText = [System.IO.File]::ReadAllText($attrPath)
        if ($oldText -ceq $newText) { return $false }
    }
    [System.IO.File]::WriteAllText($attrPath, $newText, $Utf8NoBom)
    return $true
}

# Index: committed with CRLF/mixed — needs `git add --renormalize`.
# Worktree: checkout EOL differs from attributes — needs delete + checkout.
function Get-EolMismatch {
    $prevEnc = [Console]::OutputEncoding
    [Console]::OutputEncoding = $Utf8NoBom
    try {
        $raw = (git ls-files --eol -z | Out-String)
    } finally {
        [Console]::OutputEncoding = $prevEnc
    }

    $index = New-Object System.Collections.Generic.List[string]
    $worktree = New-Object System.Collections.Generic.List[string]

    foreach ($entry in ($raw -split "`0")) {
        $entry = $entry.TrimStart("`r", "`n")
        $tab = $entry.IndexOf("`t")
        if ($tab -lt 0) { continue }
        $meta = $entry.Substring(0, $tab).Trim() -split '\s+', 3
        $path = $entry.Substring($tab + 1)
        if ($meta.Count -lt 2) { continue }
        $iField = $meta[0]
        $wField = $meta[1]
        $attrs = if ($meta.Count -ge 3) { $meta[2] } else { "" }

        if ($attrs -like "*-text*") { continue }
        if ($iField -eq "i/crlf" -or $iField -eq "i/mixed") { $index.Add($path) }
        if ($attrs -notlike "*text*") { continue }

        $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
        if (-not $item -or $item.PSIsContainer) { continue }
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) { continue }

        if ($attrs -like "*eol=crlf*") {
            if ($wField -eq "w/lf" -or $wField -eq "w/mixed") { $worktree.Add($path) }
        } else {
            if ($wField -eq "w/crlf" -or $wField -eq "w/mixed") { $worktree.Add($path) }
        }
    }

    return [pscustomobject]@{ Index = $index.ToArray(); Worktree = $worktree.ToArray() }
}

function Show-Paths([string[]]$Paths) {
    $Paths | Select-Object -First 20 | ForEach-Object { Write-Host "    $_" }
    if ($Paths.Count -gt 20) { Write-Host "    …" }
}

function Assert-CleanTree {
    $dirty = (git status --porcelain --untracked-files=no -- . ':(exclude).gitattributes' | Out-String).Trim()
    if ($dirty) {
        Write-Host $dirty -ForegroundColor Yellow
        Stop-GitEol "есть незакоммиченные изменения. Сначала commit/stash (или --force: unstaged правки попадут в индекс)."
    }
}

function Update-Worktree([string[]]$Paths) {
    $list = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($list, ([string]::Join("`0", $Paths) + "`0"), $Utf8NoBom)
        foreach ($p in $Paths) {
            Remove-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue
        }
        git checkout --pathspec-from-file="$list" --pathspec-file-nul
        if ($LASTEXITCODE -ne 0) {
            Stop-GitEol "checkout не прошёл. Файлы целы в индексе, восстановить: git checkout -- ."
        }
    } finally {
        Remove-Item -LiteralPath $list -Force -ErrorAction SilentlyContinue
    }
}

function Invoke-Check([bool]$Quiet) {
    Enter-RepoRoot
    $m = Get-EolMismatch
    $hasBlock = Test-GitEolBlock
    $ok = $hasBlock -and $m.Index.Count -eq 0 -and $m.Worktree.Count -eq 0

    if ($Quiet) {
        if ($ok) { return "OK" }
        $b = if ($hasBlock) { "да" } else { "нет" }
        return "FIX   блок:$b  индекс:$($m.Index.Count)  рабочая-копия:$($m.Worktree.Count)"
    }

    Write-Host "Репо: $(Get-Location)" -ForegroundColor Cyan
    if ($hasBlock) {
        Write-Host "✓ блок git-eol в .gitattributes есть" -ForegroundColor Green
    } else {
        Write-Host "✗ блока git-eol в .gitattributes нет" -ForegroundColor Yellow
    }
    if ($m.Index.Count -eq 0) {
        Write-Host "✓ индекс: все текстовые файлы с LF" -ForegroundColor Green
    } else {
        Write-Host "✗ индекс: $($m.Index.Count) файл(ов) закоммичены с CRLF/mixed" -ForegroundColor Yellow
        Show-Paths $m.Index
    }
    if ($m.Worktree.Count -eq 0) {
        Write-Host "✓ рабочая копия совпадает с правилами" -ForegroundColor Green
    } else {
        Write-Host "✗ рабочая копия: $($m.Worktree.Count) файл(ов) с неверными окончаниями" -ForegroundColor Yellow
        Show-Paths $m.Worktree
    }
    if (-not $ok) { Write-Host "Исправить: git-eol   (или git-eol --commit)" -ForegroundColor Cyan }
    return $ok
}

function Invoke-Apply([bool]$Force, [bool]$DoCommit) {
    Enter-RepoRoot
    if (-not (Test-Path -LiteralPath $Template)) { Stop-GitEol "нет шаблона: $Template" }
    if (-not $Force) { Assert-CleanTree }

    if (Write-GitEolBlock) {
        Write-Host "✓ .gitattributes: блок git-eol записан" -ForegroundColor Green
    } else {
        Write-Host "• .gitattributes: блок уже актуален" -ForegroundColor DarkGray
    }

    git add -- .gitattributes
    if ($LASTEXITCODE -ne 0) { Stop-GitEol "git add .gitattributes не прошёл" }
    git add --renormalize -- .
    if ($LASTEXITCODE -ne 0) { Stop-GitEol "git add --renormalize не прошёл" }

    $m = Get-EolMismatch
    if ($m.Worktree.Count -gt 0) {
        Write-Host "• освежаю рабочую копию: $($m.Worktree.Count) файл(ов)" -ForegroundColor DarkGray
        Update-Worktree $m.Worktree
    }

    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ коммитить нечего: репо уже нормализовано" -ForegroundColor Green
    } else {
        Write-Host ""
        git --no-pager diff --cached --stat | Select-Object -Last 15
        if ($DoCommit) {
            git commit -m $CommitMsg
            if ($LASTEXITCODE -ne 0) { Stop-GitEol "git commit не прошёл" }
            Write-Host "✓ закоммичено. Push: github-push" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "Изменения в индексе. Дальше:" -ForegroundColor Cyan
            Write-Host "  git-eol --commit      или   github-commit `"$CommitMsg`"" -ForegroundColor White
            Write-Host "  github-push" -ForegroundColor White
        }
    }

    Write-Host ""
    [void](Invoke-Check $false)
}

function Find-Repos([string]$Dir, [int]$Depth) {
    if (Test-Path -LiteralPath (Join-Path $Dir ".git")) { return ,@($Dir) }
    if ($Depth -le 0) { return ,@() }
    $found = New-Object System.Collections.Generic.List[string]
    Get-ChildItem -LiteralPath $Dir -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne "node_modules" -and -not $_.Name.StartsWith(".") } |
        ForEach-Object { $found.AddRange([string[]](Find-Repos $_.FullName ($Depth - 1))) }
    return ,$found.ToArray()
}

function Invoke-Scan([string]$Root) {
    if (-not $Root) {
        $Root = if (Test-Path "C:\Project") { "C:\Project" } else { Join-Path $HOME "Project" }
    }
    if (-not (Test-Path -LiteralPath $Root)) { Stop-GitEol "нет каталога: $Root" }
    $Root = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\', '/')
    Write-Host "Сканирую $Root (глубина 3)…" -ForegroundColor Cyan
    foreach ($repo in (Find-Repos $Root 3)) {
        Push-Location -LiteralPath $repo
        try {
            $result = Invoke-Check $true
        } catch {
            $result = "ERR"
        } finally {
            Pop-Location
        }
        $name = $repo.Substring([Math]::Min($repo.Length, $Root.Length + 1))
        if (-not $name) { $name = "." }
        $color = if ($result -eq "OK") { "Green" } else { "Yellow" }
        Write-Host ("{0,-60} {1}" -f $name, $result) -ForegroundColor $color
    }
    Write-Host ""
    Write-Host "Исправить репо: cd <repo>; git-eol --commit; github-push" -ForegroundColor Cyan
}

$mode = "apply"
$force = $false
$doCommit = $false
$scanDir = $null

for ($i = 0; $i -lt $args.Count; $i++) {
    $a = "$($args[$i])".Trim()
    switch ($a.TrimStart('-').ToLowerInvariant()) {
        "check" { $mode = "check" }
        "commit" { $doCommit = $true }
        "force" { $force = $true }
        "scan" {
            $mode = "scan"
            if ($i + 1 -lt $args.Count -and -not "$($args[$i + 1])".StartsWith("-")) {
                $i++
                $scanDir = "$($args[$i])"
            }
        }
        { $_ -in @("h", "help", "?") } { Show-Usage; exit 0 }
        default { Show-Usage; Stop-GitEol "неизвестный аргумент: $a" }
    }
}

$startDir = Get-Location
try {
    switch ($mode) {
        "check" { if (-not (Invoke-Check $false)) { exit 1 } }
        "scan" { Invoke-Scan $scanDir }
        default { Invoke-Apply $force $doCommit }
    }
} finally {
    Set-Location -LiteralPath $startDir
}
