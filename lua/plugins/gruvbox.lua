return {
  "ellisonleao/gruvbox.nvim",
  init = function()
    vim.o.background = "dark"
    vim.cmd("colorscheme gruvbox")
  end,
  opts = {
    undercurl = true,
    underline = true,
    bold = false, -- changed
    italic = {
      strings = false,
      comments = false,
      operators = false,
      folds = false,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- changed; can be "hard", "soft" or empty string
    palette_overrides = {},
    dim_inactive = false,
    transparent_mode = false,
    overrides = {
      -- Normal = { bg = "#141617" },

      SignColumn = { bg = "#1d2021" },
      MarkSignNumHL = { fg = "#fabd2f" },

      MatchParen = { bg = "#32302f" },

      -- NvimTree
      CursorLine = { bg = "#282828" }, -- Fix highlighting in nvim-tree
      -- Directory = { fg = "#83a598" },
      -- NvimTreeFolderIcon = { fg = "#83a598" },

      -- Hover menu
      Pmenu = { bg = "#1d2021" },
      CmpPmenu = { bg = "#1d2021", fg = "#665C54" }, -- cmp border (fg sets border color)
      CmpPmenuSel = { bg = "#83a598", fg = "#161a1c" }, -- cmp selected menu item
      NormalFloat = { bg = "#1d2021" },

      -- Telescope
      TelescopeBorder = { fg = "#665C54" },
      TelescopePromptBorder = { fg = "#665C54" },
      TelescopePreviewBorder = { fg = "#665C54" },
      TelescopeResultsBorder = { fg = "#665C54" },
      TelescopePromptTitle = { fg = "#ebdbb2" },
      TelescopePromptCounter = { fg = "#bdae93" },

      -- Trouble
      TroubleCount = { fg = "#ebdbb2" },
      TroubleFoldIcon = { fg = "#ebdbb2" },
      TroubleSignError = { fg = "#fb4934" },
      TroubleSignHint = { fg = "#83a598" },
      TroubleSignInformation = { fg = "#d79921" },
      TroubleSignOther = { fg = "#ebdbb2" },
      TroubleSignWarning = { fg = "#fe8019" },

      -- Diagnostics
      DiagnosticVirtualTextHint = { fg = "#665c54" },
      DiagnosticVirtualTextInfo = { fg = "#665c54" },
      DiagnosticVirtualTextWarn = { fg = "#665c54" },
      DiagnosticVirtualTextError = { fg = "#665c54" },

      IndentBlanklineIndent1 = { fg = "#282828" },
      IndentBlanklineContextChar = { fg = "#3c3836" },
    },
  },
}

-- local colorPalette = {
--   dark0_hard = "#1d2021",
--   dark0 = "#282828",
--   dark0_soft = "#32302f",
--   dark1 = "#3c3836",
--   dark2 = "#504945",
--   dark3 = "#665c54",
--   dark4 = "#7c6f64",
--   light0_hard = "#f9f5d7",
--   light0 = "#fbf1c7",
--   light0_soft = "#f2e5bc",
--   light1 = "#ebdbb2",
--   light2 = "#d5c4a1",
--   light3 = "#bdae93",
--   light4 = "#a89984",
--   bright_red = "#fb4934",
--   bright_green = "#b8bb26",
--   bright_yellow = "#fabd2f",
--   bright_blue = "#83a598",
--   bright_purple = "#d3869b",
--   bright_aqua = "#8ec07c",
--   bright_orange = "#fe8019",
--   neutral_red = "#cc241d",
--   neutral_green = "#98971a",
--   neutral_yellow = "#d79921",
--   neutral_blue = "#458588",
--   neutral_purple = "#b16286",
--   neutral_aqua = "#689d6a",
--   neutral_orange = "#d65d0e",
--   faded_red = "#9d0006",
--   faded_green = "#79740e",
--   faded_yellow = "#b57614",
--   faded_blue = "#076678",
--   faded_purple = "#8f3f71",
--   faded_aqua = "#427b58",
--   faded_orange = "#af3a03",
--   gray = "#928374",
-- }
