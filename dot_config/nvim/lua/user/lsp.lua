vim.opt.signcolumn = "yes"
vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
    },
    virtual_text = {
        current_line = false,
    },
    severity_sort = true,
    underline = false,
    float = {
        border = "rounded",
        source = "if_many",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = "WarningMsg",
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
        },
    },
})

local augroups = require("user.augroups")

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroups.lsp,
    -- todo: use file types? pattern = { "terraform", "go" },
    pattern = { "*.tf", "*.tfvars" },
    callback = vim.lsp.buf.format,
})

local utils = require("user.utils")
-- https://neovim.io/doc/user/lsp.html#lsp-attach
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroups.lsp,
    callback = function(attach)
        utils.nmap("<leader>fb", vim.lsp.buf.format, { buffer = true, desc = "[F]ormat [B]uffer" })

        local client = assert(vim.lsp.get_client_by_id(attach.data.client_id))
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            -- When cursor stops moving: Highlights all instances of the symbol under the cursor
            -- When cursor moves: Clears the highlighting
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = attach.buf,
                group = augroups.lsp,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = attach.buf,
                group = augroups.lsp,
                callback = vim.lsp.buf.clear_references,
            })

            -- When LSP detaches: Clears the highlighting
            vim.api.nvim_create_autocmd("LspDetach", {
                group = augroups.lsp,
                callback = function(detach)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = augroups.lsp, buffer = detach.buf })
                end,
            })
        end
    end,
})
