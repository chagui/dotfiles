-- todo: migrate to https://github.com/folke/lazydev.nvim
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- see: https://github.com/folke/neodev.nvim/blob/8fd21037453f4306f500e437c5cbdf6e8b6c2f99/README.md#-setup
local status_ok, neodev = pcall(require, "neodev")
if status_ok then
    neodev.setup()
end
