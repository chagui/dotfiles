-- https://cmp.saghen.dev/installation.html#merging-lsp-capabilities
local ok, blink = pcall(require, "blink.cmp")
if not ok then
    return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities({}, false))

capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = {
        foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        },
    },
})

vim.lsp.config("*", { capabilities = capabilities })
