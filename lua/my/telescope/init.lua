local telescope = require("telescope")
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
local previewers = require("telescope.previewers")

-- Ignore files bigger than the threshold.
local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then
      return
    end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

telescope.setup({
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    file_ignore_patterns = { "node_modules", "*.ico", "png", "jpg", "woff", "svg", "webp" },
    prompt_prefix = " >",
    color_devicons = true,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = new_maker,
    mappings = {
      i = {
        ["<C-c>"] = actions.close,
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-t>"] = trouble.open_with_trouble,
      },
      n = {
        ["<C-c>"] = actions.close,
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

local M = {}

M.search_dotfiles = function()
  require("telescope.builtin").find_files({
    prompt_title = "< VimRC >",
    cwd = "~/.config/nvim/",
    hidden = true,
  })
end

M.search_all_projects = function()
  require("telescope.builtin").find_files({
    prompt_title = "~all_projects~",
    cwd = "~/projects",
  })
end

M.lsp_implementations = function()
  require("telescope.builtin").lsp_implementations({
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  })
end

M.lsp_references = function()
  require("telescope.builtin").lsp_references({
    ignore_filename = false,
  })
end

M.grep_string = function()
  local search = vim.fn.input("Grep (or leave empty): ")
  if search ~= "" then
    require("telescope.builtin").grep_string({ search = search })
  else
    require("telescope.builtin").grep_string()
  end
end

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
-- require("telescope").load_extension "harpoon"

return M
