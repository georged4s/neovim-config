return {
    -- NoneLs configurations
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics
            null_ls.setup({
                debug = false,
                sources = {
                    diagnostics.sqlfluff.with({
                        command = os.getenv("HOME") .. "/miniconda3/envs/sqlfluff/bin/sqlfluff",
                        extra_args = { "--config", "$ROOT/dbt/.sqlfluff" },
                    }),
                    formatting.shfmt,
                    formatting.black.with({ extra_args = { "--fast" } }),
                    formatting.prettierd,
                    formatting.stylua,
                    formatting.sqlfluff.with({
                        command = os.getenv("HOME") .. "/miniconda3/envs/sqlfluff/bin/sqlfluff",
                        extra_args = { "--config", "$ROOT/dbt/.sqlfluff" },
                    }),
                },
            })
        end,
    },
}
