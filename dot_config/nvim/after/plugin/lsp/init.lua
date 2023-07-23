-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- see: https://github.com/folke/neodev.nvim/blob/8fd21037453f4306f500e437c5cbdf6e8b6c2f99/README.md#-setup
local status_ok, neodev = pcall(require, "neodev")
if status_ok then
    neodev.setup({
        override = function(_, library)
            library.enabled = true
            library.plugins = true
        end,
    })
end

local lsp = require("lsp-zero").preset({})

lsp.set_preferences({
    suggest_lsp_servers = false,
    setup_servers_on_start = true,
    set_lsp_keymaps = true,
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    call_servers = "local",
    sign_icons = {
        error = "",
        warn = "",
        hint = "",
        info = "",
    },
})

-- Create the keybindings bound to built-in LSP functions.
lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
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

-- Ensure the servers above are installed
lsp.ensure_installed(vim.tbl_keys(servers))

local lspconfig = require("lspconfig")
for server, config in pairs(servers) do
    lspconfig[server].setup(config)
end

local custom_group = vim.api.nvim_create_augroup("UserFormatBufWritePre", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    group = custom_group,
    pattern = { "*.tf", "*.tfvars" },
    callback = vim.lsp.buf.format,
})

lsp.nvim_workspace()

lsp.setup()

vim.opt.signcolumn = "yes"
-- needs to be after lsp.setup()
vim.diagnostic.config({
    virtual_text = true,
})
