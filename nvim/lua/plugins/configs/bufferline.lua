local bufferline = require("bufferline")
bufferline.setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
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
    diagnostics_update_in_insert = true,
  }
})

local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    b = {
      name = "Buffer",
      c = { "<cmd>enew<cr>", "Create New Buffer" },
      s = { "<cmd>:w<cr>", "Save" },
      q = { "<cmd>Bdelete<cr>", "Close" },
      n = { "<cmd>BufferLineMoveNext<cr>", "Move Buffer to Next" },
      p = { "<cmd>BufferLineMovePrev<cr>", "Move Buffer to Previous" },
      r = { "<cmd>BufferLineCloseRight<cr>", "Close Buffers to the Right" },
      l = { "<cmd>BufferLineCloseLeft<cr>", "Close Buffers to the Left" },
      o = { "<cmd>exe 'BufferLineCloseLeft' | exe 'BufferLineCloseRight'<cr>", "Close Other Buffers" },
      h = { "<cmd>:vert help bufferline.nvim<cr>", "Open Documentation" },
    },
  }
})
