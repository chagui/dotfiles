local utils = require("user.utils")
local cmp = require("cmp")

local snippet = {
    expand = {} 
}

local success, luasnip = pcall(require, "luasnip")
if success then
    snippet.expand = function(args) 
        luasnip.lsp_expand(args.body)
    end

    if utils.is_vscode() then
        require("luasnip/loaders/from_vscode").lazy_load()
    end
else
    snippet.expand = function(args) 
        vim.fn["vsnip#anonymous"](args.body)
    end
end

-- Improve backspace handling.
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end


--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

-- The rest of the file is a modified version of the recommended configuration,
-- see https://github.com/hrsh7th/nvim-cmp#recommended-configuration
local mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expandable() then
            luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif check_backspace() then
            fallback()
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, {
        "i",
        "s",
    }),
}

local name_to_menu = {
    luasnip = "[Snippet]",
    buffer = "[Buffer]",
    path = "[Path]",
}

local formatting = {
    fields = {"kind", "abbr", "menu"},
    format = function(entry, vim_item)
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        vim_item.menu = name_to_menu[entry.source.name]
        return vim_item
    end,
}

local sources = {
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
}

local confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
}

local experimental = {
    ghost_text = true,
    native_menu = false,
}

cmp.setup {
    snippet = snippet,
    mapping = mapping,
    formatting = formatting,
    sources = sources,
    confirm_opts = confirm_opts,
    documentation = true,
    experimental = experimental,
}

