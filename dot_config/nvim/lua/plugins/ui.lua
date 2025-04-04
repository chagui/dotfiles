return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            flavor = "macchiato",
            integrations = {
                cmp = true,
                flash = true,
                fzf = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
            },
        },
        -- https://lazy.folke.io/spec/lazy_loading#-colorschemes
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "v4.*",
        dependencies = {
            "kyazdani42/nvim-web-devicons",
            -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
            "moll/vim-bbye",
        },
        opts = {
            options = {
                close_command = "bdelete! %d",
                right_mouse_command = "bdelete! %d",
                left_mouse_command = "buffer %d",
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = " פּ   Nvim Tree",
                        text_align = "left",
                        padding = 1,
                    },
                },
            },
        },
    },
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
    },
    {
        "nvim-telescope/telescope-frecency.nvim",
        config = function()
            require("telescope").load_extension("frecency")
        end,
        dependencies = { "kkharji/sqlite.lua" },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        opts = {
            options = {
                icons_enabled = true,
                theme = "catppuccin", -- will pick the variant set in catppuccin config
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = { "NvimTree", "toggleterm" },
                },
                always_divide_middle = true,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                        shorting_target = 40,
                    },
                },
                lualine_x = {
                    "diagnostics",
                    {
                        "filetype",
                        icon = { align = "right" },
                    },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = { "fzf", "fugitive", "lazy", "nvim-tree", "quickfix", "toggleterm" },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        opts = {
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "horizontal",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        },
        config = function()
            local function set_terminal_keymaps()
                local opts = { noremap = true }
                vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "jk", [[<C-\><C-n>]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
                vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
            end

            local augroups = require("user.augroups")
            vim.api.nvim_create_autocmd("TermOpen", {
                group = augroups.toggle_term,
                pattern = "term://*",
                callback = function()
                    set_terminal_keymaps()
                end,
            })
        end,
    },
}
