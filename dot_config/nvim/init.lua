require "user.completion"
require "user.keymaps"
require "user.options"
require "user.plugin_manager"

local utils = require("user.utils")


-- When running in VSCode an extension takes care of the theme.
if not utils.is_vscode() then
    require "user.tui"
end

-- automatically hide and show the command line
vim.o.ch = 0

-- Run `chezmoi apply` whenever its configuration is modified.
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
        command = "silent! !chezmoi apply --no-tty --force --source-path '%'",
    }
)

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
if vim.fn.executable("rg") == 1 then
    vim.o.grepprg = "rg --no-heading --vimgrep"
    vim.o.grepformat = "f:%l:%c:%m"
end

