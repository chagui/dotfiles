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
require "user.completion"

local utils = require("user.utils")

-- VSCode managed its own theme
if not utils.is_vscode() then
    local success, _ = pcall(vim.cmd, [[
        let ayucolor="dark"
        colorscheme ayu
    ]])
    if not success then
        vim.notify("could not set ayu colorscheme!")
    end

    require "user.tui"
end

-- Run `chezmoi apply` whenever its configuration is modified.
vim.cmd('autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"')
EOF

