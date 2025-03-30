local utils = require("user.utils")

utils.set_options({
    syntax = "on",

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
    -- Always use the clipboard for all operations instead of interacting with
    -- registers
    clipboard = "unnamedplus",

    -- Search
    ignorecase = true,
    smartcase = true,
    hlsearch = true,
    incsearch = true,

    -- History
    undodir = vim.fn.stdpath("cache") .. "/undo",
    undofile = true,
})
