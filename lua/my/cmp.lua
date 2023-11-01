local cmp = require("cmp")
local lspkind = require("lspkind")

local copilot_ok, copilotSuggestion = pcall(require, "copilot.suggestion")
local luaSnip = require("luasnip")

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local debounce_timer = vim.loop.new_timer()

cmp.setup({
  snippet = {
    expand = function(args)
      luaSnip.lsp_expand(args.body)
    end,
  },

  mapping = {
    ["<C-Space>"] = cmp.mapping(function()
      debounce_timer:stop()
      cmp.complete({ reason = cmp.ContextReason.Manual })
    end, { "i", "c" }), -- trigger completion

    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luaSnip.expand_or_locally_jumpable() then
        luaSnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "c" }),

    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      elseif luaSnip.jumpable(-1) then
        luaSnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "c" }),

    ["<C-e>"] = cmp.config.disable, -- disable if using emmet

    ["<C-s>"] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.close()
        debounce_timer:stop()
        -- fallback()
      else
        cmp.complete()
      end
    end),

    -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.SelectBehavior.Insert, select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if luaSnip.expand_or_locally_jumpable() then
        luaSnip.expand_or_jump()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luaSnip.jumpable(-1) then
        luaSnip.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),

    ["<C-l>"] = cmp.mapping(function(fallback)
      if copilot_ok and copilotSuggestion.is_visible() then
        copilotSuggestion.accept()
      else
        fallback()
      end
    end),

    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    { name = "path" },
    { name = "orgmode" },
    {
      name = "buffer",
      max_item_count = 15,
      option = {
        keyword_length = 2,
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  }),
  completion = {
    autocomplete = false,
    keyword_length = 1,
    completeopt = "menu,menuone,noinsert",
  },
  window = {
    completion = {
      border = "single",
      winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenu,CursorLine:CmpPmenuSel,Search:None",
      scrolloff = 5,
      col_offset = -1,
      side_padding = 1,
      scrollbar = true,
    },
    documentation = {
      border = "single",
      winhighlight = "FloatBorder:CmpPmenu",
    },
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp_signature_help = "[sig]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[LUA]",
        path = "[path]",
        luasnip = "[snip]",
      },
    }),
  },
  experimental = {
    native_menu = false,
    ghost_text = false,
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- Custom debounce
-- Disable autocomplete or debounce when typing inside a class name to not trigger tailwind

local ts_utils = require("nvim-treesitter.ts_utils")

-- Find string in table
local function is_matching(string, values)
  for index = 1, #values do
    if values[index] == string then
      return true
    end
  end
  return false
end

-- Check if currently inside a class
local function attribute_is_class()
  local ts = vim.treesitter
  local node = ts_utils.get_node_at_cursor()

  if node == nil then
    return false
  end

  local parent = node:parent()
  local previous_parent = parent

  local bufnr = vim.api.nvim_get_current_buf()

  -- Return true in css inside @apply
  if vim.bo.ft == "css" and is_matching(node:type(), { "ERROR", "at_rule" }) then
    return true
  end

  local node_types = { "string", "string_fragment", "template_string", "attribute_value", "raw_text" }

  if is_matching(node:type(), node_types) then
    while parent ~= nil and not is_matching(parent:type(), { "jsx_attribute", "attribute" }) do
      -- Fix astro class with ``; it goes template_string -> expression_statement -> program
      if previous_parent:type() == "expression_statement" and parent:type() == "program" then
        return true
      end

      -- Fix astro jsx class with open quote; it goes raw_text -> ERROR
      if node:type() == "raw_text" and parent:type() == "ERROR" then
        return true
      end

      previous_parent = parent
      parent = parent:parent()
    end
  end

  if parent == nil then
    return false
  end

  -- Get the attribute name
  local attribute_name = ts.get_node_text(parent:child(0), bufnr)

  if is_matching(attribute_name, { "class", "className", "classList" }) then
    return true
  else
    return false
  end
end

local DEBOUNCE_DELAY = 150 -- regular debounce delay
local TW_DEBOUNCE_DELAY = 1500 -- tailwind debounce delay

local function debounce()
  debounce_timer:stop()
  local is_class = attribute_is_class()

  -- Check if MyGlobal.twAutoComplete is true
  if is_class and not MyGlobal.twAutoComplete then
    return
  end

  -- Don't trigger if cmp is visible
  -- if cmp.visible() then
  --   return
  -- end

  debounce_timer:start(
    attribute_is_class() and TW_DEBOUNCE_DELAY or DEBOUNCE_DELAY,
    0,
    vim.schedule_wrap(function()
      cmp.complete({ reason = cmp.ContextReason.Auto })
    end)
  )
end

vim.api.nvim_create_autocmd("TextChangedI", {
  group = vim.api.nvim_create_augroup("cmp_debounce", {}),
  pattern = { "*" },
  callback = function()
    local ft = vim.bo.ft

    -- Disable in TelescopePrompt
    if ft == "TelescopePrompt" then
      return
    end

    vim.schedule(function()
      debounce()
    end)
  end,
})
