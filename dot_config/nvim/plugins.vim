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

