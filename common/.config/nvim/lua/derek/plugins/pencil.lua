return {
	"preservim/vim-pencil",
	requires = { "tpope/vim-repeat", "tpope/vim-speeddating" }, -- Dependencies for Vim Pencil
	init = function()
		vim.g["pencil#wrapModeDefault"] = "soft"
	end,
	config = function()
		vim.cmd([[
	               autocmd FileType text,tex call pencil#init()
	               autocmd FileType text,tex setlocal conceallevel=2
	               set wrap
	               set linebreak
	           ]])
	end,
}
