local utils = require "user.utils"
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
utils.nmap("<A-left>", "<Cmd>bprev<CR>")
utils.nmap("<A-right>", "<Cmd>bnext<CR>")
utils.nmap("<leader>e", "<Cmd>Buffers<CR>")  -- list buffers

-- Save with Ctrl + s
utils.nmap("<C-s>", "<Cmd>w<CR>")

-- Navigation hotkeys
utils.nmap("<C-c>", "<Cmd>q<CR>")
utils.nmap("<C-q>", "<Cmd>q!<CR>")
utils.inoremap("<Caps_Lock>", "<Esc>")
utils.inoremap("jk", "<Esc>")
utils.inoremap("kj", "<Esc>")

-- Move line up / down
utils.nmap("J", "<Cmd>move .+1<CR>==")
utils.nmap("K", "<Cmd>move .-2<CR>==")

-- Git hotkeys
utils.map("<C-g>f", "<Cmd>GFiles<CR>")

-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
utils.nmap("<leader>p", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>")
utils.nmap("<leader>f", "<cmd>Telescope live_grep<cr>")
utils.nnoremap("<leader>b", "<cmd>Telescope buffers<cr>")

-- nvim-tree
utils.nnoremap("<leader>e", "<cmd>NvimTreeToggle<cr>")
