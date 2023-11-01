local o = vim.opt

-- General setup
-- o.clipboard:append "unnamedplus" -- copy to system clipboard
o.completeopt:append({
  "menu",
  "menuone", -- show menu even if there is only one match
  "noinsert", -- don't insert text on completion
  -- "preview" -- show preview of completion
})
o.hidden = true -- keep hidden buffers
o.updatetime = 50 -- update interval
o.timeoutlen = 500

-- Undo and backup options
o.backup = false -- don't create backup files
o.backupdir = "/tmp/nvim"
o.swapfile = false -- disable swapfile for the buffer
o.undofile = true -- keep undo history
o.undodir = "/tmp/nvim"

-- UI
o.mouse = "a" -- enable mouse
o.number = true -- show line numbers
o.relativenumber = true -- show relative line numbers
o.splitbelow = true
o.splitright = true
o.termguicolors = true -- enable true colors
o.showbreak = "↳ "
o.pumheight = 15 -- max number of items in the popup menu
o.laststatus = 3 -- only show statusbar on the bottom
o.showmode = false -- don't show mode (insert, normal, etc)
o.scrolloff = 10 -- keep 10 lines above and below cursor
o.signcolumn = "yes" -- always show signcolumn

-- Indentation
o.tabstop = 2 -- number of spaces tabs count for
o.shiftwidth = 2
o.softtabstop = 2
o.smartindent = true -- enable smartindent
o.expandtab = true -- use spaces instead of tabs

-- Search
o.incsearch = true -- show search results as you type
o.hlsearch = false -- don't highlight search results
o.ignorecase = true -- ignore case in search queries
o.smartcase = true -- ignore case if search query is all lowercase

o.shortmess:append("c") -- don't pass messages to |ins-completion-menu|.

-- Misc

o.completeopt = "menuone,menuone,noinsert"
o.formatoptions = o.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Do not auto format comments
  + "c" -- Auto wrap comments using textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- continue comments with o and O
  - "r" -- continue comments with enter
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  + "l" -- Long lines are not broken
  - "2" -- I'm not in gradeschool anymore

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("fix_formatoptions", {}),
  pattern = "*",
  callback = function()
    vim.cmd("set formatoptions-=ro")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 50 })
  end,
})
