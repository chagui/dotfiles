syntax on

set expandtab
set shiftwidth=4 softtabstop=4
set smartindent autoindent
set number relativenumber
set ignorecase smartcase
set hlsearch incsearch

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'doums/darcula'
call plug#end()

colorscheme darcula

autocmd BufNewFile,BufRead .bash_personal set syntax=sh
autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2
