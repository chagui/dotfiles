-- Setup nvim-tree.
-- options are documented in `:help nvim-tree.OPTION_NAME`
-- see https://github.com/kyazdani42/nvim-tree.lua
local nvim_tree = require("nvim-tree")
local tree_cb = require("nvim-tree.config").nvim_tree_callback

local function on_attach(bufnr)
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    nvim_tree.api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    local utils = require("user.utils")
    utils.nnoremap("<C-t>", nvim_tree.api.tree.change_root_to_parent, opts("Up"))
    utils.nnoremap("?", nvim_tree.api.tree.toggle_help, opts("Help"))
end

nvim_tree.setup({
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = false,
    update_cwd = true,
    hijack_directories = {
        enable = true,
        auto_open = true,
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 50,
        hide_root_folder = false,
        side = "left",
        float = {
            open_win_config = {
                width = 30,
                height = 30,
            },
        },
        on_attach = on_attach,
        number = true,
        relativenumber = true,
    },
    actions = {
        open_file = {
            quit_on_open = true,
            resize_window = true,
            window_picker = {
                enable = false,
            },
        },
    },
    renderer = {
        highlight_git = true,
        root_folder_modifier = ":t",
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                bookmark = "什",
                default = "",
                symlink = "",
                git = {
                    deleted = "",
                    ignored = "◌",
                    renamed = "➜",
                    staged = "S",
                    unmerged = "",
                    unstaged = "",
                    untracked = "U",
                },
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                },
            },
        },
    },
    filters = {
        custom = { "^.git$" },
    },
})

local utils = require("user.utils")
utils.nnoremap("<leader>e", "<cmd>NvimTreeToggle<cr>")
