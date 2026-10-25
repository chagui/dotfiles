local profile = require("user.profile")

---@type LazySpec
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
    },
    {
        "akinsho/bufferline.nvim",
        cond = profile.active("default"),
        version = "v4.*",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
            -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
            "moll/vim-bbye",
        },
    },
    {
        "kyazdani42/nvim-tree.lua",
        cond = profile.active("default"),
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    {
        "nvim-telescope/telescope.nvim",
        cond = profile.active("default"),
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
    },
    {
        "nvim-telescope/telescope-media-files.nvim",
        -- Linux only (after/plugin/telescope.lua loads the extension there).
        -- Gated with cond rather than an OS-specific spec file so lazy keeps
        -- its lockfile entry on macOS instead of dropping it.
        cond = profile.active("default") and vim.fn.has("linux") == 1,
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        cond = profile.active("default"),
        config = function()
            require("telescope").load_extension("frecency")
        end,
        dependencies = { "kkharji/sqlite.lua" },
    },
    { "nvim-lualine/lualine.nvim" },
    { "akinsho/toggleterm.nvim", cond = profile.active("default") },
}
