alias n=nvim

# Note: Windows-specific aliases (like 'alias open=explorer.exe') are removed for macOS compatibility

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
alias gl='git log --oneline --graph --decorate -20 | cat'
alias gd='git diff'
alias gb='git branch'              # локальные ветки
alias gba='git branch -a'         # все ветки (локальные + удалённые)
alias gbv='git branch -v'         # ветки с последним коммитом

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

# macOS specific
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# ===== CUSTOM SCRIPTS =====
alias ps='~/project-switcher.sh'
alias gq='~/git-quick.sh'
alias backup='~/backup-configs.sh'
alias sync='~/sync-dotfiles.sh'
alias devenv='~/dev-env.sh'
alias clean='~/clean-system.sh'
alias here='open -na Alacritty --args --working-directory "$(pwd)"'

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
  if command -v code &> /dev/null; then
    command code "$@"
  else
    open -a "Visual Studio Code" "$@"
  fi
}

# Узнать IP адрес
myip() {
  echo "Local IP:"
  ipconfig getifaddr en0 || ipconfig getifaddr en1
  echo ""
  echo "Public IP:"
  curl -s ifconfig.me
  echo ""
}

# Извлечь любой архив
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"    ;;
      *.tar.gz)    tar xzf "$1"    ;;
      *.bz2)       bunzip2 "$1"    ;;
      *.rar)       unrar x "$1"    ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"     ;;
      *.tbz2)      tar xjf "$1"    ;;
      *.tgz)       tar xzf "$1"    ;;
      *.zip)       unzip "$1"      ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1"       ;;
      *)           echo "Don't know how to extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
