-- tip: use vim.inspect to know what's inside a variable, e.g. print(vim.inspect(opts.<option>))
local opts = vim.opt

opts.syntax = "on"

opts.ttyfast = true
opts.showmode = true
opts.showcmd = true

-- Tab sanity
opts.expandtab = true
opts.shiftwidth=4
opts.softtabstop=4
opts.smartindent = true
opts.autoindent = true

-- Navigation
opts.title = true
opts.number = true
opts.relativenumber = true
opts.mouse = "a"
opts.cursorline = true
-- Always use the clipboard for all operations instead of interacting with
-- registers
opts.clipboard = "unnamedplus"

-- Search
opts.ignorecase = true
opts.smartcase = true
opts.hlsearch = true
opts.incsearch = true

-- History
opts.undodir = "~/.cache/vimdid"
opts.undofile = true

-- File type based rules
local cmd = vim.cmd
cmd([[
  autocmd BufNewFile,BufRead .bash_personal set syntax=sh
  autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType make setlocal noexpandtab
]])
