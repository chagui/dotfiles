local lsp = require("lsp-zero")

lsp.configure(
    "sumneko_lua",
    {
        settings = {
            Lua = {
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
            },
        }
    }
)
