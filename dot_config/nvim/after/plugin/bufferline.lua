-- Setup bufferline.
-- see https://github.com/akinsho/bufferline.nvim
local ok, bufferline = pcall(require, "bufferline")
if not ok then
    return
end

-- Note: termguicolors option is set in user.tui module
bufferline.setup({
    options = {
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        offsets = {
            {
                filetype = "NvimTree",
                text = " פּ   Nvim Tree",
                text_align = "left",
                padding = 1,
            },
        },
    },
})
