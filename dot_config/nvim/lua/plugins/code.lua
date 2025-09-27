---@type LazySpec
return {
    { "windwp/nvim-autopairs", event = "InsertEnter" },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            -- It can also be a table with trigger words / mods
            -- Only load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            -- Only load the lazyvim library when the `LazyVim` global is found
            { path = "LazyVim", words = { "LazyVim" } },
        },
    },

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
