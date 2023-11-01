---@diagnostic disable: duplicate-set-field
local u = require("utils")
local keymap = require("keymap")
local nnoremap = keymap.nnoremap

local border_opts = { border = "single", focusable = true, scope = "line" }

vim.diagnostic.config({ virtual_text = true, float = border_opts })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts)

-- track buffers that eslint can't format to use prettier instead
local eslint_disabled_buffers = {}

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not (client and client.name == "eslint") then
    goto done
  end

  for _, diagnostic in ipairs(result.diagnostics) do
    if diagnostic.message:find("The file does not match your project config") then
      local bufnr = vim.uri_to_bufnr(result.uri)
      eslint_disabled_buffers[bufnr] = true
    end
  end

  ::done::
  return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
end

-- Format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

local lsp_formatting = function(bufnr)
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(client)
      if client.name == "eslint" then
        return not eslint_disabled_buffers[bufnr]
      end

      if client.name == "null-ls" then
        return not u.table.some(clients, function(_, other_client)
          return other_client.name == "eslint" and not eslint_disabled_buffers[bufnr]
        end)
      end
    end,
  })
end

local on_attach = function(client, bufnr)
  if client.name == "copilot" then
    return
  end
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings
  local nmap = function(lhs, rhs, desc)
    nnoremap(lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- Go to
  -- nmap("gd", vim.lsp.buf.definition, "Go to definition") -- go to definition
  nmap("gd", ":Telescope lsp_definitions<CR>", "Go to definition") -- go to definition
  -- nmap("gt", vim.lsp.buf.type_definition, "Type definition") -- go to type definition
  nmap("gt", ":Telescope lsp_type_definitions<CR>", "Type definition") -- go to type definition
  nmap("gi", vim.lsp.buf.implementation, "Go to implementation") -- go to implementation

  nmap("gr", function()
    require("plugins.telescope").lsp_references() -- go to references with telescope
  end, "References")

  -- Definition preview
  nmap("K", vim.lsp.buf.hover, "Hover definition") -- hover

  -- Quickfix
  nmap("<space>ac", vim.lsp.buf.code_action, "Code action") -- code action

  -- Rename
  nmap("<space>rn", vim.lsp.buf.rename, "Rename") -- rename
  nmap("<F2>", vim.lsp.buf.rename, "Rename") -- rename

  -- Diagnostic
  nmap("[d", vim.diagnostic.goto_prev, "Previous diagnostic") -- prev diagnostic
  nmap("]d", vim.diagnostic.goto_next, "Next diagnostic") -- next diagnostic
  nmap("<leader>K", vim.diagnostic.open_float, "Open diagnostic float") -- open diagnostic float

  -- Restarting
  nmap("<leader>lx", function()
    vim.lsp.stop_client(vim.lsp.get_active_clients(), false)
  end, "Stop all LSP servers")

  -- Formatting on save
  nmap("<leader>ff", lsp_formatting, "Format buffer")

  nmap("<leader>fs", function()
    print("Format on save is " .. (MyGlobal.formatOnSave and "enabled" or "disabled"))
  end, "Format on save status")

  nmap("<leader>ft", function()
    MyGlobal.formatOnSave = not MyGlobal.formatOnSave
    print("Format on save: " .. (MyGlobal.formatOnSave and "enabled" or "disabled"))
  end, "Toggle auto format on save")

  -- Auto format on save
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        if MyGlobal.formatOnSave then
          lsp_formatting(bufnr)
        end
      end,
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
  "astro",
  "bashls",
  "cssls",
  "eslint",
  "jsonls",
  "null-ls",
  "pyright",
  -- "sumneko_lua",
  "tailwindcss",
  "tsserver",
}

for _, server in ipairs(servers) do
  require("lsp." .. server).setup(on_attach, capabilities)
end

-- suppress irrelevant messages
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("%[lspconfig%]") then
    return
  end

  if msg:match("No information available") then
    return
  end

  if msg:match("warning: multiple different client offset_encodings") then
    return
  end

  notify(msg, ...)
end
