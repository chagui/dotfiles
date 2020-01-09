syntax on
set expandtab
set shiftwidth=4
set smartindent
set autoindent
set number relativenumber
set nu rnu
set hlsearch

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'doums/darcula'
call plug#end()

colorscheme darcula

autocmd BufNewFile,BufRead .bash_personal set syntax=sh

