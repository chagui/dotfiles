-- tip: use vim.inspect to know what's inside a variable, e.g. print(vim.inspect(vim.opt.syntax))
local options = {
  syntax = "on",

  ttyfast = true,
  showmode = true,
  showcmd = true,

  -- Tab sanity
  expandtab = true,
  shiftwidth = 4,
  softtabstop = 4,
  smartindent = true,
  autoindent = true,

  -- Navigation
  title = true,
  number = true,
  relativenumber = true,
  mouse = "a",
  cursorline = true,
  -- Always use the clipboard for all operations instead of interacting with
  -- registers
  clipboard = "unnamedplus",

  -- Search
  ignorecase = true,
  smartcase = true,
  hlsearch = true,
  incsearch = true,

  -- History
  undodir = vim.fn.stdpath "cache" .. "/undo",
  undofile = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

