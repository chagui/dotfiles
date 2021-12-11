syntax on

set ttyfast
set showmode showcmd

" Tab sanity
set expandtab
set shiftwidth=4 softtabstop=4
set smartindent autoindent

" Navigation
set title
set number relativenumber
set mouse=a
" Always use the clipboard for all operations instead of interacting with
" registers
set clipboard+=unnamedplus

" Search
set ignorecase smartcase
set hlsearch incsearch

" History
set undodir=~/.cache/vimdid
set undofile

autocmd BufNewFile,BufRead .bash_personal set syntax=sh
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType make setlocal noexpandtab

