local utils = require("user.utils")

local globals = vim.g

-- remap leader
utils.noremap("<Space>", "<Nop>")
globals.mapleader = " "
globals.maplocalleader = " "

-- Save with leader s
utils.nmap("<leader>s", "<Cmd>w<CR>")

-- preserve the unnamed register (changed to clipboard above) by default
utils.vmap("p", "P")
