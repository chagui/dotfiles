require("catppuccin").setup({
    flavor = "macchiato",
    integrations = {
        cmp = true,
        fzf = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
    },
})
vim.cmd.colorscheme("catppuccin")
