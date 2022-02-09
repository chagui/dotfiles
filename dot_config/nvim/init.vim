if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" lua adapter until migration is complete
lua <<EOF
require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.completion"

local utils = require("user.utils")

-- When running in VSCode an extension takes care of the theme.
if not utils.is_vscode() then
    require "user.tui"
end

-- Run `chezmoi apply` whenever its configuration is modified.
vim.cmd('autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"')

-- Files to ignore
-- Python
vim.opt.wildignore:append("*.pyc,*.pyo,*/__pycache__/*")
-- Temp files
vim.opt.wildignore:append("*.swp,~*")
-- Archives
vim.opt.wildignore:append("*.zip,*.tar")
EOF

