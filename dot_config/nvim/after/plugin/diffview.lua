local ok, _ = pcall(require, "diffview")
if not ok then
    return
end

local profile = require("user.profile")
local utils = require("user.utils")

-- In editor profile (no nvim-tree), bind <leader>e to diffview's file panel.
if not profile.active("default") then
    utils.nnoremap("<leader>e", function()
        local lib = require("diffview.lib")
        if lib.get_current_view() then
            require("diffview.actions").toggle_files()
        end
    end)
end
