return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = {
                    ui = {
                        border = "none",
                        icons = {
                            package_installed = "◍",
                            package_pending = "◍",
                            package_uninstalled = "◍",
                        },
                    },
                    log_level = vim.log.levels.INFO,
                    max_concurrent_installers = 4,
                },
            },
            "williamboman/mason-lspconfig.nvim",
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
                        [vim.diagnostic.severity.HINT] = "",
                    },
                },
                virtual_text = false,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                bashls = {},
                dockerls = {},
                jsonls = {},
                pyright = {},
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
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            hint = { enable = true },
                        },
                    },
                },
                volar = {},
            }

            -- Ensure the servers and tools above are installed
            --
            -- To check the current status of installed tools and/or manually install
            -- other tools, you can run
            --    :Mason
            --
            -- You can press `g?` for help in this menu.
            --
            -- `mason` had to be setup earlier: to configure its options see the
            -- `dependencies` table for `nvim-lspconfig` above.
            --
            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, { "black", "eslint_d", "prettierd", "sqlfluff", "stylua" })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {}, -- explicitly set to an empty table (required servers are installed via mason-tool-installer)
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for ts_ls)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        vim.lsp.config[server_name] = server
                        vim.lsp.enable(server_name)
                    end,
                },
            })
        end,
    },
}
