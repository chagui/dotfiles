local success, _ = pcall(require, "lspconfig")
if not success then
    vim.notify("could not find lspconfig module, abort lsp configuration")
    return
end

require("user.lsp.lsp-installer")
