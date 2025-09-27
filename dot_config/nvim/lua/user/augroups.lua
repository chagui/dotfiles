local M = {}

local augroup = function(name)
    vim.api.nvim_create_augroup(name, { clear = true })
end

M.chezmoi = augroup("user.chezmoi")
M.filetype = augroup("user.filetype")
M.lazy = augroup("user.lazy")
M.lsp = augroup("user.lsp")
M.toggle_term = augroup("user.terminal")
M.visual = augroup("user.visual")

return M
