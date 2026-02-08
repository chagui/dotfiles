local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
    return
end

configs.setup({
    ensure_installed = {
        "c",
        "cmake",
        "dockerfile",
        "dot",
        "go",
        "hcl",
        "lua",
        "make",
        "python",
        "rust",
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
