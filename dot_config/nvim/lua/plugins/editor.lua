local profile = require("user.profile")

---@type LazySpec
return {
    {
        "lewis6991/gitsigns.nvim",
        cond = profile.active("default"),
        dependencies = { "nvim-lua/plenary.nvim" },
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
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
            { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
            { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
        },
        cond = profile.active("editor"),
        opts = {
            enhanced_diff_hl = true,
            view = {
                merge_tool = {
                    layout = "diff3_horizontal",
                },
            },
        },
    },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        event = "BufReadPre",
        cond = profile.active("editor"),
        opts = {
            default_mappings = {
                ours = "co",
                theirs = "ct",
                none = "c0",
                both = "cb",
                next = "]x",
                prev = "[x",
            },
            disable_diagnostics = true,
        },
        config = function(_, opts)
            require("git-conflict").setup(opts)
            -- cl/cr aliases use LOCAL/REMOTE labels from conflict markers, which
            -- stay correct during both merge and rebase (ours/theirs swap on rebase).
            vim.keymap.set("n", "cl", "<Plug>(git-conflict-ours)", { desc = "Choose local (ours)" })
            vim.keymap.set("n", "cr", "<Plug>(git-conflict-theirs)", { desc = "Choose remote (theirs)" })
        end,
    },
}
