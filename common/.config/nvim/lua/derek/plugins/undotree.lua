return {
	"mbbill/undotree",
	config = function()
		-- This sets the keybinding Ctrl+U to open the UndoTree viewer
		vim.api.nvim_set_keymap("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })
	end,
}
