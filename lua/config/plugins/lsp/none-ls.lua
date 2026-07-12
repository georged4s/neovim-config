return {
	-- NoneLs configurations
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			null_ls.setup({
				sources = {
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
					formatting.xmlformatter,
				},
			})
		end,
	},
}
