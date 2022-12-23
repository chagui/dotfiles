local lsp = require("lsp-zero")

-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
lsp.configure(
    "pyright",
    {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                }
            }
        }
    }
)
