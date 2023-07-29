-- True Color (24-bit) configuration for alacritty + tmux
-- kudos to https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
vim.o.termguicolors = true

vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})

local augroups = require("user.augroups")
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight on yank",
    group = augroups.visual,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 400 })
    end,
})
