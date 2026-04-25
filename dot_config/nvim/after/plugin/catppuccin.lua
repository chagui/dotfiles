local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
    return
end

catppuccin.setup({
    flavour = "macchiato",
    transparent_background = true,
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
