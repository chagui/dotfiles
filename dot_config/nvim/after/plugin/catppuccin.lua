local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
    return
end

catppuccin.setup({
    flavor = "macchiato",
    integrations = {
        cmp = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        mason = true,
        nvimtree = true,
        treesitter = true,
    },
})
vim.cmd.colorscheme("catppuccin")
