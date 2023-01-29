local utils = {}

-- Reveal what lurks beneath an object.
function utils.reveal(item, options)
    print(vim.inspect(item, options))
end

-- Tells you if we're running in VSCode.
function utils.is_vscode()
    -- adapted from https://github.com/vscode-neovim/vscode-neovim#conditional-initvim
    return vim.g.vscode
end

function keymap(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { silent = true })
end

function utils.map(lhs, rhs)
    keymap("", lhs, rhs)
end
function utils.nmap(lhs, rhs)
    keymap("n", lhs, rhs)
end
function utils.imap(lhs, rhs)
    keymap("i", lhs, rhs)
end
function utils.xmap(lhs, rhs)
    keymap("x", lhs, rhs)
end
function utils.vmap(lhs, rhs)
    keymap("v", lhs, rhs)
end

function keynoremap(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

function utils.noremap(lhs, rhs)
    keynoremap("", lhs, rhs)
end
function utils.nnoremap(lhs, rhs)
    keynoremap("n", lhs, rhs)
end
function utils.inoremap(lhs, rhs)
    keynoremap("i", lhs, rhs)
end
function utils.xnoremap(lhs, rhs)
    keynoremap("x", lhs, rhs)
end
function utils.vnoremap(lhs, rhs)
    keynoremap("v", lhs, rhs)
end

return utils
