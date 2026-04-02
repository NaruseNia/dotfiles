vim.keymap.set({"n", "x", "o"}, "s", require('flash').jump, { desc = 'Flash' })
vim.keymap.set({"n", "x", "o"}, "S", require('flash').treesitter, { desc = 'Flash Treesitter' })
