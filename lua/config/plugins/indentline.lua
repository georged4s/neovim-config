return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main="ibl",
        opts = {
            indent = { char = "▏" },
            exclude = {
                filetypes = { "undotree", "csv", "json", "txt" },
            },
        },
    },
}
