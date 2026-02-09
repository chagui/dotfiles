require("user.options")

-- When running in VSCode, avoid plugins that duplicate VSCode features
-- (highlighting, completion, LSP, file explorers, fuzzy finders).
-- Use VSCode's built-in line numbers, indent guides and bracket highlighting
-- instead of plugins. Navigation, text object and editing plugins are fine.
-- This prevents cursor jitter and performance issues.
-- https://github.com/vscode-neovim/vscode-neovim#performance
if vim.g.vscode then
    -- todo
else
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("user.keymaps")
    require("user.tui")
    require("user.plugin_manager")
    require("user.lsp")

    -- automatically hide and show the command line
    vim.o.ch = 0

    -- Run `chezmoi apply` whenever its configuration is modified.
    local augroups = require("user.augroups")
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = augroups.chezmoi,
        pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
        command = "silent! !chezmoi apply --no-tty --force --source-path '%'",
    })

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
        vim.o.grepformat = "%f:%l:%c:%m"
    end
end

-- Moving the cursor after a search clears the highlights (same Ctrl+L)
vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
    callback = function()
        if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
            vim.schedule(function()
                vim.cmd.nohlsearch()
            end)
        end
    end,
})
