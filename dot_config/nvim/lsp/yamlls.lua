-- https://github.com/redhat-developer/yaml-language-server
---@type vim.lsp.Config
return {
    settings = {
        yaml = {
            schemaStore = {
                url = "https://www.schemastore.org/api/json/catalog.json",
                enable = true,
            },
            style = {
                flowSequence = "allow",
            },
            keyOrdering = false,
        },
    },
}
