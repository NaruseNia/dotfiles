local mod = require("multicursor-nvim")
mod.setup {}
mod.addKeymapLayer(function(layerSet)
  -- Select a different cursor as the main one.
  layerSet({ "n", "x" }, "<left>", mod.prevCursor)
  layerSet({ "n", "x" }, "<right>", mod.nextCursor)

  -- Delete the main cursor.
  layerSet({ "n", "x" }, "<leader>x", mod.deleteCursor)

  -- Enable and clear cursors using escape.
  layerSet("n", "<esc>", function()
    if not mod.cursorsEnabled() then
      mod.enableCursors()
    else
      mod.clearCursors()
    end
  end)
end)

local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { reverse = true })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorMatchPreview", { link = "Search" })
hl(0, "MultiCursorDisabledCursor", { reverse = true })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
