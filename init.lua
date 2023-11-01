local modules = {
  "disable_builtin",
  "settings",
  "keybinds",
  "plugins",
  "lsp",
}

local errors = {}

MyGlobal = {}
MyGlobal.formatOnSave = true
MyGlobal.twAutoComplete = false

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

for _, v in pairs(modules) do
  if vim.g.vscode then
    goto continue
  end

  if v == "plugins" then
    require("lazy").setup("plugins", {
      dev = {
        path = "~/.config/nvim/nixPlugins",
      },
    })
    goto continue
  end

  local ok, err = pcall(require, v)

  if not ok then
    table.insert(errors, err)
  end

  ::continue::
end

if next(errors) ~= nil then
  for _, v in pairs(errors) do
    print(v)
  end
end
