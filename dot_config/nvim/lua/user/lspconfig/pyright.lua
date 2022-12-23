-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
return {
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
