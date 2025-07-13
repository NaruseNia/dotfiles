local TAB_WIDTH = 2

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

-- Prelude --
require("lazy_init")
-- For make correct mappings --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("plugins.init")
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end
require("keymaps.init")

vim.g.guitablabel = "%t"
vim.g.linebreak = "nowrap"
vim.g.gruvbox_contrast_dark = "hard"

-- Vim options --
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = TAB_WIDTH
vim.opt.shiftwidth = TAB_WIDTH
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

vim.opt.termguicolors = true
vim.opt.pumblend = 10
vim.opt.cmdheight = 0
vim.opt.cursorline = true

vim.opt.number = true
vim.opt.relativenumber = true

-- vim.cmd("colorscheme obscure")
if vim.g.neovide then
  vim.o.guifont = "Moralerspace Neon NF"
end

-- Folding
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.diagnostic.config({
  virtual_lines = false,
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
require("autocmd")
