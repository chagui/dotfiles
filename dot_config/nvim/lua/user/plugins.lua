local fn = vim.fn

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
    "junegunn/fzf.vim",
    {
        "junegunn/fzf",
        run = function()
            vim.fn['fzf#install']()
        end
    },
    "preservim/nerdtree",
    
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

