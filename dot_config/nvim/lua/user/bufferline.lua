-- Setup bufferline.
-- see https://github.com/akinsho/bufferline.nvim

local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  vim.api.nvim_notify("could not find bufferline plugin", vim.log.levels.WARN, {})
  return
end

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

