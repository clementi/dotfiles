local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 50

config.font_size = 10.5

config.font = wezterm.font 'IoskeleyMonoNL Nerd Font Mono'

config.hide_tab_bar_if_only_one_tab = true

return config
