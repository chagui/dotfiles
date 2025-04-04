local function nvim_tree_on_attach(bufnr)
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    local api = require("nvim-tree.api")
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    local utils = require("user.utils")
    vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

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
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Open or close the tree." },
        },
        opts = {
            disable_netrw = true,
            hijack_netrw = true,
            hijack_cursor = false,
            update_cwd = true,
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
            on_attach = nvim_tree_on_attach,
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
                side = "left",
                float = {
                    open_win_config = {
                        width = 30,
                        height = 30,
                    },
                },
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
                root_folder_label = false,
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
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        keys = {
            {
                "<leader>,",
                "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
                desc = "Show Buffers by most recently used",
            },
            { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
            { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
            { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "[S]earch [C]ommands" },
            { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "[S]earch Man [P]ages" },
            { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[S]earch [B]uffer" },
            { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "[S]earch Document [D]iagnostics" },
            { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "[S]earch [Q]uickfix List" },
            { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp Tags" },
            { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch Current [W]ord" },
            {
                "<leader>fb",
                "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
                desc = "[F]ind [B]uffers",
            },
            -- git
            { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Search Vim [O]ptions" },
            { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Search [G]it [C]ommits" },
            { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Search [G]it [S]tatus" },
            { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[F]ind [F]iles (git-files)" },
            -- LSP
            { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "[S]earch [S]ymbol" },
            { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "[S]earch (Workspace) Symbol" },
        },
        opts = function()
            local telescope = require("telescope")

            local actions = require("telescope.actions")

            local opts = {
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                    },
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },

                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,

                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,

                            ["<C-c>"] = actions.close,

                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,

                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,

                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,

                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,

                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-l>"] = actions.complete_tag,
                            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                        },

                        n = {
                            ["<esc>"] = actions.close,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,

                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["H"] = actions.move_to_top,
                            ["M"] = actions.move_to_middle,
                            ["L"] = actions.move_to_bottom,

                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["gg"] = actions.move_to_top,
                            ["G"] = actions.move_to_bottom,

                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,

                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,

                            ["?"] = actions.which_key,
                        },
                    },
                },
            }

            if vim.loop.os_uname().sysname == "linux" then
                telescope.load_extension("media_files")
                opts.extensions.media_files = {
                    filetypes = { "png", "webp", "jpg", "jpeg" },
                    find_cmd = "rg",
                }
            end

            local has_native_fzf, _ = pcall(require, "fzf_lib")
            if has_native_fzf then
                telescope.load_extension("fzf")
            end

            return opts
        end,
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
