local M = {}

M.setup = function(on_attach, capabilities)
  require("neodev").setup({})

  require("lspconfig").sumneko_lua.setup({
    on_attach = on_attach,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        -- completion = {
        --   callSnippet = "Replace",
        -- },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        diagnostics = {
          globals = { "vim", "use", "describe", "it", "before_each", "after_each" },
        },
        telemetry = {
          enable = false,
        },
      },
    },
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  })
end

return M
