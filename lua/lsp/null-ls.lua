local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {
  -- formatting
  -- b.formatting.prettier.with({
  --   filetypes = { "php" },
  -- }),
  b.formatting.prettierd,
  b.formatting.shfmt,
  b.formatting.stylua.with({
    condition = function(utils)
      return utils.root_has_file({ ".stylua.toml", "stylua.toml" })
    end,
  }),
  b.formatting.black,

  -- code actions
  -- b.code_actions.gitsigns,
  -- b.code_actions.eslint,
  require("typescript.extensions.null-ls.code-actions"),
}

local M = {}

-- restart null-ls with :lua require("lsp.null-ls").toggle({})

M.setup = function(on_attach)
  null_ls.setup({
    on_attach = on_attach,
    sources = sources,
  })
end

return M
