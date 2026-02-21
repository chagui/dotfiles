local profile = require("user.profile")

---@type LazySpec
return {
    {
        "nvim-telescope/telescope-media-files.nvim",
        cond = profile.active("default"),
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
        },
    },
}
