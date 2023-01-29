return {
    "machakann/vim-highlightedyank",
    "psliwka/vim-smoothie",
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function() require("gitsigns").setup() end,
    },
    "justinmk/vim-sneak",
}

