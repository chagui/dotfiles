local configs = require("nvim-treesitter.configs")

configs.setup {
    ensure_installed = { "c", "lua", "go", "hcl", "make", "python", "rust" },
    sync_install = false,
    autopairs = {
        enable = true
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
}
