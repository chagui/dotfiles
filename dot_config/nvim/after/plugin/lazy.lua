local lazy = require("lazy")

local user_command_group = vim.api.nvim_create_augroup("UserCommandsLazyPlugin", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = user_command_group,
    pattern = {
        vim.fn.expand("~") .. "/.local/share/chezmoi/dot_config/nvim/lua/plugins/*",
        vim.fn.expand("~") .. "/.local/share/chezmoi/dot_config/nvim/lua/user/plugin_manager.lua",
    },
    callback = function()
        lazy.sync()
    end,
})
