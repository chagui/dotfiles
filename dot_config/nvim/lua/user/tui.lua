-- True Color (24-bit) configuration for alacritty + tmux
-- kudos to https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
vim.o.termguicolors = true

local success, _ = pcall(vim.cmd, [[
    let ayucolor="dark"
    colorscheme ayu
]])
if not success then
    vim.notify("could not set ayu colorscheme!")
end
