local profile = require("user.profile")

---@type LazySpec
return {
    { "windwp/nvim-autopairs", event = "InsertEnter" },
    {
        "folke/lazydev.nvim",
        cond = profile.active("default"),
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- Only load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "bash",
                "c",
                "cmake",
                "dockerfile",
                "dot",
                "go",
                "gotmpl",
                "hcl",
                "json",
                "lua",
                "make",
                "python",
                "rust",
                "terraform",
                "toml",
                "yaml",
            })
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf = args.buf
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang or not pcall(vim.treesitter.start, buf, lang) then
                        return
                    end
                    vim.wo[0].foldmethod = "expr"
                    vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")
            local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")

            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@parameter.outer"] = "v",
                        ["@function.outer"] = "V",
                        ["@class.outer"] = "V",
                    },
                },
                move = { set_jumps = true },
            })

            -- Select
            for _, mode in ipairs({ "x", "o" }) do
                vim.keymap.set(mode, "af", function()
                    select.select_textobject("@function.outer", "textobjects")
                end, { desc = "a function" })
                vim.keymap.set(mode, "if", function()
                    select.select_textobject("@function.inner", "textobjects")
                end, { desc = "inner function" })
                vim.keymap.set(mode, "ac", function()
                    select.select_textobject("@class.outer", "textobjects")
                end, { desc = "a class" })
                vim.keymap.set(mode, "ic", function()
                    select.select_textobject("@class.inner", "textobjects")
                end, { desc = "inner class" })
                vim.keymap.set(mode, "aa", function()
                    select.select_textobject("@parameter.outer", "textobjects")
                end, { desc = "a argument" })
                vim.keymap.set(mode, "ia", function()
                    select.select_textobject("@parameter.inner", "textobjects")
                end, { desc = "inner argument" })
            end

            -- Move
            local move_maps = {
                ["]m"] = { move.goto_next_start, "@function.outer", "Next function start" },
                ["]M"] = { move.goto_next_end, "@function.outer", "Next function end" },
                ["[m"] = { move.goto_previous_start, "@function.outer", "Prev function start" },
                ["[M"] = { move.goto_previous_end, "@function.outer", "Prev function end" },
                ["]]"] = { move.goto_next_start, "@class.outer", "Next class start" },
                ["]["] = { move.goto_next_end, "@class.outer", "Next class end" },
                ["[["] = { move.goto_previous_start, "@class.outer", "Prev class start" },
                ["[]"] = { move.goto_previous_end, "@class.outer", "Prev class end" },
                ["]a"] = { move.goto_next_start, "@parameter.outer", "Next argument" },
                ["[a"] = { move.goto_previous_start, "@parameter.outer", "Prev argument" },
                ["]d"] = { move.goto_next, "@conditional.outer", "Next conditional" },
                ["[d"] = { move.goto_previous, "@conditional.outer", "Prev conditional" },
            }
            for key, val in pairs(move_maps) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    val[1](val[2], "textobjects")
                end, { desc = val[3] })
            end

            -- Swap
            vim.keymap.set("n", "<leader>a", function()
                swap.swap_next("@parameter.inner")
            end, { desc = "Swap next argument" })
            vim.keymap.set("n", "<leader>A", function()
                swap.swap_previous("@parameter.inner")
            end, { desc = "Swap prev argument" })

            -- Repeatable moves with ; and ,
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous)
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true })
        end,
    },

    -- LSP
    {
        "mason-org/mason-lspconfig.nvim",
        cond = profile.active("default"),
        lazy = false,
        opts = {
            ensure_installed = {
                "bashls",
                "clangd",
                "cmake",
                "dockerls",
                "gitlab_ci_ls",
                "jsonls",
                "gopls",
                "helm_ls",
                "lua_ls",
                "ruff",
                "rust_analyzer",
                "starpls",
                "taplo",
                "terraformls",
                "yamlls",
            },
            automatic_enable = true,
        },
        dependencies = {
            {
                "mason-org/mason.nvim",
                build = function()
                    pcall(vim.api.nvim_command, "MasonUpdate")
                end,
                opts = {},
                keys = {
                    { "<leader>mm", "<Cmd>Mason<CR>", desc = "Packages" },
                },
            },
            { "neovim/nvim-lspconfig" },
        },
    },

    -- Completion
    {
        "saghen/blink.cmp",
        cond = profile.active("default"),
        dependencies = {
            "rafamadriz/friendly-snippets",
            "kyazdani42/nvim-web-devicons",
            "onsails/lspkind.nvim",
        },
        version = "1.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "enter",
                ["<C-S>"] = { "show", "show_documentation", "hide_documentation" },
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                },
                ghost_text = {
                    enabled = true,
                },
                list = {
                    selection = {
                        preselect = true,
                        -- use ghost text instead
                        auto_insert = false,
                    },
                },
                -- based on of https://cmp.saghen.dev/recipes.html#nvim-web-devicons-lspkind
                menu = {
                    draw = {
                        columns = {
                            {
                                "label",
                                gap = 1,
                                "label_description",
                            },
                            {
                                "kind_icon",
                                gap = 1,
                                "kind",
                            },
                            {
                                "source_name",
                            },
                        },
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = require("lspkind").symbolic(ctx.kind, {
                                            mode = "symbol",
                                        })
                                    end

                                    return icon .. ctx.icon_gap
                                end,

                                -- Optionally, use the highlight groups from nvim-web-devicons
                                -- You can also add the same function for `kind.highlight` if you want to
                                -- keep the highlight groups in sync with the icons.
                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            },
                        },
                    },
                },
                trigger = {
                    show_on_keyword = true,
                    show_on_trigger_character = true,
                    show_on_insert_on_trigger_character = true,
                },
            },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
}
