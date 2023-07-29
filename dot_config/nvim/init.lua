vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("user.keymaps")
require("user.options")
require("user.plugin_manager")

local utils = require("user.utils")

-- When running in VSCode an extension takes care of the theme.
if not utils.is_vscode() then
    require("user.tui")
end

-- automatically hide and show the command line
vim.o.ch = 0

-- Run `chezmoi apply` whenever its configuration is modified.
local augroups = require("user.augroups")
vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroups.chezmoi,
    pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
    command = "silent! !chezmoi apply --no-tty --force --source-path '%'",
})

-- Python
vim.g.python3_host_prog = os.getenv("XDG_DATA_HOME") .. "/pyenv/versions/3.9.9/envs/nvim/bin/python3"

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
