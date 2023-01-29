return {
    "Shatur/neovim-ayu",
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
            -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
            "moll/vim-bbye",
        },
    },
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    "nvim-telescope/telescope.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    "akinsho/toggleterm.nvim",
}
