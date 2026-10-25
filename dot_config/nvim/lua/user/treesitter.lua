local M = {}

-- Shared by the nvim-treesitter spec and the headless install run by chezmoi
-- (run_onchange_after_40_install_nvim_plugins), which waits on it.
M.parsers = {
    "bash",
    "c",
    "cmake",
    "dockerfile",
    "dot",
    "go",
    "gotmpl",
    "hcl",
    "json",
    "lua",
    "make",
    "python",
    "rust",
    "terraform",
    "toml",
    "yaml",
}

return M
