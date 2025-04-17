return {
    settings = {
        sqls = {
            lowercaseKeywords = true,
        },
    },
    cmd = { "/home/george/.local/share/nvim/mason/bin/sqls", "--config", vim.loop.cwd() .. "/sqls.yml" },
}
