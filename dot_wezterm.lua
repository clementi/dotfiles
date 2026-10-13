local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 50

config.font_size = 11

config.font = wezterm.font 'IoskeleyMonoNL Nerd Font Mono'
