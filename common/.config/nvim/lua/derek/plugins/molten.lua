return {
	{
		"benlubas/molten-nvim",
		dependencies = { "3rd/image.nvim" },
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_auto_open_output = false
			vim.g.molten_image_provider = "image.nvim"
			-- vim.g.molten_output_show_more = true
			vim.g.molten_output_win_border = { "", "━", "", "" }
			vim.g.molten_output_win_max_height = 15
			-- vim.g.molten_output_virt_lines = true
			-- vim.g.molten_virt_text_output = true
			vim.g.molten_use_border_highlights = true
			vim.g.molten_image_location = "float"
			-- vim.g.molten_virt_lines_off_by_1 = true
			vim.g.molten_wrap_output = true
			vim.g.molten_tick_rate = 142

			vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
			vim.keymap.set("n", "<localleader>mp", ":MoltenImagePopup<CR>", { silent = true, desc = "Image popup" })
			vim.keymap.set(
				"n",
				"<localleader>e",
				":MoltenEvaluateOperator<CR>",
				{ silent = true, desc = "run operator selection" }
			)
			vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
			vim.keymap.set(
				"n",
				"<localleader>rr",
				":MoltenReevaluateCell<CR>",
				{ silent = true, desc = "re-evaluate cell" }
			)
			vim.keymap.set(
				"v",
				"<localleader>r",
				":<C-u>MoltenEvaluateVisual<CR>gv",
				{ silent = true, desc = "evaluate visual selection" }
			)
			vim.keymap.set("n", "<localleader>rd", ":MoltenDelete<CR>", { silent = true, desc = "molten delete cell" })
			vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
			vim.keymap.set(
				"n",
				"<localleader>os",
				":noautocmd MoltenEnterOutput<CR>",
				{ silent = true, desc = "show/enter output" }
			)

			vim.api.nvim_create_autocmd("User", {
				pattern = "MoltenInitPost",
				callback = function()
					-- quarto code runner mappings
					local r = require("quarto.runner")
					vim.keymap.set("n", "<localleader>rc", r.run_cell, { desc = "run cell", silent = true })
					vim.keymap.set("n", "<localleader>ra", r.run_above, { desc = "run cell and above", silent = true })
					vim.keymap.set("n", "<localleader>rb", r.run_below, { desc = "run cell and below", silent = true })
					vim.keymap.set("n", "<localleader>rl", r.run_line, { desc = "run line", silent = true })
					vim.keymap.set("n", "<localleader>rA", r.run_all, { desc = "run all cells", silent = true })
					vim.keymap.set("n", "<localleader>RA", function()
						r.run_all(true)
					end, { desc = "run all cells of all languages", silent = true })

					-- setup some molten specific keybindings
					vim.keymap.set(
						"n",
						"<localleader>e",
						":MoltenEvaluateOperator<CR>",
						{ desc = "evaluate operator", silent = true }
					)
					vim.keymap.set(
						"n",
						"<localleader>rr",
						":MoltenReevaluateCell<CR>",
						{ desc = "re-eval cell", silent = true }
					)
					vim.keymap.set(
						"v",
						"<localleader>r",
						":<C-u>MoltenEvaluateVisual<CR>gv",
						{ desc = "execute visual selection", silent = true }
					)
					vim.keymap.set(
						"n",
						"<localleader>os",
						":noautocmd MoltenEnterOutput<CR>",
						{ desc = "open output window", silent = true }
					)
					vim.keymap.set(
						"n",
						"<localleader>oh",
						":MoltenHideOutput<CR>",
						{ desc = "close output window", silent = true }
					)
					vim.keymap.set(
						"n",
						"<localleader>md",
						":MoltenDelete<CR>",
						{ desc = "delete Molten cell", silent = true }
					)
					local open = false
					vim.keymap.set("n", "<localleader>ot", function()
						open = not open
						vim.fn.MoltenUpdateOption("auto_open_output", open)
					end)

					-- if we're in a python file, change the configuration a little
					if vim.bo.filetype == "python" then
						vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", false)
						vim.fn.MoltenUpdateOption("molten_virt_text_output", false)
					end
				end,
			})

			-- for venv
			vim.keymap.set("n", "<localleader>ip", function()
				local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
				if venv ~= nil then
					-- in the form of /home/benlubas/.virtualenvs/VENV_NAME
					venv = string.match(venv, "/.+/(.+)")
					vim.cmd(("MoltenInit %s"):format(venv))
				else
					vim.cmd("MoltenInit python3")
				end
			end, { desc = "Initialize Molten for python3", silent = true })
		end,
	},
}
