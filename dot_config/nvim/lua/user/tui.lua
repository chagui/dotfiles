local utils = require("user.utils")

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

utils.set_options({
    ttyfast = true,
    showmode = true,
    showcmd = true,

    -- Tab sanity
    expandtab = true,
    shiftwidth = 4,
    softtabstop = 4,
    smartindent = true,
    autoindent = true,

    -- Navigation
    title = true,
    number = true,
    relativenumber = true,
    mouse = "a",
    cursorline = true,
    scrolloff = 5,

    -- History
    undodir = vim.fn.stdpath("cache") .. "/undo",
    undofile = true,
})
