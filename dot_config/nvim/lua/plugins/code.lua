return {
    "windwp/nvim-autopairs",
    "folke/neodev.nvim",

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- LSP
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- Core
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason-lspconfig.nvim" },
            { "williamboman/mason.nvim" },

            -- Completion
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            { "saadparwaiz1/cmp_luasnip", dependencies = "LuaSnip" },
        },
    },
}
