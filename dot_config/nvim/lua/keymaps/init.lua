-- local hop = require("hop")
-- local dircs = require("hop.hint").HintDirection
local builtin = require("telescope.builtin")
local crates = require("crates")
local opts = { noremap = true, silent = true }

--#region General
vim.keymap.set(
  "i",
  "<C-z>",
  'copilot#Accept("<CR>")',
  { silent = true, expr = true, replace_keycodes = false, script = true }
)

vim.keymap.set("n", "<C-i>", "mmyyp`mj", { desc = "Duplicate line", noremap = true, silent = true })
vim.keymap.set({ "n", "i" }, "<C-l>", require("actions-preview").code_actions, { desc = "LSP code action" })
vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.rename, { desc = "LSP rename symbol" })

vim.keymap.set("n", "<leader>rb", function() require("reach").buffers() end, {})
vim.keymap.set("n", "<leader>co", function() require("precognition").toggle() end, opts)

vim.keymap.set("n", "<leader>st", function() require("nvchad.themes").open() end, { desc = "Open themes picker" })

vim.keymap.set("n", "<leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })

vim.keymap.set('n', '<leader>bi', '<cmd>Bufferin<cr>', { desc = 'Toggle Bufferin' })
vim.keymap.set('n', '<leader>x', '<cmd>BDelete this<cr>', { desc = 'Close this' })
vim.keymap.set('n', '<leader>q', '<cmd>BDelete this<cr><cmd>q<cr>', { desc = 'Close this and close pane' })
vim.keymap.set('n', '<leader>bo', '<cmd>BDelete other<cr>', { desc = 'Close other buffer(s)' })
vim.keymap.set('n', '<leader>/', ':noh<cr>', { desc = 'Clear search' })

vim.keymap.set('n', '<leader>oo', '<cmd>Oil<cr>', { desc = 'Open Oil' })
--#endregion

--#region Telescope
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope commands" })
vim.keymap.set("n", "<leader>fl", builtin.lsp_definitions, { desc = "Telescope LSP definitions" })
vim.keymap.set("n", "<leader>ft", builtin.lsp_type_definitions, { desc = "Telescope LSP type definitions" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Telescope LSP references" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope LSP document symbols" })
vim.keymap.set("n", "<leader>fz", builtin.lsp_workspace_symbols, { desc = "Telescope LSP workspace symbols" })
vim.keymap.set("n", "<leader>vc", builtin.git_commits, { desc = "Telescope LSP commits" })
vim.keymap.set("n", "<leader>vs", builtin.git_status, { desc = "Telescope git status" })
vim.keymap.set("n", "<leader>vb", builtin.git_branches, { desc = "Telescope git branches" })
vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true })
--#endregion

--#region Crates
vim.keymap.set("n", "<leader>ct", crates.toggle, { desc = "Toggle crates ui" })
vim.keymap.set("n", "<leader>cc", crates.show_popup, { desc = "Show crates popup" })
vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { desc = "Show crates features" })
vim.keymap.set("n", "<leader>cd", crates.open_documentation, { desc = "Open crates' documentation" })
vim.keymap.set("n", "<leader>ci", crates.open_crates_io, { desc = "Open crates' page" })
--#endregion

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle NeoTree" })

vim.keymap.set("n", "<A-;>", function()
  vim.lsp.buf.format({ async = false })
end, { desc = "Format document" })

vim.keymap.set("n", "<C-x>", ":BufferClose<CR>", { desc = "Close Buffer" })

vim.keymap.set("n", "<leader>ww", ":set linebreak wrap<CR>", { desc = "Linebreak wrap" })
vim.keymap.set("n", "<leader>wn", ":set linebreak nowrap<CR>", { desc = "Linebreak nowrap" })
vim.keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Copy all" })

--#region ToggleTerm
vim.keymap.set("n", "<A-t>", ":ToggleTerm<CR>", { desc = "ToggleTerm" })
vim.keymap.set("t", "<A-t>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "ToggleTerm in terminal mode" })
vim.keymap.set("n", "<leader>tt", ":ToggleTerm direction=float<CR>", { desc = "ToggleTerm on float" })
vim.keymap.set("n", "<leader>tt", "<C-\\><C-n>:ToggleTerm direction=float<CR>",
  { desc = "ToggleTerm on float in terminal mode" })
--#endregion

-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
-- vim.keymap.set("t", "<leader>cr", ":so $MYVIMRC<CR>", { desc = "Reload config" })

--#region Accelerated jk
vim.api.nvim_set_keymap('n', 'j', '<Plug>(accelerated_jk_gj)', {})
vim.api.nvim_set_keymap('n', 'k', '<Plug>(accelerated_jk_gk)', {})
--#endregion

--#region Dial
vim.keymap.set("n", "<C-a>", function()
  require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
  require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "<C-a>", function()
  require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "<C-x>", function()
  require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gvisual")
end)
--#endregion

--#region Glance
vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>')
vim.keymap.set('n', 'gR', '<CMD>Glance references<CR>')
vim.keymap.set('n', 'gY', '<CMD>Glance type_definitions<CR>')
vim.keymap.set('n', 'gM', '<CMD>Glance implementations<CR>')
--#endregion

--#region lasterisk
vim.keymap.set('n', '*', function() require("lasterisk").search() end)
vim.keymap.set('n', 'g*', function() require("lasterisk").search({ is_whole = false }) end)
vim.keymap.set('x', 'g*', function() require("lasterisk").search({ is_whole = false }) end)
--#endregion

--#region gtd
vim.keymap.set('n', 'gf<CR>', function()
  require('gtd').exec({ command = 'edit' })
end)
vim.keymap.set('n', 'gfs', function()
  require('gtd').exec({ command = 'split' })
end)
vim.keymap.set('n', 'gv', function()
  require('gtd').exec({ command = 'vsplit' })
end)
vim.keymap.set('n', 'gd', function()
  require('gtd').exec({ command = 'vsplit' })
end)
--#endregion
