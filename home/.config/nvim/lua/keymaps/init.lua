local set = vim.keymap.set

-- Common
set("n", "<leader>/", ":noh<cr>", { desc = "Clear search" })
set("n", "<A-J>", "<cmd>m+1<cr>", { desc = "Swap lower" })
set("n", "<A-K>", "<cmd>m-2<cr>", { desc = "Swap upper" })
set({ "n", "i" }, "<C-l>", require("actions-preview").code_actions, { desc = "LSP code action" })
set("n", "<leader>ya", ":%y+<CR>", { desc = "Copy all" })
set("n", "<leader>cr", ":so $MYVIMRC<CR>", { desc = "Reload config" })

-- Neotree
set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle NeoTree" })

-- Oil
set("n", "<leader>o", "<cmd>Oil<cr>", { desc = "Open Oil" })

-- Telescope
set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope find files" })
set("n", "<leader>b", require("telescope.builtin").buffers, { desc = "Telescope buffers" })
set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Telescope live grep" })
set("n", "<leader>fa", require("telescope").extensions.aerial.aerial, { desc = "Telescope symbols w/ aerial" })
set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true })

-- Close buffer
set("n", "<leader>x", "<cmd>BDelete this<cr>", { desc = "Close this" })
set("n", "<leader>q", "<cmd>BDelete this<cr><cmd>q<cr>", { desc = "Close this and close pane" })
set("n", "<leader>bo", "<cmd>BDelete other<cr>", { desc = "Close other buffer(s)" })

-- Copilot
set("n", "<leader>ca", function()
  require("copilot.suggestion").toggle_auto_trigger()
end, { desc = "Toggle copilot auto trigger" })
set({ "n", "i" }, "<C-z>", function()
  require("copilot.suggestion").accept()
end, { desc = "Copilot accept" })

-- Aerial set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- Multicursor
do
  local mc = require("multicursor-nvim")

  -- Add or skip cursor above/below the main cursor.
  set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
  set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
  set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip cursor above" })
  set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "Skip cursor below" })

  -- Add or skip adding a new cursor by matching word/selection
  set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "Add cursor to next match" })
  set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end, { desc = "Skip next match" })
  set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end, { desc = "Add cursor to previous match" })
  set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end, { desc = "Skip previous match" })

  -- Add and remove cursors with control + left click.
  set("n", "<c-leftmouse>", mc.handleMouse)
  set("n", "<c-leftdrag>", mc.handleMouseDrag)
  set("n", "<c-leftrelease>", mc.handleMouseRelease)

  -- Disable and enable cursors.
  set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle multicursor" })
end

-- Ufo
do
  local ufo = require("ufo")
  set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
  set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
  set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds except kinds" })
  set("n", "zm", ufo.closeFoldsWith, { desc = "Close folds with kinds" })
  set("n", "zK", function()
    local winid = ufo.peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end, { desc = "Peek fold or hover" })
end

-- Hover (lazy)
-- See: plugins.config.hover

-- Flash (lazy)
-- See: plugins.config.flash

-- Toggleterm (lazy)
-- See: plugins.config.toggleterm
