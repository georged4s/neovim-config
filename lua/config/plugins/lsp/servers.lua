return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "󰌵",
					},
				},
				virtual_text = false,
			})

			local servers = {
				bashls = {},
				cssls = {
					filetypes = { "css", "scss", "less", "wxss" },
				},
				dockerls = {},
				jsonls = {},
				ruff = {},
				sqls = {
					settings = {
						sqls = {
							lowercaseKeywords = true,
						},
					},
					cmd = (function()
						local cmd = { vim.fn.stdpath("data") .. "/mason/bin/sqls" }
						local config_path = vim.loop.cwd() .. "/sqls.yml"

						if vim.fn.filereadable(config_path) == 1 then
							table.insert(cmd, "--config")
							table.insert(cmd, config_path)
						end

						return cmd
					end)(),
				},
				stylua = {},
				vue_ls = {},
			}
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			for server, cfg in pairs(servers) do
				cfg.capabilities = vim.tbl_deep_extend("force", capabilities, cfg.capabilities or {})
				vim.lsp.config(server, cfg)
			end

			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, { "eslint_d", "prettierd", "yamllint" })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup()
		end,
	},
}
