local TAB_WIDTH = 2

-- Global variables --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.guitablabel = "%t"
vim.g.linebreak = "nowrap"

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

-- Folding --
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Plugins --
require("pack_init")
require("plugins")
require("keymaps")

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Color scheme --
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme aizen]])

-- Neovide settings --
if vim.g.neovide then
  local padding_x = 64
  local padding_y = 64
  local floating_blur = 4.0

  vim.g.guifont = "Lilex Nerd Font:h14"

  vim.g.neovide_window_blurred = true
  vim.g.neovide_opacity = 0.7
  vim.g.neovide_floating_blur_amount_x = floating_blur
  vim.g.neovide_floating_blur_amount_y = floating_blur
  vim.g.neovide_floating_corner_radius = 12.0
  vim.g.neovide_padding_top = padding_y
  vim.g.neovide_padding_bottom = padding_y
  vim.g.neovide_padding_right = padding_x
  vim.g.neovide_padding_left = padding_x
  vim.g.neovide_cursor_animation_length = 0.023
  vim.g.neovide_position_animation_length = 0.023
  vim.g.neovide_scroll_animation_length = 0.023
end
