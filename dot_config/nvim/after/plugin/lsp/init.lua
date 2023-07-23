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

vim.opt.signcolumn = "yes"

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

-- Language servers configuration
local servers = {
    bashls = {},
    clangd = {},
    cmake = {},
    dockerls = {},
    gopls = {},
    jsonls = {},
    lua_ls = {},
    ruff_lsp = {},
    rust_analyzer = {},
    taplo = {},
    terraformls = {},
    yamlls = {},
}

-- Ensure the servers above are installed
lsp.ensure_installed(vim.tbl_keys(servers))

lsp.nvim_workspace()

lsp.setup()

-- needs to be after lsp.setup()
vim.diagnostic.config({
    virtual_text = true,
})
