set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath


" Load extra configurations
let g:config_file_list = ['bindings.vim', 'plugins.vim']
let g:nvim_config_root = expand('<sfile>:p:h')
for s:fname in g:config_file_list
  execute printf('source %s/%s', g:nvim_config_root, s:fname)
endfor

if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" Files to ignore
" Python
set wildignore+=*.pyc,*.pyo,*/__pycache__/*
" Temp files
set wildignore+=*.swp,~*
" Archives
set wildignore+=*.zip,*.tar

" lua adapter until migration is complete
lua <<EOF
require "user.options"
-- todo: vscode switch
require "user.tui"
EOF

