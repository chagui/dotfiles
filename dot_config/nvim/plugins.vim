" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" helper function from: https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Plugins
call plug#begin('~/.vim/plugged')

" GUI enhancements
Plug 'ayu-theme/ayu-vim', Cond(!exists('g:vscode'))
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-highlightedyank'

" Projects
Plug 'airblade/vim-rooter'
Plug 'vim-scripts/localvimrc'

" Navigation
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'

call plug#end()

" Theme
if !exists('g:vscode')
    let ayucolor="dark"
    colorscheme ayu
endif

" lightline
set laststatus=2
set noshowmode
if !has('gui_running')
    set t_Co=256
endif
let g:lightline = { 'colorscheme': 'ayu_dark' }

" NERDTree
" ignore files
let NERDTreeIgnore=['\.pyc$', '\~$']
" todo
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let g:plug_window = 'noautocmd vertical topleft new'
" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
autocmd BufEnter * lcd %:p:h

