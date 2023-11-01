local tele = require("my.telescope")
local nnoremap = require("keymap").nnoremap

-- Ctrl + p
nnoremap("<C-f>", ":Telescope find_files<CR>")
nnoremap("<C-p>", ":Telescope git_files<CR>")

nnoremap("<leader>tt", ":Telescope<CR>")
nnoremap("<leader>tgs", function()
  tele.grep_string()
end, { desc = "Telescope grep_string" })

nnoremap("<leader>tlg", ":Telescope live_grep<CR>")
nnoremap("<leader>tb", ":Telescope buffers<CR>")
nnoremap("<leader>,", ":Telescope buffers<CR>")

-- Help and documentation
nnoremap("<leader>thc", ":Telescope commands<CR>")
nnoremap("<leader>thh", ":Telescope highlights<CR>")
nnoremap("<leader>thm", ":Telescope man_pages<CR>")
nnoremap("<leader>tho", ":Telescope vim_options<CR>")
nnoremap("<leader>'", ":Telescope resume<CR>") -- resume last command
nnoremap("<leader>thr", ":Telescope resume<CR>") -- resume last command
nnoremap("<leader>tht", ":Telescope help_tags<CR>")

-- Search all projects
nnoremap("<leader>tap", function()
  tele.search_all_projects()
end, { desc = "Telescope search all projects" })

-- Search dotfiles
nnoremap("<leader>tdf", function()
  tele.search_dotfiles()
end, { desc = "Telescope search dotfiles" })
