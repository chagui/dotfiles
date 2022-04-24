local success, configs = pcall(require, "nvim-treesitter.configs")
if not success then
    vim.notify("could not find nvim-treesitter.configs module, abort nvim-treesitter.configs configuration")
    return
end

configs.setup {
    ensure_installed = { "c", "lua", "go", "make", "python", "rust" },
    sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
}

