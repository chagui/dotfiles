-- https://neovim.io/doc/user/lua.html#vim.filetype.add()
vim.filetype.add({
    filename = {
        ['.aliases'] = 'zsh',
        ['.bash_personal'] = 'sh',
        ['.functions'] = 'zsh',
        ['.local'] = 'zsh',
        ['.os_aliases'] = 'zsh',
        -- Handle chezmoi templates
        ['dot_zshrc'] = 'zsh',
        ['dot_zshrc.tmpl'] = 'zsh',
        ['dot_aliases'] = 'zsh',
        ['dot_functions'] = 'zsh',
    },
    pattern = {
        -- Handle chezmoi templates
        ['${XDG_DATA_HOME}/chezmoi/.*%.(%a+)%.tmpl'] = function(_, _, ext)
            return ext
        end,
    },
})
