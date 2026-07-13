return {
	-- NoneLs configurations
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			local helpers = require("null-ls.helpers")
			null_ls.setup({
				sources = {
					--builtins
					diagnostics.sqlfluff.with({
						command = vim.fn.expand("~/miniconda3/envs/dbt/bin/sqlfluff"),
					}),
					diagnostics.yamllint,
					formatting.prettierd,
					formatting.shfmt,
					formatting.sqlfluff.with({
						command = vim.fn.expand("~/miniconda3/envs/dbt/bin/sqlfluff"),
					}),
					formatting.stylua,
					-- extras
					{
						name = "xmlformatter",
						method = null_ls.methods.FORMATTING,
						filetypes = { "xml" },
						generator = helpers.formatter_factory({
							command = "xmlformat",
							args = { "--indent", "2", "-" },
							to_stdin = true,
						}),
					},
				},
			})
		end,
	},
}
