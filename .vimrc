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
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype json setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType make setlocal noexpandtab

" Files to ignore
" Python
set wildignore+=*.pyc,*.pyo,*/__pycache__/*
" Temp files
set wildignore+=*.swp,~*
" Archives
set wildignore+=*.zip,*.tar
