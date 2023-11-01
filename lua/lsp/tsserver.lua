local nnoremap = require("keymap").nnoremap

local M = {}

M.setup = function(on_attach, capabilities)
  -- Default setup
  -- require("lspconfig").tsserver.setup({
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  -- })

  -- jose-elias-alvarez/typescript.nvim setup
  require("typescript").setup({
    server = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- Setup keys
        nnoremap("<leader>rf", ":TypescriptRenameFile<CR>", { buffer = bufnr, desc = "Rename file" })
      end,
      capabilities = capabilities,
    },
  })
end

return M
