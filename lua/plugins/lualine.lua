local function lsp_servers_status()
  local clients = vim.lsp.buf_get_clients(0)
  if vim.tbl_isempty(clients) then
    return ""
  end

  local client_names = {}
  for _, client in pairs(clients) do
    table.insert(client_names, client.name)
  end

  return table.concat(client_names, "|")
end

local function lsp_messages()
  local msgs = {}

  for _, msg in ipairs(vim.lsp.util.get_progress_messages()) do
    local content
    if msg.progress then
      content = msg.title
      if msg.message then
        content = content .. " " .. msg.message
      end
      if msg.percentage then
        content = content .. " (" .. msg.percentage .. "%%)"
      end
    elseif msg.status then
      content = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ":~:.")
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        content = "(" .. filename .. ") " .. content
      end
    else
      content = msg.content
    end

    table.insert(msgs, "[" .. msg.name .. "] " .. content)
  end

  return table.concat(msgs, " | ")
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  opts = {
    options = {
      icons_enabled = true,
      theme = "gruvbox",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {},
      lualine_b = {
        "branch",
        "diff",
      },
      lualine_c = { "filename" },
      lualine_x = {
        lsp_messages,
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
        },
      },
      lualine_y = { "filetype", lsp_servers_status },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = { "mode" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = { "fileformat", "encoding" },
      lualine_z = {},
    },
    tabline = {},
    extensions = { "nvim-tree", "fugitive" },
  },
}
