local global_icons = require("core.ui-globals").icons
local nvim_tree = require("nvim-tree")
local which_key = require("which-key")

nvim_tree.setup {
  disable_netrw = true,
  hijack_cursor = true,
  remove_keymaps = { "H", "J", "K", "L" }, -- conflicts with window resize
  renderer = {
    full_name = true,
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder_arrow = false,
      },
    }
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = true,
        picker = function ()
          return vim.fn.win_getid(vim.fn.winnr("#"))
        end
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = global_icons.hint,
      info = global_icons.info,
      warning = global_icons.warning,
      error = global_icons.error,
    },
  }
}

local colors = require("catppuccin.palettes").get_palette "mocha"
require("catppuccin.lib.highlighter").syntax({
  NvimTreeWinSeparator = { fg = colors.mantle, bg = colors.mantle },
  NvimTreeEndOfBuffer = { fg = colors.mantle, bg = colors.mantle },
  NvimTreeNormal = { fg = colors.text, bg = colors.mantle },
})

which_key.register({
  ["<leader>"] = {
    e = {
      name = "Explorer",
      t = { "<cmd>NvimTreeToggle<cr>", "Toggle File Explorere" },
      f = { "<cmd>NvimTreeFocus<cr>", "Focus File Explorere" },
      r = { "<cmd>NvimTreeRefresh<cr>", "Refersh File Explorere" },
      m = { "<cmd>NvimTreeFindFile<cr>", "Move to Current Buffer" },
      h = { "<cmd>vert help nvim-tree<cr>", "Open Documentation" },
    }
  }
})
