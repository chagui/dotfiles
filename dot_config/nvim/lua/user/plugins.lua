local fn = vim.fn

local packer_bootstrap = {}

-- Install packer if not found
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth", "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

-- Reloads neovim whenever plugins.lua is modified
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

local plugins = {
    -- Meta
    "wbthomason/packer.nvim",

    -- GUI enhancements
    "ayu-theme/ayu-vim",
    "itchyny/lightline.vim",
    "tpope/vim-fugitive",
    "machakann/vim-highlightedyank",
    "psliwka/vim-smoothie",
    {
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function() require("gitsigns").setup() end
    },

    -- Projects
    "airblade/vim-rooter",
    "vim-scripts/localvimrc",

    -- Navigation
    "justinmk/vim-sneak",
    {
        "junegunn/fzf",
        run = function()
            vim.fn['fzf#install']()
        end,
        alias = "fzf",
    },
    {"junegunn/fzf.vim", after = "fzf"},
    "preservim/nerdtree",

    -- Completion
    {"hrsh7th/nvim-cmp", alias = "completion"},
    {"hrsh7th/cmp-buffer", requires = "nvim-cmp"},
    {"hrsh7th/cmp-path", requires = "nvim-cmp"},
    {"hrsh7th/cmp-cmdline", requires = "nvim-cmp"},
    {"hrsh7th/cmp-nvim-lua", requires = "nvim-cmp"},

    -- Snippets
    {"L3MON4D3/LuaSnip", alias = "luasnip", requires = "nvim-cmp"},
    {"rafamadriz/friendly-snippets", requires = "LuaSnip"},
    {"saadparwaiz1/cmp_luasnip", requires = "LuaSnip"},

    -- Languages
    "rust-lang/rust.vim",
    "cespare/vim-toml",
    "stephpy/vim-yaml",
    "plasticboy/vim-markdown",
}

local packer_config = {
    display = {
        open_fn = function()
            return require("packer.util").float({
                style = "minimal",
                border = "rounded"
            })
        end
    }
}
packer.startup({plugins, config = packer_config})

return packer

