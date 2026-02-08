local profile = require("user.profile")

---@type LazySpec
return {
    { "windwp/nvim-autopairs", event = "InsertEnter" },
    {
        "folke/lazydev.nvim",
        cond = profile.active("default"),
        ft = "lua", -- only load on lua files
        opts = {
            -- It can also be a table with trigger words / mods
            -- Only load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            -- Only load the lazyvim library when the `LazyVim` global is found
            { path = "LazyVim", words = { "LazyVim" } },
        },
    },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/nvim-treesitter-context", dependencies = "nvim-treesitter/nvim-treesitter" },

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
            {
                "neovim/nvim-lspconfig",
                dependencies = { "saghen/blink.cmp" },
            },
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
