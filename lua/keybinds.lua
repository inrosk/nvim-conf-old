local keymap = require("keymap")
local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local inoremap = keymap.inoremap

vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

nnoremap("<C-z>", "<Nop>")

-- Ctrl+BS removes word (C-BS is registered as C-H)
inoremap("<C-H>", "<Esc>ciw")

-- Keep centered
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ'z")
nnoremap("G", "Gzzzv")
nnoremap("<C-d", "<C-d>zz")
nnoremap("<C-u", "<C-u>zz")

-- Undo break points
inoremap(",", ",<c-g>u")
inoremap(".", ".<c-g>u")
inoremap("!", "!<c-g>u")
inoremap("-", "-<c-g>u")
inoremap("/", "/<c-g>u")
inoremap("(", "(<c-g>u")
inoremap("{", "{<c-g>u")

-- Don't yank on delete char
nnoremap("x", '"_x')
nnoremap("X", '"_X')
vnoremap("x", '"_x')
vnoremap("X", '"_X')

-- Copy to system clipboard
nnoremap("<leader>y", '"+y')
vnoremap("<leader>y", '"+y')
nnoremap("<leader>Y", '"+y$')

-- Move selected line / block of text in visual mode
vnoremap("K", ":move '<-2<CR>gv-gv")
vnoremap("J", ":move '>+1<CR>gv-gv")

-- Don't replace register on paste in visual
vim.cmd("xnoremap <expr> p 'pgv\"'.v:register.'y`>'")
vim.cmd("xnoremap <expr> P 'Pgv\"'.v:register.'y`>'")

-- Better indenting
vnoremap("<", "<gv")
vnoremap(">", ">gv")

-- Copy filename
nnoremap("yp", ":let @+ = expand('%')<CR>")

-- Better window movement
nnoremap("<C-h>", "<C-w>h")
nnoremap("<C-j>", "<C-w>j")
nnoremap("<C-k>", "<C-w>k")
nnoremap("<C-l>", "<C-w>l")

-- Move visual lines
vim.cmd("noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')")
vim.cmd("noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')")

-- Adjust split size with arrows
nnoremap("<C-Up>", ":resize +2<CR>")
nnoremap("<C-Down>", ":resize -2<CR>")
nnoremap("<C-Left>", ":vertical resize +2<CR>")
nnoremap("<C-Right>", ":vertical resize -2<CR>")

-- Split horizontal and vertical
nnoremap("<leader>sv", ":vsp<CR>")
nnoremap("<leader>sh", ":sp<CR>")

-- Tabs
nnoremap("<leader><tab>n", ":tabnew<CR>")
nnoremap("<leader><tab>d", ":tabclose<CR>")
nnoremap("<M-1>", "1gt")
nnoremap("<M-2>", "2gt")
nnoremap("<M-3>", "3gt")
nnoremap("<M-4>", "4gt")
nnoremap("<M-5>", "5gt")
nnoremap("<M-6>", "6gt")

--- Toggle nvimtree
--- nnoremap("<C-n>", ":NvimTreeToggle<CR>")
--- nnoremap("<leader><C-n>", ":NvimTreeFindFile<CR>")
