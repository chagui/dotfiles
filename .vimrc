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

" Search
set ignorecase smartcase
set hlsearch incsearch

" History
set undodir=~/.cache/vimdid
set undofile


" Plugins
call plug#begin('~/.vim/plugged')

" GUI enhancements
Plug 'ayu-theme/ayu-vim'

" Navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Theme
let ayucolor="dark"
colorscheme ayu

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

if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

