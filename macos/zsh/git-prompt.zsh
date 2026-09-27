# terminal-configs: Git summary in zsh prompt (parity with windows/powershell)
#
# Example:
#    ~/Project/UDP_gRPC_COM_Lite/ [main S:1 M:3 ?:2 ahead:1]
#
# Markers match PowerShell profile:
#   S: staged | M: modified | D: deleted | ?: untracked | !: conflicts
#   ahead:N / behind:N vs upstream
#
# Colors: clean=green, dirty=yellow, conflicts=red.
# Local read only — no fetch/pull/push. Disable: export TC_GIT_PROMPT=0

# Re-source refreshes functions and PROMPT (no early return).
__TC_GIT_PROMPT_LOADED=1

__tc_git_prompt() {
  [[ "${TC_GIT_PROMPT:-1}" == "0" ]] && return 0

  local saved_status=$?
  local lines header branch xy
  local -i staged=0 modified=0 deleted=0 untracked=0 conflicts=0
  local -a parts
  local color summary ahead behind

  # One local read; never refresh the index or contact remotes from the prompt.
  lines="$(git --no-optional-locks status --porcelain=v1 --branch --untracked-files=normal 2>/dev/null)" || {
    return $saved_status
  }
  [[ -z "$lines" ]] && return $saved_status

  header="${lines%%$'\n'*}"
  [[ "$header" != \#\#* ]] && return $saved_status

  branch="${header#\#\# }"
  branch="${branch%%...*}"
  branch="${branch#No commits yet on }"
  branch="${branch#Initial commit on }"
  # Drop " [ahead 1, behind 2]" tail if it somehow remains on the short name.
  branch="${branch%% \[*}"

  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#\#* ]] && continue
    [[ ${#line} -lt 2 ]] && continue
    xy="${line[1,2]}"
    if [[ "$xy" == '??' ]]; then
      ((untracked++))
      continue
    fi
    case "$xy" in
      DD|AU|UD|UA|DU|AA|UU) ((conflicts++)); continue ;;
    esac
    # Index (staged) column
    if [[ "${xy[1]}" != ' ' && "${xy[1]}" != '?' ]]; then
      ((staged++))
    fi
    # Worktree column
    if [[ "${xy[2]}" == 'D' ]]; then
      ((deleted++))
    elif [[ "${xy[2]}" != ' ' && "${xy[2]}" != '?' ]]; then
      ((modified++))
    fi
  done <<< "$lines"

  parts=("$branch")
  ((staged)) && parts+=("S:$staged")
  ((modified)) && parts+=("M:$modified")
  ((deleted)) && parts+=("D:$deleted")
  ((untracked)) && parts+=("?:$untracked")
  ((conflicts)) && parts+=("!:$conflicts")

  if [[ "$header" =~ 'ahead ([0-9]+)' ]]; then
    ahead="${match[1]}"
    parts+=("ahead:$ahead")
  fi
  if [[ "$header" =~ 'behind ([0-9]+)' ]]; then
    behind="${match[1]}"
    parts+=("behind:$behind")
  fi

  if ((conflicts)); then
    color='%F{red}'
  elif ((staged + modified + deleted + untracked)); then
    color='%F{yellow}'
  else
    color='%F{green}'
  fi

  summary="${(j: :)parts}"
  print -n "${color}[${summary}]%f "
  return $saved_status
}

__tc_venv_prompt_prefix() {
  # Cursor / activate may set VIRTUAL_ENV before or after this file loads.
  # Keep the familiar "(mac_venv) " prefix without relying on activate's PROMPT wrap.
  [[ -z "${VIRTUAL_ENV:-}" ]] && return 0
  [[ -n "${VIRTUAL_ENV_DISABLE_PROMPT:-}" ]] && return 0
  local name="${VIRTUAL_ENV:t}"
  print -n "(%F{green}${name}%f) "
}

__tc_install_git_prompt() {
  [[ "${TC_GIT_PROMPT:-1}" == "0" ]] && return 0

  # Keep apple  when that theme is active; otherwise a plain path prefix.
  if typeset -f toon >/dev/null 2>&1; then
    PROMPT='$(__tc_venv_prompt_prefix)%{$fg[magenta]%}$(toon)%{$reset_color%} %~/ $(__tc_git_prompt)%{$reset_color%}'
  else
    PROMPT='$(__tc_venv_prompt_prefix)%~ $(__tc_git_prompt)%# '
  fi
  setopt prompt_subst

  # Drop oh-my-zsh apple vcs_info hook — we replace that segment.
  if typeset -f theme_precmd >/dev/null 2>&1; then
    add-zsh-hook -d precmd theme_precmd 2>/dev/null || true
  fi

  # Avoid double "(venv)" if activate also wraps PROMPT later.
  export VIRTUAL_ENV_DISABLE_PROMPT=1
}

__tc_install_git_prompt
