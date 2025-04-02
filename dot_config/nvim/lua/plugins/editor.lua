return {
    "psliwka/vim-smoothie",
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            current_line_blame = true,
            current_line_blame_opts = {
                ignore_whitespace = true,
            },
        },
    },
    -- Flash enhances the built-in search functionality by showing labels
    -- at the end of each match, letting you quickly jump to a specific
    -- location.
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },
}
