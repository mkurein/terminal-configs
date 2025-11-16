#!/bin/bash

# Wrapper для запуска Zellij только из Alacritty
# Используется в ~/.config/alacritty/alacritty.toml

# Инициализируем Homebrew (для доступа к утилитам типа htop)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Добавляем cargo bin в PATH для Zellij
export PATH="$HOME/.cargo/bin:$PATH"

# Если уже в Zellij - просто запустить zsh
if [[ -n "$ZELLIJ" ]]; then
    exec zsh -l
fi

# Иначе - показать меню выбора workspace
exec ~/start-zellij-choose.sh
