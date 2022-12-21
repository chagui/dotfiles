local success, lsp = pcall(require, "lsp-zero")
if not success then
    vim.notify("could not find lsp-zero module, abort lsp configuration")
    return
end

vim.opt.signcolumn = 'yes'
vim.diagnostic.config({
    virtual_text = true,
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    setup_servers_on_start = true,
    set_lsp_keymaps = true,
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    call_servers = 'local',
    sign_icons = {
        error = "",
        warn = "",
        hint = "",
        info = ""
    }
})

lsp.ensure_installed({
    "bashls",
    "gopls",
    "jsonls",
    "pyright",
    "taplo",
    "terraformls",
    "yamlls",
    "rust_analyzer",
    "sumneko_lua",
})

lsp.nvim_workspace()

local server_configs = {
    "jsonls",
    "pyright",
    "sumneko_lua",
}
for _, server in ipairs(server_configs) do
    local config = require(string.format("user.lspconfig.%s", server))
    lsp.configure(server, config)
end

lsp.setup()
