local nnoremap = require("keymap").nnoremap

local wk = require("which-key")

wk.register({ b = { name = "buffer" } }, { prefix = "<leader>" })

local function revertBuffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
  local bufPath = vim.api.nvim_buf_get_name(bufnr)

  if modified then
    vim.ui.input({
      prompt = "Discard edits and reread from " .. bufPath .. "? (Y/n) ",
    }, function(input)
      if input ~= "n" then
        vim.cmd("e!")
      end
    end)
  else
    vim.cmd("e")
  end
end

nnoremap("<leader>br", function()
  revertBuffer()
end, { desc = "Revert buffer" })

return {
  {
    "famiu/bufdelete.nvim", -- Delete buffers without closing windows
    keys = {
      { "<leader>bd", ":Bdelete<CR>", desc = "Kill buffer" },
    },
  },

  {
    "j-morano/buffer_manager.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>bi",
        function()
          require("buffer_manager.ui").toggle_quick_menu()
        end,
        desc = "Buffer list",
      },
    },
    opts = {
      focus_alternate_buffer = false,
      short_file_names = false,
      short_term_names = false,
      select_menu_item_commands = {
        edit = {
          key = "<CR>",
          command = "edit",
        },
        v = {
          key = "<C-v>",
          command = "vsplit",
        },
        h = {
          key = "<C-h>",
          command = "split",
        },
      },
    },
  },
}
