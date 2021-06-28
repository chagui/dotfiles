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


" Plugins
call plug#begin('~/.vim/plugged')

" GUI enhancements
Plug 'ayu-theme/ayu-vim'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'

" Projects
Plug 'airblade/vim-rooter'
Plug 'vim-scripts/localvimrc'

" Navigation
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Theme
let ayucolor="dark"
colorscheme ayu

" lightline
set laststatus=2
set noshowmode
if !has('gui_running')
    set t_Co=256
endif
let g:lightline = { 'colorscheme': 'ayu_dark' }

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

