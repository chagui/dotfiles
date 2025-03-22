local augroups = require("user.augroups")
local lazy = require("lazy")

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
