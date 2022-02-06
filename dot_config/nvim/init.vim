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
require "user.keymaps"
require "user.plugins"

-- todo: vscode switch
require "user.tui"
EOF

