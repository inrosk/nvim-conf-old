local nnoremap = require("keymap").nnoremap

return {
  --- LSP ---
  "neovim/nvim-lspconfig", -- Collection of optsurations for built-in LSP client

  --- Typescript and null-ls
  "jose-elias-alvarez/null-ls.nvim", -- Collection of null-ls sources
  "jose-elias-alvarez/typescript.nvim", -- Typescript-language-server

  "LnL7/vim-nix",

  {
    "folke/trouble.nvim", -- Pretty list of diagnostics, references, etc.
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
  },

  -- "folke/neodev.nvim", -- Neovim development environment

  --- Basics ---
  "tpope/vim-surround", -- cs"' to change surrounding quotes
  "tpope/vim-commentary", -- gc to comment
  {
    "tpope/vim-fugitive", -- Git
    keys = {
      { "<leader>gs", ":Git<CR>", desc = "Git status" },
    },
    cmd = {
      "G",
      "Git",
    },
    config = function()
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("my_fugitive", {}),
        pattern = { "*" },
        callback = function()
          if vim.bo.ft ~= "fugitive" then
            return
          end

          local bufnr = vim.api.nvim_get_current_buf()

          nnoremap("<leader>gp", function()
            vim.cmd.Git("push")
          end, { buffer = bufnr, desc = "Git push" })
        end,
      })
    end,
  },
  "tpope/vim-repeat", -- . to repeat any plugin command
  "tpope/vim-sleuth", -- Detect indentation
  {
    "mbbill/undotree", -- Visualize undo history
    keys = {
      { "<leader>u", ":UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
    },
  },

  {
    "lewis6991/gitsigns.nvim", -- Git signs
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },

  {
    "nvim-telescope/telescope.nvim", -- Telescope
    version = "0.1.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim", -- Telescope UI for quickfixes, etc.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        dev = true,
      },
    },
    opts = function()
      require("my.telescope")
      require("my.telescope.mappings")
    end,
  },

  {
    "chentoast/marks.nvim",
    opts = {
      default_mappings = false,
      mappings = {
        delete = "<leader>md",
      },
    },
  },

  {
    "NvChad/nvim-colorizer.lua", -- Color highlighter
    opts = {
      filtetypes = {
        "*",
      },
      user_default_options = {
        names = false,
        tailwind = "both",
        css = true,
      },
    },
  },

  {
    "folke/which-key.nvim", -- Keybindings helper
    opts = {
      window = {
        border = "single",
      },
    },
  },
}
