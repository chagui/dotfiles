-- https://neovim.io/doc/user/lua.html#vim.filetype.add()
vim.filetype.add({
    filename = {
        ['.aliases'] = 'zsh',
        ['.bash_personal'] = 'sh',
        ['.functions'] = 'zsh',
        ['.local'] = 'zsh',
        ['.os_aliases'] = 'zsh',
        ['Brewfile'] = 'ruby',
        -- Handle chezmoi templates
        ['dot_zshrc'] = 'zsh',
        ['dot_zshrc.tmpl'] = 'zsh',
        ['dot_aliasses'] = 'zsh',
        ['dot_functions'] = 'zsh',
    },
    pattern = {
        ['.+%.tfvars'] = 'terraform',
        -- Handle chezmoi templates
        ['${XDG_DATA_HOME}/chezmoi/.*%.(%a+)%.tmpl'] = function(_, _, captured_extension)
          if captured_extension == "yml"
          then
            return "yaml"
          end
          return captured_extension
        end,
    },
})

local set = vim.opt
-- https://neovim.io/doc/user/api.html#nvim_create_autocmd()
vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"terraform", "hcl", "json", "yaml"},
    callback = function()
        set.tabstop = 2
        set.shiftwidth = 2
        set.softtabstop = 2
    end
})

vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = {"go", "make"},
    callback = function()
        set.expandtab = false
        set.tabstop = 4
        set.shiftwidth = 4
        set.softtabstop = 4
    end
})

