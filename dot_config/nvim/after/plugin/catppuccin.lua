local ok, catppuccin = pcall(require, "catppuccin")
if not ok then
    return
end

catppuccin.setup({
    flavour = "macchiato",
    transparent_background = true,
    -- Default LineNr (overlay0) washes out against the transparent background.
    custom_highlights = function(colors)
        return {
            LineNr = { fg = colors.overlay2 },
            CursorLineNr = { fg = colors.peach, bold = true },
        }
    end,
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
