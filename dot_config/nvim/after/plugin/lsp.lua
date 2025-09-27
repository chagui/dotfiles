-- todo: migrate to https://github.com/folke/lazydev.nvim
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- see: https://github.com/folke/neodev.nvim/blob/8fd21037453f4306f500e437c5cbdf6e8b6c2f99/README.md#-setup
local status_ok, neodev = pcall(require, "neodev")
if status_ok then
    neodev.setup()
end

-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#minimal
local lsp = require("lsp-zero").preset({ name = "minimal" })

lsp.set_sign_icons({
    error = "✘",
    warn = "",
    hint = "",
    info = "",
})

-- Create the keybindings bound to built-in LSP functions.
lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({
        buffer = bufnr,
        preserve_mappings = false,
        omit = {
            -- Omit unwanted default keymaps
            "<F3>", -- Format buffer
            "K", -- Hover
        },
    })

    vim.keymap.set("n", "<leader>fb", vim.lsp.buf.format, { buffer = true, desc = "[F]ormat [B]uffer" })
    vim.keymap.set(
        "n",
        "K",
        vim.lsp.buf.hover,
        { buffer = true, desc = "Displays hover information about the symbol under the cursor" }
    )
end)

-- Language servers configuration
local servers = {
    bashls = {},
    clangd = {},
    cmake = {},
    dockerls = {},
    gopls = {
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
            },
        },
        init_options = {
            usePlaceholders = true,
        },
    },
    jsonls = {
        settings = {
            json = {
                -- todo: migrate to https://github.com/b0o/schemastore.nvim
                -- schemas = schemas,
            },
        },
        setup = {
            commands = {
                Format = {
                    function()
                        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
                    end,
                },
            },
        },
    },
    lua_ls = {},
    ruff_lsp = {},
    rust_analyzer = {},
    -- https://github.com/withered-magic/starpls
    starpls = {},
    taplo = {},
    -- https://github.com/hashicorp/terraform-ls
    terraformls = {},
    -- https://github.com/redhat-developer/yaml-language-server
    yamlls = {
        settings = {
            yaml = {
                schemaStore = {
                    url = "https://www.schemastore.org/api/json/catalog.json",
                    enable = true,
                },
                style = {
                    flowSequence = "allow",
                },
                keyOrdering = false,
            },
        },
    },
}

require("mason").setup()
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
-- Ensure the servers above are installed
mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
        function(server_name)
            lspconfig[server_name].setup(servers[server_name] or {})
        end,
    },
})

local augroups = require("user.augroups")
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroups.lsp,
    -- todo: use file types? pattern = { "terraform", "go" },
    pattern = { "*.tf", "*.tfvars" },
    callback = vim.lsp.buf.format,
})

-- Configure lua language server for neovim
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- Completion
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
local window_config = cmp.config.window.bordered()
window_config.max_width = 120
window_config.max_height = 100

cmp.setup({
    sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "luasnip" },
    },
    mapping = {
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select_opts),
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select_opts),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- Super Tab
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
    },
    window = {
        completion = window_config,
        documentation = window_config,
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = require("lspkind").cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
        }),
    },
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "buffer" },
        { name = "cmdline_history" },
    }),
    window = {
        completion = window_config,
        documentation = window_config,
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline" },
        { name = "cmdline_history" },
    }),
    window = {
        completion = window_config,
        documentation = window_config,
    },
})

-- Insert `(` after select function or method item.
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Diagnostics
vim.opt.signcolumn = "yes"
-- needs to be after lsp.setup()
vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    underline = false,
    float = {
        border = "rounded",
        source = "if_many",
    },
})
