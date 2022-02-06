local utils = require "user.utils"
local globals = vim.g

-- remap leader
utils.map("<Space>", "<Nop>", opts)
globals.mapleader = " "
globals.maplocalleader = " "

-- Split navigation
utils.nnoremap("<C-h>", "<C-w>h")
utils.nnoremap("<C-j>", "<C-w>j")
utils.nnoremap("<C-k>", "<C-w>k")
utils.nnoremap("<C-l>", "<C-w>l")

-- Save with Ctrl + s
utils.nmap("<C-s>", "<Cmd>w<CR>")

-- Navigation hotkeys
utils.map("<C-p>", "<Cmd>Files<CR>")
utils.nmap("<leader>e", "<Cmd>Buffers<CR>")

-- Git hotkeys
utils.map("<C-g>f", "<Cmd>GFiles<CR>")

