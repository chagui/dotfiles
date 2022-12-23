-- Setup bufferline.
-- see https://github.com/akinsho/bufferline.nvim
local bufferline = require("bufferline")

-- Note: termguicolors option is set in user.tui module
bufferline.setup {
    options = {
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        left_mouse_command = "buffer %d",
        offsets = {
            {
                filetype = "NvimTree",
                text = " פּ   Nvim Tree",
                text_align = "left",
                padding = 1,
            }
        },
    },
}
