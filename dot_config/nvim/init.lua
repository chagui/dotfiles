require "user.autopairs"
require "user.completion"
require "user.keymaps"
require "user.lsp"
require "user.options"
require "user.plugins"
require "user.telescope"
require "user.toggleterm"
require "user.treesitter"

local utils = require("user.utils")

-- When running in VSCode an extension takes care of the theme.
if not utils.is_vscode() then
    require "user.tui"
end

-- automatically hide and show the command line
vim.o.ch = 0

-- Run `chezmoi apply` whenever its configuration is modified.
vim.cmd('autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"')

-- Python
vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/nvim/bin/python3"

-- Files to ignore
-- Python
vim.opt.wildignore:append("*.pyc,*.pyo,*/__pycache__/*")
-- Temp files
vim.opt.wildignore:append("*.swp,~*")
-- Archives
vim.opt.wildignore:append("*.zip,*.tar")

-- Use ripgrep when available
vim.cmd([[
    if executable('rg')
        set grepprg=rg\ --no-heading\ --vimgrep
        set grepformat=%f:%l:%c:%m
    endif
]])

-- Handle chezmoi name convention
-- todo: use lua autocmd
vim.cmd([[
    au BufNewFile,BufRead dot_zshrc,dot_zshrc.tmpl,dot_aliases,dot_functions set filetype=zsh
    au BufNewFile,BufRead *.lua.tmpl set filetype=lua
]])
