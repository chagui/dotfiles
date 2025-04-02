return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            flavor = "macchiato",
            integrations = {
                cmp = true,
                flash = true,
                fzf = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
            },
        },
        -- https://lazy.folke.io/spec/lazy_loading#-colorschemes
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "v4.*",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
            -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
            "moll/vim-bbye",
        },
        opts = {
            options = {
                close_command = "bdelete! %d",
                right_mouse_command = "bdelete! %d",
                left_mouse_command = "buffer %d",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = " פּ   Nvim Tree",
                        text_align = "left",
                        padding = 1,
                    },
                },
            },
        },
    },
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            require("telescope").load_extension("frecency")
        end,
        dependencies = { "kkharji/sqlite.lua" },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    "akinsho/toggleterm.nvim",
}
