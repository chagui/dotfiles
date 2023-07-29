local M = {}

local augroup = function(name)
    vim.api.nvim_create_augroup(name, { clear = true })
end

M.chezmoi = augroup("UserChezmoi")
M.filetype = augroup("UserFileType")
M.lazy = augroup("UserLazyPlugin")
M.lsp = augroup("UserFormatBufWritePre")
M.toggle_term = augroup("UserToggleTerm")
M.visual = augroup("UserVisual")

return M
