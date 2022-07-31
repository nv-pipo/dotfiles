  local bufferline = require("bufferline")

  bufferline.setup({
    options = {
      close_command = function(bufnum)
        require('bufdelete').bufdelete(bufnum, true)
      end,
      offsets = {
        {
          filetype = "NvimTree",
        }
      },
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      show_close_icon = false,
      themable = true,
      always_show_bufferline = false,
    }
  })

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    b = {
      name = "Buffer",
      q = {"<cmd>Bdelete<cr>", "Close"},
      f = {"<cmd>Telescope buffers<cr>", "Find Buffer"},
      n = {"<cmd>BufferLineMoveNext<cr>", "Move Buffer to Next"},
      p = {"<cmd>BufferLineMovePrev<cr>", "Move Buffer to Previous"},
      r = {"<cmd>BufferLineCloseRight<cr>", "Close Buffers to the Right"},
      l = {"<cmd>BufferLineCloseLeft<cr>", "Close Buffers to the Left"},
      o = {"<cmd>exe 'BufferLineCloseLeft' | exe 'BufferLineCloseRight'<cr>", "Close Other Buffers"},
      c = {"<cmd>enew<cr>", "Create New Buffer"},
    },
  }
})
