return {
  {
    "kyazdani42/nvim-tree.lua", -- File explorer
    dependencies = {
      {
        "kyazdani42/nvim-web-devicons", -- Icons
        opts = {
          override = {
            astro = {
              icon = "",
              color = "#FFFFFF",
              name = "astro",
            },
          },
        },
      },
    },
    keys = {
      { "<C-n>", ":NvimTreeToggle<CR>", desc = "Nvim Tree Toggle" },
      { "<leader><C-n>", ":NvimTreeFindFile<CR>", desc = "Nvim Tree find current file" },
    },
    opts = {
      -- open_on_setup = false,
      tab = {
        sync = {
          open = true, -- open when switching tabs and the tree is already open
          close = false, -- closes across all tabs
        },
      },
      hijack_cursor = true, -- keep the cursor at the start of the filenam when moving
      renderer = {
        icons = {
          show = {
            folder_arrow = true,
          },
        },
      },
      update_focused_file = {
        enable = false,
        update_cwd = false,
        ignore_list = {},
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      actions = {
        open_file = {
          window_picker = {
            chars = "1234567890",
          },
        },
      },
      filters = {
        dotfiles = true,
        custom = {
          ".git",
          "node_modules",
          ".cache",
        },
      },
    },
  },
}
