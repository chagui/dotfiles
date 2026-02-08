local profile = require("user.profile")

---@type LazySpec
return {
    "folke/lazy.nvim",
    { "tpope/vim-fugitive", cond = profile.active("default") },

    {
        "junegunn/fzf",
        cond = profile.active("default"),
        build = function()
            vim.fn["fzf#install"]()
        end,
        name = "fzf",
        dependencies = { "junegunn/fzf.vim" },
    },

    -- Projects
    { "airblade/vim-rooter", cond = profile.active("default") },
    { "vim-scripts/localvimrc", cond = profile.active("default") },
}
