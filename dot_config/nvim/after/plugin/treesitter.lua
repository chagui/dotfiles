local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
    return
end

configs.setup({
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "dockerfile",
        "dot",
        "go",
        "hcl",
        "json",
        "lua",
        "make",
        "python",
        "rust",
        "terraform",
        "toml",
        "yaml",
    },
    sync_install = false,
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
})
