-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Visual bell
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 150,
}
config.colors = {
    visual_bell = '#FFFFFF',
}

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'

-- Start terminal maximized
local mux = wezterm.mux
wezterm.on('gui-startup', function()
    local _, _, window = mux.spawn_window {}
    window:gui_window():toggle_fullscreen()
end)

-- Keyboard
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false
-- Keybindings
config.keys = {
    -- CMD + META + Left/Right to switch tabs
    { key = 'RightArrow', mods = 'CMD | OPT', action = wezterm.action { ActivateTabRelative = 1 } },
    { key = 'LeftArrow', mods = 'CMD | OPT', action = wezterm.action { ActivateTabRelative = -1 } },

    -- Map CMD + Left/Right to Ctrl + a/e. For navigating to the start/end of the line
    { key = 'LeftArrow', mods = 'CMD', action = wezterm.action { SendKey = { key = 'a', mods = 'CTRL' } } },
    { key = 'RightArrow', mods = 'CMD', action = wezterm.action { SendKey = { key = 'e', mods = 'CTRL' } } },

    -- Make Option-Backspace equivalent to Alt-Backspace which many line editors interpret as backward-kill-word
    { key = 'Delete', mods = 'OPT', action = wezterm.action { SendKey = { key = 'Delete', mods = 'ALT' } } },

    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = 'LeftArrow', mods = 'OPT', action = wezterm.action { SendKey = { key = 'b', mods = 'ALT' } } },

    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = 'RightArrow', mods = 'OPT', action = wezterm.action { SendKey = { key = 'f', mods = 'ALT' } } },
}

-- config.debug_key_events = true

-- and finally, return the configuration to wezterm
return config
