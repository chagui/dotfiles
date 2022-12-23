require "user.bufferline"
require "user.lualine"

-- True Color (24-bit) configuration for alacritty + tmux
-- kudos to https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
vim.o.termguicolors = true

-- Setup colorscheme.
-- see https://github.com/Shatur/neovim-ayu
local status_ok, _ = pcall(require, "ayu")
if not status_ok then
  vim.notify("could not find ayu plugin")
else
  -- Note: when calling ayu.colorscheme() NvimTree and Lualine do not pick-up the theme..
  vim.cmd.colorscheme("ayu")
end
