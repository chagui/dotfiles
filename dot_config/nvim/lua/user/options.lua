local utils = require("user.utils")

utils.set_options({
    syntax = "on",

    -- Always use the clipboard for all operations instead of interacting with
    -- registers
    clipboard = "unnamedplus",

    -- Search
    ignorecase = true,
    smartcase = true,
    hlsearch = true,
    incsearch = true,
})
