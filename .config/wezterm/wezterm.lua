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
    -- Map CMD + Left/Right to Ctrl + a/e. For navigating to the start/end of the line
    { key = 'LeftArrow', mods = 'CMD', action = act { SendKey = { key = 'a', mods = 'CTRL' } } },
    { key = 'RightArrow', mods = 'CMD', action = act { SendKey = { key = 'e', mods = 'CTRL' } } },

    -- Make Option-Left equivalent to OPT-b which many line editors interpret as backward-word
    { key = 'LeftArrow', mods = 'OPT', action = act { SendKey = { key = 'b', mods = 'OPT' } } },

    -- Make Option-Right equivalent to OPT-f; forward-word
    { key = 'RightArrow', mods = 'OPT', action = act { SendKey = { key = 'f', mods = 'OPT' } } },

    -- Translate forward delete (delete key, in macOS) to CTRL + d (for compatibility with shell)
    { key = 'Delete', action = act { SendKey = { key = 'd', mods = 'CTRL' } } },
    -- Translate forward delete word (alt+delete) to OPT + d (for compatibility with shell)
    { key = 'Delete', mods = 'OPT', action = act { SendKey = { key = 'd', mods = 'OPT' } } },

    -- Make Option-Backspace equivalent to Ctrl + w; delete word
    { key = 'Backspace', mods = 'OPT', action = act { SendKey = { key = 'w', mods = 'CTRL' } } },
    -- Clear buffer

    { key = '∂', action = act { SendKey = { key = 'd', mods = 'OPT' } } },

    -- Keybinding disables
    { key = 'k', mods = 'CMD', action = wezterm.action.DisableDefaultAssignment, },
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
