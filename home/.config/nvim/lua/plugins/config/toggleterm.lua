local osu = require("libs.os")

if osu.is_windows_native() then
	require("toggleterm").setup({
		shell = "pwsh",
	})
else
	require("toggleterm").setup({})
end

vim.keymap.set("n", "<A-t>", ":ToggleTerm<CR>", { desc = "ToggleTerm" })
vim.keymap.set("t", "<A-t>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "ToggleTerm in terminal mode" })
vim.keymap.set("n", "<leader>tt", ":ToggleTerm direction=float<CR>", { desc = "ToggleTerm on float" })
vim.keymap.set(
	"n",
	"<leader>tt",
	"<C-\\><C-n>:ToggleTerm direction=float<CR>",
	{ desc = "ToggleTerm on float in terminal mode" }
)
