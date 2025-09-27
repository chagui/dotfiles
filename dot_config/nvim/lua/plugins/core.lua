---@type LazySpec
return {
    "folke/lazy.nvim",
    "tpope/vim-fugitive",

    {
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end,
        name = "fzf",
        dependencies = { "junegunn/fzf.vim" },
    },

    -- Projects
    "airblade/vim-rooter",
    "vim-scripts/localvimrc",
}
