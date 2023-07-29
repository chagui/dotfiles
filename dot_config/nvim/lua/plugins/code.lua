return {
    { "windwp/nvim-autopairs", event = "InsertEnter" },
    "folke/neodev.nvim",

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },

    -- LSP
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- Core
            { "neovim/nvim-lspconfig" },
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.api.nvim_command, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" },

            -- Completion
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/nvim-cmp" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            { "saadparwaiz1/cmp_luasnip", dependencies = "L3MON4D3/LuaSnip" },
        },
    },
}
