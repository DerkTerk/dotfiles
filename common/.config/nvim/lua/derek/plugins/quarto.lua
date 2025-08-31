return {
	"quarto-dev/quarto-nvim",
	ft = { "quarto", "markdown" },
	dependencies = {
		"jmbuhr/otter.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvimtools/hydra.nvim",
	},
	init = function()
		local quarto = require("quarto")
		local is_code_chunk = function()
			local current, _ = require("otter.keeper").get_current_language_context()
			if current then
				return true
			else
				return false
			end
		end

		--- Insert code chunk of given language
		--- Splits current chunk if already within a chunk
		--- @param lang string
		local insert_code_chunk = function(lang)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
			local keys
			if is_code_chunk() then
				keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
			else
				keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
			end
			keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
			vim.api.nvim_feedkeys(keys, "n", false)
		end
		local insert_py_chunk = function()
			insert_code_chunk("python")
		end
		quarto.setup({
			vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true }),
			vim.keymap.set("n", "<leader>op", insert_py_chunk, { silent = true, noremap = true }),
			lspFeatures = {
				-- NOTE: put whatever languages you want here:
				languages = { "r", "python", "rust" },
				chunks = "all",
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			keymap = {
				-- NOTE: setup your own keymaps:
				hover = "H",
				definition = "gd",
				rename = "<leader>rn",
				references = "gr",
				format = "<leader>gf",
			},
			codeRunner = {
				enabled = true,
				default_method = "quarto",
				ft_runners = { python = "molten", quarto = "slime" },
			},
		})
		local function keys(str)
			return function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
			end
		end

		local hydra = require("hydra")
		hydra({
			name = "QuartoNavigator",
			hint = [[
      _j_/_k_: move down/up  _r_: run cell
      _l_: run line  _R_: run above
      ^^     _<esc>_/_q_: exit ]],
			config = {
				color = "pink",
				invoke_on_body = true,
			},
			mode = { "n" },
			body = "<localleader>j", -- this is the key that triggers the hydra
			heads = {
				{ "j", keys("]b") },
				{ "k", keys("[b") },
				{ "r", ":QuartoSend<CR>" },
				{ "l", ":QuartoSendLine<CR>" },
				{ "R", ":QuartoSendAbove<CR>" },
				{ "<esc>", nil, { exit = true } },
				{ "q", nil, { exit = true } },
			},
		})
	end,
}
