local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require("lspconfig")

  lspconfig["eslint"].setup({
    root_dir = lspconfig.util.root_pattern(".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc"),

    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      client.server_capabilities.documentFormattingProvider = true
    end,

    capabilities = capabilities,

    settings = {
      format = {
        enable = true,
      },
    },

    handlers = {
      -- Apparently this error shows up but formatting still works
      ["window/showMessageRequest"] = function(_, result)
        if result.message:find("EOENT") then
          return vim.NIL
        end

        if result.message:find("Cannot read properties of undefined") then
          return vim.NIL
        end

        return vim.lsp.handlers["window/showMessageRequest"](nil, result)
      end,
    },
  })
end

return M
