-- True Color (24-bit) configuration for alacritty + tmux
-- kudos to https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
vim.o.termguicolors = true

vim.api.nvim_create_user_command("ReloadConfig", "source $MYVIMRC", {})

local autocmd = vim.api.nvim_create_autocmd
local augroups = require("user.augroups")
autocmd("TextYankPost", {
    desc = "Highlight on yank",
    group = augroups.visual,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 400 })
    end,
})

autocmd({ "VimResized" }, {
    desc = "Resize splits when window is resized",
    group = augroups.visual,
    callback = function()
        vim.cmd("wincmd =")
        vim.cmd("tabdo wincmd =")
    end,
})

autocmd("FileType", {
    desc = "Close with q",
    group = augroups.visual,
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query", -- :InspectTree
        "spectre_panel",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set(
            "n",
            "q",
            "<cmd>close<cr>",
            { buffer = event.buf, desc = "Close some filetype windows with <q>" }
        )
    end,
})
