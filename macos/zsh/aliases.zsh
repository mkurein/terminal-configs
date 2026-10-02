alias n=nvim

# Note: Windows-specific aliases (like 'alias open=explorer.exe') are removed for macOS compatibility

# Git summary in prompt (parity with windows/powershell): [main S:1 M:2 ?:3]
# Lives next to this file; install.sh copies both into ~/.config/zsh/
_tc_git_prompt=""
_tc_aliases_dir=""
if [[ -n "${(%):-%x}" ]]; then
  _tc_aliases_dir="$(cd "$(dirname "${(%):-%x}")" 2>/dev/null && pwd)"
fi
for _f in \
  "${_tc_aliases_dir:+$_tc_aliases_dir/git-prompt.zsh}" \
  "$HOME/.config/zsh/git-prompt.zsh" \
  "$HOME/Project/terminal-configs/macos/zsh/git-prompt.zsh"
do
  [ -n "$_f" ] && [ -f "$_f" ] && _tc_git_prompt="$_f" && break
done
[ -n "$_tc_git_prompt" ] && . "$_tc_git_prompt"
unset _f _tc_git_prompt _tc_aliases_dir

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
alias gau='git add -u'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20 | cat'
alias gd='git diff'
alias gb='git branch'              # локальные ветки
alias gba='git branch -a'         # все ветки (локальные + удалённые)
alias gbv='git branch -v'         # ветки с последним коммитом

# ===== GIT BRANCHES (parity with windows/powershell) =====
# Когда разработка идёт в отдельной ветке (или в worktree агента), легко забыть,
# где ты сейчас. gbr — обзор всех веток разом, остальное — переключение и уборка.
# git-плагин oh-my-zsh задаёт одноимённые алиасы (gbr, gsw, gbd, gwt, gclean);
# алиас сильнее функции, поэтому снимаем их перед определением.
for _a in gbr gsw gnb gmain gcmp gbd gclean gwt; do
  unalias "$_a" 2>/dev/null
done
unset _a

# Основная ветка репозитория: origin/HEAD, иначе main, иначе master.
function _tc_main_branch {
  local ref name
  ref=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
  if [ -n "$ref" ]; then echo "${ref#origin/}"; return; fi
  for name in main master; do
    git show-ref --verify --quiet "refs/heads/$name" && { echo "$name"; return; }
  done
}

# gbr — где я и какие ветки есть: текущая, счётчики, отставание/опережение от main,
# в какой папке (worktree) ветка открыта.
function gbr {
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Не git-репозиторий"; return 1; }
  local main cur here nlocal nremote width
  main=$(_tc_main_branch)
  cur=$(git branch --show-current 2>/dev/null)
  [ -n "$cur" ] || cur="(detached HEAD $(git rev-parse --short HEAD))"
  here=$(git rev-parse --show-toplevel)
  nlocal=$(git for-each-ref --format='x' refs/heads | wc -l | tr -d ' ')
  nremote=$(git for-each-ref --format='%(refname:short)' refs/remotes | grep '/' | grep -vc '/HEAD$')
  width=$(git for-each-ref --format='%(refname:short)' refs/heads | awk '{ if (length($0) > m) m = length($0) } END { print m + 0 }')

  local g='\033[32m' y='\033[33m' dim='\033[90m' r='\033[0m' curc
  curc=$g; [ "$cur" = "$main" ] && curc=$y
  printf "\nСейчас: ${curc}%s${r}   ${dim}(локальных: %s, удалённых: %s, основная: %s)${r}\n\n" \
    "$cur" "$nlocal" "$nremote" "$main"

  local head name age up track wt vs counts ahead behind color extra
  git for-each-ref --sort=-committerdate \
    --format='%(HEAD)|%(refname:short)|%(committerdate:relative)|%(upstream:short)|%(upstream:track,nobracket)|%(worktreepath)' \
    refs/heads |
  while IFS='|' read -r head name age up track wt; do
    vs=""
    if [ -n "$main" ] && [ "$name" != "$main" ]; then
      counts=$(git rev-list --left-right --count "$main...$name" 2>/dev/null)
      behind=${counts%%[[:space:]]*}; ahead=${counts##*[[:space:]]}
      if [ "$ahead" = "0" ]; then vs="влита в $main"; else vs="+$ahead / -$behind к $main"; fi
    fi
    color=$r
    [ "$head" = "*" ] && color=$g
    [ "$head" != "*" ] && [ "${vs#влита}" != "$vs" ] && color=$dim
    if [ -n "$up" ]; then extra="$up${track:+ $track}"; else extra="без upstream"; fi
    [ -n "$wt" ] && [ "$wt" != "$here" ] && extra="$extra | открыта в $wt"
    printf "${color}%s %-${width}s  %-22s %-18s${r}  ${dim}%s${r}\n" \
      "${head:- }" "$name" "$vs" "$age" "$extra"
  done
  echo
}

# gsw [ветка] — переключиться. Без аргумента — выбор по номеру. "gsw -" — предыдущая.
function gsw {
  if [ -n "$1" ]; then git switch "$1"; return; fi
  local list n choice picked
  list=$(git for-each-ref --sort=-committerdate --format='%(HEAD) %(refname:short)|%(committerdate:relative)' refs/heads 2>/dev/null)
  [ -n "$list" ] || { echo "Нет веток (не git-репозиторий?)"; return 1; }
  printf '%s\n' "$list" | awk -F'|' '{ printf "%3d) %s   %s\n", NR, $1, $2 }'
  n=$(printf '%s\n' "$list" | wc -l | tr -d ' ')
  printf "Номер ветки (Enter — отмена): "
  read -r choice
  [ -n "$choice" ] || return 0
  case "$choice" in *[!0-9]*) echo "Нет такого номера"; return 1 ;; esac
  if [ "$choice" -lt 1 ] || [ "$choice" -gt "$n" ]; then echo "Нет такого номера"; return 1; fi
  picked=$(printf '%s\n' "$list" | sed -n "${choice}p" | cut -d'|' -f1 | cut -c3-)
  git switch "$picked"
}

# gnb <ветка> — создать новую ветку от текущей и перейти в неё.
function gnb {
  [ -n "$1" ] || { echo "Использование: gnb <ветка>"; return 1; }
  git switch -c "$1"
}

# gmain — вернуться в основную ветку (main/master) и подтянуть её (только fast-forward).
function gmain {
  local main
  main=$(_tc_main_branch)
  [ -n "$main" ] || { echo "Не нашёл main/master"; return 1; }
  git switch "$main" || return
  git rev-parse --abbrev-ref '@{u}' >/dev/null 2>&1 && git pull --ff-only
}

# gcmp [ветка] — что в ветке есть сверх main: коммиты и затронутые файлы.
function gcmp {
  local main br
  main=$(_tc_main_branch)
  br=${1:-$(git branch --show-current)}
  if [ "$br" = "$main" ]; then echo "Вы в $main — укажите ветку: gcmp <ветка>"; return 1; fi
  echo "Коммиты в $br, которых нет в $main:"
  git --no-pager log --oneline --decorate "$main..$br"
  echo
  echo "Файлы ($main...$br):"
  git --no-pager diff --stat "$main...$br"
}

# gbd <ветка> — удалить локальную ветку, только если она уже влита (git branch -d).
function gbd {
  [ -n "$1" ] || { echo "Использование: gbd <ветка>"; return 1; }
  git branch -d "$1"
}

# gclean — удалить локальные ветки, уже влитые в main (с подтверждением).
# Ветки, открытые в других worktree, и текущую не трогает.
function gclean {
  local main merged answer head name age wt
  main=$(_tc_main_branch)
  [ -n "$main" ] || { echo "Не нашёл main/master"; return 1; }
  merged=$(git for-each-ref --format='%(HEAD)|%(refname:short)|%(committerdate:relative)|%(worktreepath)' refs/heads |
    while IFS='|' read -r head name age wt; do
      [ "$head" = "*" ] || [ -n "$wt" ] && continue
      case "$name" in "$main"|main|master) continue ;; esac
      git merge-base --is-ancestor "$name" "$main" 2>/dev/null && printf '%s|%s\n' "$name" "$age"
    done)
  [ -n "$merged" ] || { echo "Влитых веток для удаления нет"; return 0; }
  echo "Влиты в $main и будут удалены:"
  printf '%s\n' "$merged" | awk -F'|' '{ printf "  %s   %s\n", $1, $2 }'
  printf "Удалить? (y/N): "
  read -r answer
  case "$answer" in
    y|Y|д|Д) printf '%s\n' "$merged" | cut -d'|' -f1 | while read -r name; do git branch -d "$name"; done ;;
  esac
}

# gwt — список worktree: в какой папке какая ветка открыта.
function gwt { git worktree list; }

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

# ===== GITHUB WITHOUT PROXY (shared template: terminal-configs/github-proxy) =====
# See github-proxy/GIT_PS_GUIDE.md. Override: export GITHUB_PROXY_HOME=...
_github_proxy_env=""
for _f in \
  "${GITHUB_PROXY_HOME:+$GITHUB_PROXY_HOME/env.sh}" \
  "$HOME/Project/terminal-configs/github-proxy/env.sh" \
  "$HOME/terminal-configs/github-proxy/env.sh" \
  "$HOME/terminal-configs-backup/github-proxy/env.sh"
do
  [ -n "$_f" ] && [ -f "$_f" ] && _github_proxy_env="$_f" && break
done
[ -n "$_github_proxy_env" ] && . "$_github_proxy_env"
unset _f _github_proxy_env

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
