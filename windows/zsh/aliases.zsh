alias n=nvim
alias open=explorer.exe

# Буфер обмена (требуется win32yank)
alias clip='win32yank.exe -i'
alias paste='win32yank.exe -o'
# alias pbcopy="win32yank.exe -i"  # для совместимости с macOS

# ===== QUICK ALIASES =====
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'

# Docker shortcuts (если используете)
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpa='docker ps -a'

# Python shortcuts
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv && source venv/bin/activate'
alias activate='source venv/bin/activate'

# ===== CUSTOM SCRIPTS =====
alias ps='~/project-switcher.sh'
alias gq='~/git-quick.sh'
alias backup='~/backup-configs.sh'
alias sync='~/sync-dotfiles.sh'
alias devenv='~/dev-env.sh'
alias clean='~/clean-system.sh'

# ===== FUNCTIONS =====

# Password generator
pwgen() {
  local len=${1:-20}
  LC_ALL=C tr -dc 'A-Za-z0-9@#%^&*()_+=-{}[]:;<>,.?/' < /dev/urandom | head -c "$len" | xargs echo
}

# Быстрое создание и переход в папку
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Поиск файлов по имени
ff() {
  find . -name "*$1*"
}

# Поиск в содержимом файлов
search() {
  grep -r "$1" .
}

# Размер папки
dirsize() {
  du -sh "${1:-.}"
}

# Быстрый сервер (Python)
serve() {
  local port="${1:-8000}"
  python3 -m http.server "$port"
}

# Процессы по имени
psgrep() {
  ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# Открыть в VSCode
code() {
  /mnt/c/Users/$(whoami)/AppData/Local/Programs/Microsoft\ VS\ Code/Code.exe "$@" 2>/dev/null &
}

# WSL <-> Windows file operations
alias winopen='explorer.exe .'
alias cdwin='cd /mnt/c/Users/$(whoami)/'
pwdwin() {
  wslpath -w "$(pwd)" | clip
  echo "✓ Windows путь скопирован в буфер обмена"
}

# Преобразование путей
winpath() {
  wslpath -w "$1"
}
wslpath() {
  command wslpath "$1"
}

