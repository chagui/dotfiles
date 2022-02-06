local utils = require "user.utils"

-- aliases
local globals = vim.g

-- remap leader
utils.map("<Space>", "<Nop>", opts)
globals.mapleader = " "
globals.maplocalleader = " "

-- Split navigation
utils.nmap("<C-h>", "<C-w>h")
utils.nmap("<C-j>", "<C-w>j")
utils.nmap("<C-k>", "<C-w>k")
utils.nmap("<C-l>", "<C-w>l")

-- map <C-s> :w<CR>
-- Navigation hotkeys
-- map <C-p> :Files<CR>
-- nmap <leader>; :Buffers<CR>

-- Git hotkeys
-- map <C-g>f :GFiles<CR>

