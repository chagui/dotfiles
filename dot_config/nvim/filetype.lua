-- https://neovim.io/doc/user/lua.html#vim.filetype.add()
vim.filetype.add({
    filename = {
        [".aliases"] = "zsh",
        [".bash_personal"] = "sh",
        [".functions"] = "zsh",
        [".local"] = "zsh",
        [".os_aliases"] = "zsh",
        ["Brewfile"] = "ruby",
        -- Handle chezmoi templates
        ["dot_zshrc"] = "zsh",
        ["dot_zshrc.tmpl"] = "zsh",
        ["dot_aliasses"] = "zsh",
        ["dot_functions"] = "zsh",
    },
    pattern = {
        [".+%.tfvars"] = "terraform",
        [".+%.gitconfig"] = "gitconfig",
        -- Handle chezmoi templates
        ["${XDG_DATA_HOME}/chezmoi/.*%.(%a+)%.tmpl"] = function(_, _, captured_extension)
            if captured_extension == "yml" then
                return "yaml"
            end
            return captured_extension
        end,
    },
})

local augroups = require("user.augroups")
local autocmd = vim.api.nvim_create_autocmd
-- https://neovim.io/doc/user/api.html#nvim_create_autocmd()
autocmd({ "FileType" }, {
    group = augroups.filetype,
    pattern = { "terraform", "hcl", "json", "yaml" },
    callback = function(event)
        vim.bo[event.buf].tabstop = 2
        vim.bo[event.buf].shiftwidth = 2
        vim.bo[event.buf].softtabstop = 2
        vim.bo[event.buf].expandtab = true
    end,
})

autocmd({ "FileType" }, {
    group = augroups.filetype,
    pattern = { "go", "make" },
    callback = function(event)
        vim.bo[event.buf].expandtab = false
        vim.bo[event.buf].tabstop = 4
        vim.bo[event.buf].shiftwidth = 4
        vim.bo[event.buf].softtabstop = 4
    end,
})

autocmd({ "BufWritePre" }, {
    group = augroups.filetype,
    pattern = { "*" },
    desc = "Remove trailing spaces on save",
    command = [[%s/\s\+$//e]],
})

autocmd("FileType", {
    desc = "Close with q",
    group = augroups.visual,
    pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query", -- :InspectTree
        "spectre_panel",
        "startuptime",
        "tsplayground",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set(
            "n",
            "q",
            "<cmd>close<cr>",
            { buffer = event.buf, desc = "Close some filetype windows with <q>" }
        )
    end,
})
