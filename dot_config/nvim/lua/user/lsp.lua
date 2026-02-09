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
    pattern = { "*.tf", "*.tfvars", "*.go" },
    callback = vim.lsp.buf.format,
})

local utils = require("user.utils")
-- https://neovim.io/doc/user/lsp.html#lsp-attach
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroups.lsp,
    callback = function(attach)
        local buf_opts = { buffer = attach.buf }
        utils.nmap("<leader>fb", vim.lsp.buf.format, vim.tbl_extend("force", buf_opts, { desc = "[F]ormat [B]uffer" }))
        utils.nmap("gd", vim.lsp.buf.definition, vim.tbl_extend("force", buf_opts, { desc = "[G]oto [D]efinition" }))
        utils.nmap("gD", vim.lsp.buf.declaration, vim.tbl_extend("force", buf_opts, { desc = "[G]oto [D]eclaration" }))
        utils.nmap(
            "<leader>ca",
            vim.lsp.buf.code_action,
            vim.tbl_extend("force", buf_opts, { desc = "[C]ode [A]ction" })
        )
        utils.nmap("<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", buf_opts, { desc = "[R]e[n]ame" }))
        utils.nmap(
            "<leader>D",
            vim.lsp.buf.type_definition,
            vim.tbl_extend("force", buf_opts, { desc = "Type [D]efinition" })
        )

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
        end
    end,
})

-- When LSP detaches: Clears the highlighting
vim.api.nvim_create_autocmd("LspDetach", {
    group = augroups.lsp,
    callback = function(detach)
        vim.lsp.buf.clear_references()
        local remaining = vim.lsp.get_clients({ bufnr = detach.buf })
        if #remaining == 0 then
            vim.api.nvim_clear_autocmds({ group = augroups.lsp, buffer = detach.buf })
        end
    end,
})
