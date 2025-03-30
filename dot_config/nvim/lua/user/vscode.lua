local utils = require("user.utils")

local globals = vim.g

-- remap leader
utils.noremap("<Space>", "<Nop>")
globals.mapleader = " "
globals.maplocalleader = " "

-- Save with leader s
utils.nmap("<leader>s", "<Cmd>w<CR>")

-- preserve the unnamed register (changed to clipboard above) by default
utils.vmap("p", "P")

local vscode_action = function(action)
    return function()
        require("vscode").action(action)
    end
end

utils.nmap("<leader>[", vscode_action("editor.fold"))
utils.nmap("<leader>]", vscode_action("editor.unfold"))

-- Focus the file explorer panel
utils.nmap("<leader>e", vscode_action("workbench.explorer.fileView.focus"))
