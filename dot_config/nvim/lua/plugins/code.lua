return {
    { "windwp/nvim-autopairs", event = "InsertEnter" },
    "folke/neodev.nvim",

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },

    -- LSP
    {
        "mason-org/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            ensure_installed = {
                "bashls",
                "clangd",
                "cmake",
                "dockerls",
                "gitlab_ci_ls",
                "jsonls",
                "gopls",
                "lua_ls",
                "ruff",
                "rust_analyzer",
                "starpls",
                "taplo",
                "terraformls",
                "yamlls",
            },
            automatic_enable = true,
        },
        dependencies = {
            {
                "mason-org/mason.nvim",
                build = function()
                    pcall(vim.api.nvim_command, "MasonUpdate")
                end,
                opts = {},
                keys = {
                    { "<leader>mm", "<Cmd>Mason<CR>", desc = "Packages" },
                },
            },
            "neovim/nvim-lspconfig",
        },
    },
}
