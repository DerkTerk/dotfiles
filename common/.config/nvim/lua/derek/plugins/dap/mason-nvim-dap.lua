return {
	"jay-babu/mason-nvim-dap.nvim",
	opts = {
		-- Makes a best effort to setup the various debuggers with
		-- reasonable debug configurations
		automatic_installation = true,

		-- You can provide additional configuration to the handlers,
		-- see mason-nvim-dap README for more information
		handlers = {
			-- Default handler (for all debuggers you didn’t customize)
			function(config)
				require("mason-nvim-dap").default_setup(config)
			end,

			-- Custom handler for codelldb
			codelldb = function(config)
				local dap = require("dap")
				config.configurations = {
					{
						name = "LLDB: Launch",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
						args = {},
						console = "integratedTerminal",
						skipFiles = {
							"/Applications/Xcode.app/**",
							"/Library/Developer/**",
							"**/libc++/**",
							"**/System/Library/**",
						},
					},
					{
						name = "LLDB: Launch (args)",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
						args = function()
							return vim.split(vim.fn.input("Args: "), " +", { trimempty = true })
						end,
						console = "integratedTerminal",
						skipFiles = {
							"/Applications/Xcode.app/**",
							"/Library/Developer/**",
							"**/libc++/**",
							"**/System/Library/**",
						},
					},
				}
				-- pass to default_setup so it registers
				require("mason-nvim-dap").default_setup(config)
			end,
		},

		-- You'll need to check that you have the required things installed
		-- online, please don't ask me how to install them :)
		ensure_installed = {
			"codelldb",
			-- Update this to ensure that you have the debuggers for the langs you want
		},
	},
	dependencies = {
		"mfussenegger/nvim-dap",
		"williamboman/mason.nvim",
	},
}
