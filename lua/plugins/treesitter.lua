return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "JoosepAlviste/nvim-ts-context-commentstring", -- Commentstring for treesitter
      "windwp/nvim-ts-autotag", -- Auto close tags for treesitter
    },
    opts = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "astro",
          "css",
          "graphql",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "lua",
          "nix",
          "org",
          "python",
          "tsx",
          "typescript",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<M-s>", -- maps in normal mode to init the node/scope selection
            node_incremental = "<M-k>", -- increment to the upper named parent
            node_decremental = "<M-j>", -- decrement to the previous node
            scope_incremental = "<M-e>", -- increment to the upper scope (as defined in locals.scm)
          },
        },
        indent = {
          enable = true,
        },

        -- Plugins
        matchup = {
          enable = true,
        },
        context_commentstring = {
          enable = true,
          opts = {
            lua = "-- %s",
            nix = "# %s",
          },
        },
        autotag = {
          enable = false,
        },
        playground = {
          enable = true,
        },
      })
    end,
  },
  {
    "windwp/nvim-autopairs", -- Auto close brackets for treesitter
    init = function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    end,
    opts = {
      check_ts = true,
    },
  },
  {
    "andymass/vim-matchup", -- % to jump between matching words
    opts = function()
      -- vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 300
      vim.g.matchup_matchparen_deferred_hide_delay = 300
      vim.matchup_matchparen_nomode = "i"
    end,
  },

  -- "RRethy/nvim-treesitter-endwise" -- Auto close end for treesitter, but doesn't work
}
