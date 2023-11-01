return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",

      -- Pictograms for cmp items
      "onsails/lspkind-nvim",
    },
    lazy = false,
    opts = function()
      require("my.cmp")
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    init = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.vsnip" } })
    end,
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
  },
  "saadparwaiz1/cmp_luasnip",

  -- Emmet
  {
    "mattn/emmet-vim",
    lazy = false,
    init = function()
      -- remap emmet
      vim.cmd("let g:user_emmet_leader_key='<nop>'")

      vim.cmd("let g:user_emmet_expandabbr_key='<c-e>'")

      vim.cmd("let g:user_emmet_install_global = 0")

      -- vim.cmd("autocmd filetype html,css,typescriptreact,javascript,astro emmetinstall")

      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup("emmet", {}),
        pattern = {
          "astro",
          "css",
          "html",
          "javascript",
          "typescriptreact",
        },
        callback = function()
          vim.cmd("EmmetInstall")
        end,
      })
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua", -- copilot lua port
    enabled = false,
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 0,
      },
      keymap = {
        accept = "<C-l>",
      },
      filetypes = {
        markdown = true,
        gitcommit = true,
      },
    },
  },
  -- {
  --   "github/copilot.vim"
  -- },
}
