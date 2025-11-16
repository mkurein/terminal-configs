-- WezTerm Configuration для Windows + WSL + Zellij
-- С поддержкой GPU-ускорения и Kitty graphics

local wezterm = require 'wezterm'

return {
  -- ===== WSL INTEGRATION =====
  -- Запуск Debian WSL по умолчанию
  default_prog = { "wsl.exe", "-d", "Debian", "--cd", "~" },
  
  -- Для Ubuntu используйте:
  -- default_prog = { "wsl.exe", "-d", "Ubuntu", "--cd", "~" },
  
  -- Для запуска Zellij при старте добавьте:
  -- default_prog = { "wsl.exe", "-d", "Debian", "--cd", "~", "--exec", "/usr/bin/zsh", "-l", "-c", "~/start-zellij-choose.sh" },

  -- ===== ШРИФТЫ =====
  font = wezterm.font_with_fallback({
    "Hack Nerd Font",
    "FiraCode Nerd Font",
    "JetBrainsMono Nerd Font",
    "CaskaydiaCove Nerd Font",
  }),
  font_size = 11.0,
  
  -- Лигатуры (опционально)
  harfbuzz_features = { "calt=1", "clig=1", "liga=1" },

  -- ===== ТЕМА =====
  color_scheme = "Catppuccin Mocha",
  -- Другие популярные темы:
  -- "Gruvbox Dark"
  -- "Tokyo Night"
  -- "Nord"
  -- "Dracula"
  -- "One Dark"

  -- ===== ОКНО =====
  window_background_opacity = 0.92,
  window_decorations = "RESIZE",
  enable_tab_bar = false,  -- Отключить панель вкладок (используем Zellij)
  
  window_padding = {
    left = 15,
    right = 15,
    top = 10,
    bottom = 10,
  },

  -- Стартовый режим
  initial_cols = 120,
  initial_rows = 30,

  -- ===== ПРОИЗВОДИТЕЛЬНОСТЬ =====
  -- GPU ускорение
  webgpu_power_preference = "HighPerformance",
  front_end = "WebGpu",
  
  -- Kitty graphics protocol (для inline-изображений)
  enable_kitty_graphics = true,

  -- ===== СКРОЛЛИНГ =====
  scrollback_lines = 10000,

  -- ===== ГОРЯЧИЕ КЛАВИШИ =====
  keys = {
    -- Копировать/Вставить
    { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
    
    -- Увеличение/Уменьшение шрифта
    { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
    
    -- Полноэкранный режим
    { key = 'F11', mods = '', action = wezterm.action.ToggleFullScreen },
  },

  -- ===== ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ =====
  -- Отключить подтверждение закрытия
  window_close_confirmation = 'NeverPrompt',
  
  -- Автоматическое обновление конфига при изменении
  automatically_reload_config = true,
  
  -- Курсор
  default_cursor_style = 'SteadyBlock',
  cursor_blink_rate = 500,
  
  -- Отключить звук
  audible_bell = 'Disabled',
}

