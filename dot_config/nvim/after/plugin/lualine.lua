-- Setup lualine.
-- see https://github.com/nvim-lualine/lualine.nvim
local lualine = require("lualine")

lualine.setup({
    options = {
        icons_enabled = true,
        theme = "ayu", -- automatically load the theme matching g:ayucolor
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = { "NvimTree", "toggleterm" },
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
            {
                "filename",
                path = 1,
                shorting_target = 40,
            },
        },
        lualine_w = {
            "diagnostics",
        },
        lualine_x = {
            "diagnostics",
            {
                "filetype",
                icon = { align = "right" },
            },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "fzf", "fugitive", "nvim-tree", "quickfix", "toggleterm" },
})
