-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- see: https://github.com/folke/neodev.nvim/blob/8fd21037453f4306f500e437c5cbdf6e8b6c2f99/README.md#-setup
local status_ok, neodev = pcall(require, "neodev")
if status_ok then
  neodev.setup {
    override = function(root_dir, library)
      library.enabled = true
      library.plugins = true
    end,
  }
end

local lsp = require("lsp-zero")

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
    "cmake",
    "dockerls",
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

lsp.setup()
