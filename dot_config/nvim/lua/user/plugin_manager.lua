-- Install lazy.nvim if not found
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "gh:folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if status_ok then
    lazy.setup("plugins", {
        lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
    })
    local augroups = require("user.augroups")

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = augroups.lazy,
        pattern = {
            vim.fn.expand("~") .. "/.local/share/chezmoi/dot_config/nvim/lua/plugins/*",
            vim.fn.expand("~") .. "/.local/share/chezmoi/dot_config/nvim/lua/user/plugin_manager.lua",
        },
        callback = function()
            lazy.sync()
        end,
    })
end

return lazy
