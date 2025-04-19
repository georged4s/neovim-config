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
                    -- diagnostics.eslint_d,
                    -- diagnostics.shellcheck,
                    diagnostics.sqlfluff.with({
                        command = os.getenv("HOME") .. "/miniconda3/envs/sqlfluff/bin/sqlfluff",
                        filetype = { "sql" },
                    }),
                    -- formatting.beautysh,
                    formatting.black.with({ extra_args = { "--fast" } }),
                    formatting.prettierd,
                    formatting.stylua,
                    formatting.sqlfluff.with({
                        command = os.getenv("HOME") .. "/miniconda3/envs/sqlfluff/bin/sqlfluff",
                        filetype = { "sql" },
                        to_temp_file = false,
                    }),
                },
            })
        end,
    },
}
