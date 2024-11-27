-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.term = 'wezterm'

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

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

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
    -- tmux tab navigation:
    -- New tab with CMD + t (Ctrl + b + c | \x00c | \u0000c)
    { key = 't', mods = 'CMD', action = act.SendString '\x02c' },
    -- Close tab with CMD + w (Ctrl + b + x | \x00x | \u0000x)
    { key = 'w', mods = 'CMD', action = act.SendString '\x02x' },
    -- Next tab with CMD + OPT + Right (Ctrl + b + n | \x00n | \u0000n)
    { key = 'RightArrow', mods = 'CMD | OPT', action = act.SendString '\x02n' },
    -- Previous tab with CMD + OPT + Left (Ctrl + b + p | \x00p | \u0000p)
    { key = 'LeftArrow', mods = 'CMD | OPT', action = act.SendString '\x02p' },

    -- Map CMD + Left/Right to Ctrl + a/e. For navigating to the start/end of the line
    { key = 'LeftArrow', mods = 'CMD', action = act { SendKey = { key = 'a', mods = 'CTRL' } } },
    { key = 'RightArrow', mods = 'CMD', action = act { SendKey = { key = 'e', mods = 'CTRL' } } },

    -- Make Option-Backspace equivalent to Ctrl + w; delete word
    { key = 'Backspace', mods = 'OPT', action = act { SendKey = { key = 'w', mods = 'CTRL' } } },

    -- Make Option-Left equivalent to OPT-b which many line editors interpret as backward-word
    { key = 'LeftArrow', mods = 'OPT', action = act { SendKey = { key = 'b', mods = 'OPT' } } },

    -- Make Option-Right equivalent to OPT-f; forward-word
    { key = 'RightArrow', mods = 'OPT', action = act { SendKey = { key = 'f', mods = 'OPT' } } },

    -- TMUX hacks
    -- Use tmux find in buffer
    { key = 'f', mods = 'CMD', action = act { SendString = '\x02f' } },
    -- Clear buffer in tmux
    { key = 'k', mods = 'CMD', action = act { SendString = '\x02u' } },
    -- Copy buffer in tmux
    { key = 'c', mods = 'CMD | OPT', action = act { SendString = '\x02v' } },
    -- Set delete key to CTRL + d
    { key = 'Delete', action = act { SendKey = { key = 'd', mods = 'CTRL' } } },
    -- CMD + OPT + k/j to add a new cursor above/below and CMD + d to place a cursor on the next occurrence
    { key = 'k', mods = 'CMD | OPT', action = act { SendKey = { key = 'ķ', mods = 'OPT' } } },
    { key = 'j', mods = 'CMD | OPT', action = act { SendKey = { key = 'ĵ', mods = 'OPT' } } },
    { key = 'd', mods = 'CMD', action = act { SendKey = { key = 'ď', mods = 'OPT' } } },
    -- CMD + a to select all in nvim
    { key = 'a', mods = 'CMD', action = act.Multiple { act.SendKey { key = 'b', mods = 'CTRL'}, act.SendKey { key = 'a' } } },
    -- CMD + / in vim to comment line or blocks
    { key = '/', mods = 'CMD', action = act { SendKey = { key = 'ş', mods = 'OPT' } } },
    -- SHIFT + ENTER to trigger SHIFT+ENTER as string
    { key = 'raw:36', mods = 'SHIFT', action = act { SendString = '\x1b[13;2u' } },
    -- CMD + l as OPT + ł for copilot accept word
    { key = 'l', mods = 'CMD', action = act { SendKey = { key = 'ł', mods = 'OPT' } } },
    -- CMD + j as OPT + ĵ for copilot accept line
    { key = 'j', mods = 'CMD', action = act { SendKey = { key = 'ĵ', mods = 'OPT' } } },
    -- CMD + Enter as OPT + ė for copilot accept suggestion
    { key = 'Return', mods = 'CMD', action = act { SendKey = { key = 'ė', mods = 'OPT' } } },
}

-- config.debug_key_events = true

-- and finally, return the configuration to wezterm
return config
