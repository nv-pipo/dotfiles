-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Start terminal maximized
local mux = wezterm.mux
wezterm.on('gui-startup', function()
    local _, _, window = mux.spawn_window {}
    window:gui_window():toggle_fullscreen()
end)

-- Visual bell
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 150,
}
config.colors = {
    visual_bell = '#FFFFFF',
}

-- Disable the tab bar
config.enable_tab_bar = false

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'

-- Keyboard
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false
-- Keybindings
config.keys = {
    -- tmux tab navigation:
    -- New tab with CMD + t (prefix + c | \x00c | \u0000c)
    { key = 't', mods = 'CMD', action = wezterm.action.SendString '\x00c' },
    -- Close tab with CMD + w (prefix + x | \x00x | \u0000x)
    { key = 'w', mods = 'CMD', action = wezterm.action.SendString '\x00x' },
    -- Next tab with CMD + OPT + Right (prefix + n | \x00n | \u0000n)
    { key = 'RightArrow', mods = 'CMD | OPT', action = wezterm.action.SendString '\x00n' },
    -- Previous tab with CMD + OPT + Left (prefix + p | \x00p | \u0000p)
    { key = 'LeftArrow', mods = 'CMD | OPT', action = wezterm.action.SendString '\x00p' },

    -- Map CMD + Left/Right to Ctrl + a/e. For navigating to the start/end of the line
    { key = 'LeftArrow', mods = 'CMD', action = wezterm.action { SendKey = { key = 'a', mods = 'CTRL' } } },
    { key = 'RightArrow', mods = 'CMD', action = wezterm.action { SendKey = { key = 'e', mods = 'CTRL' } } },

    -- Make Option-Backspace equivalent to Ctrl + w; delete word
    { key = 'Backspace', mods = 'OPT', action = wezterm.action { SendKey = { key = 'w', mods = 'CTRL' } } },

    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = 'LeftArrow', mods = 'OPT', action = wezterm.action { SendKey = { key = 'b', mods = 'ALT' } } },

    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = 'RightArrow', mods = 'OPT', action = wezterm.action { SendKey = { key = 'f', mods = 'ALT' } } },

    -- Enable CMD to be used inside tmux by sending \x00\x00 + numbers
    -- CMD + OPT + k/j to add a new cursor above/below and CMD + d to place a cursor on the next occurrence
    { key = 'k', mods = 'CMD | OPT', action = wezterm.action { SendString = '\x00\x001' } },
    { key = 'j', mods = 'CMD | OPT', action = wezterm.action { SendString = '\x00\x002' } },
    { key = 'd', mods = 'CMD', action = wezterm.action { SendString = '\x00\x003' } },
    -- CMD + a to select all in nvim
    { key = 'a', mods = 'CMD', action = wezterm.action { SendString = '\x00\x004' } },
}

-- config.debug_key_events = true

-- and finally, return the configuration to wezterm
return config
