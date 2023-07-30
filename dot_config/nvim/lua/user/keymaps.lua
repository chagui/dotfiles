local utils = require("user.utils")
local globals = vim.g

-- remap leader
utils.noremap("<Space>", "<Nop>")
globals.mapleader = " "
globals.maplocalleader = " "

-- Split navigation
utils.nnoremap("<C-h>", "<C-w>h")
utils.nnoremap("<C-j>", "<C-w>j")
utils.nnoremap("<C-k>", "<C-w>k")
utils.nnoremap("<C-l>", "<C-w>l")

-- Resize splits
utils.nnoremap("<C-S-left>", "<Cmd>vertical resize -2<CR>")
utils.nnoremap("<C-S-down>", "<Cmd>resize -2<CR>")
utils.nnoremap("<C-S-up>", "<Cmd>resize +2<CR>")
utils.nnoremap("<C-S-right>", "<Cmd>vertical resize +2<CR>")

-- Buffer navigation
utils.nmap("<S-h>", "<Cmd>bprevious<CR>")
utils.nmap("<S-l>", "<Cmd>bnext<CR>")
utils.nmap("<leader>e", "<Cmd>Buffers<CR>") -- list buffers

-- Save with Ctrl + s
utils.nmap("<C-s>", "<Cmd>w<CR>")

-- Navigation hotkeys
utils.nmap("<C-c>", "<Cmd>q<CR>")
utils.nmap("<C-q>", "<Cmd>q!<CR>")
utils.inoremap("<Caps_Lock>", "<Esc>")
utils.inoremap("jk", "<Esc>")
utils.inoremap("kj", "<Esc>")

-- Move line up / down
-- https://stackoverflow.com/questions/5379837/is-it-possible-to-mapping-alt-hjkl-in-insert-mode ¯\_(ツ)_/¯
utils.nmap("∆", "<Cmd>move .+1<CR>==")
utils.nmap("˚", "<Cmd>move .-2<CR>==")

-- Git hotkeys
utils.map("<C-g>f", "<Cmd>GFiles<CR>")
