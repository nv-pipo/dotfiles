-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.term = 'wezterm'

-- Visual bell
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 150,
}
config.colors = {
    visual_bell = '#FFFFFF',
}

-- Window
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.window_decorations = "RESIZE"

-- Disable the tab bar
config.enable_tab_bar = false

-- Set the default font size
config.font_size = 13.6

-- Disable the scrollbar
config.enable_scroll_bar = false

-- For example, changing the color scheme:
config.color_scheme = 'GitHub Dark'

-- Keyboard
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false
-- Keybindings
local act = wezterm.action

config.keys = {
    -- Natural text keybindings
    -- navigation
    { key = 'LeftArrow', mods = 'CMD', action = act { SendKey = { key = 'a', mods = 'CTRL' } } },
    { key = 'RightArrow', mods = 'CMD', action = act { SendKey = { key = 'e', mods = 'CTRL' } } },
    { key = 'LeftArrow', mods = 'OPT', action = act { SendKey = { key = 'b', mods = 'OPT' } } },
    { key = 'RightArrow', mods = 'OPT', action = act { SendKey = { key = 'f', mods = 'OPT' } } },

    -- delete
    { key = 'Backspace', mods = 'OPT', action = act { SendKey = { key = 'w', mods = 'CTRL' } } },
    { key = 'Backspace', mods = 'CMD', action = act { SendKey = { key = 'u', mods = 'CTRL' } } },
    { key = 'Delete', mods = 'OPT', action = act { SendKey = { key = 'd', mods = 'OPT' } } },
    { key = 'Delete', mods = 'CMD', action = act { SendKey = { key = 'k', mods = 'CTRL' } } },

    -- Fix delete next character (delete key, in macOS): use CTRL + d
    { key = 'Delete', action = act { SendKey = { key = 'd', mods = 'CTRL' } } },

    -- reset screen 
    { key = 'r', mods = 'CMD', action = wezterm.action.ResetTerminal },

    -- Keybinding disables
    { key = 't', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = 'w', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '1', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '2', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '3', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '4', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '5', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '6', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '7', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '8', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
    { key = '9', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
}

-- config.debug_key_events = true

-- and finally, return the configuration to wezterm
return config
