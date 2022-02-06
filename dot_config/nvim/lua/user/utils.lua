local utils = {}

-- Reveal what lurks beneath an object.
function utils.reveal(object, options)
    print(vim.inspect(item, options))
end

function keymap(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, {silent =  true})
end

function utils.map(lhs, rhs) keymap("", lhs, rhs) end
function utils.nmap(lhs, rhs) keymap("n", lhs, rhs) end
function utils.xmap(lhs, rhs) keymap("x", lhs, rhs) end

return utils

