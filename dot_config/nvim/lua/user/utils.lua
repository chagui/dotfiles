local utils = {}

-- Reveal what lurks beneath an object.
function utils.reveal(item, options)
    print(vim.inspect(item, options))
end

local function set_if_absent(lhs, rhs)
    for k, v in pairs(rhs) do
        if lhs[k] == nil then
            lhs[k] = v
        end
    end
end

local function keymap(mode, lhs, rhs, opts)
    opts = opts and opts or {}
    set_if_absent(opts, { silent = true })
    vim.keymap.set(mode, lhs, rhs, opts)
end

function utils.map(lhs, rhs, opts)
    keymap("", lhs, rhs, opts)
end

function utils.nmap(lhs, rhs, opts)
    keymap("n", lhs, rhs, opts)
end

function utils.imap(lhs, rhs, opts)
    keymap("i", lhs, rhs, opts)
end

function utils.xmap(lhs, rhs, opts)
    keymap("x", lhs, rhs, opts)
end

function utils.vmap(lhs, rhs, opts)
    keymap("v", lhs, rhs, opts)
end

local function keynoremap(mode, lhs, rhs, opts)
    opts = opts and opts or {}
    set_if_absent(opts, { noremap = true, silent = true })
    vim.keymap.set(mode, lhs, rhs, opts)
end

function utils.noremap(lhs, rhs, opts)
    keynoremap("", lhs, rhs, opts)
end

function utils.nnoremap(lhs, rhs, opts)
    keynoremap("n", lhs, rhs, opts)
end

function utils.inoremap(lhs, rhs, opts)
    keynoremap("i", lhs, rhs, opts)
end

function utils.xnoremap(lhs, rhs, opts)
    keynoremap("x", lhs, rhs, opts)
end

function utils.vnoremap(lhs, rhs, opts)
    keynoremap("v", lhs, rhs, opts)
end

return utils
