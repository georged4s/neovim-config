-- GeneralSettings
local _general_settings = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    desc = "Press q to quit from certain filetype",
    command = "nnoremap <silent> <buffer> q :close<CR>",
    group = _general_settings,
    pattern = { "qf", "help", "man", "lspinfo", "git", "fugitiveblame", "fugitive" },
})
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
    group = _general_settings,
    pattern = "*",
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    desc = "Disable wrapping comment and adding comment leader (#, --, //) when a newline is created",
    command = "set formatoptions-=cro",
    group = _general_settings,
    pattern = "*",
})
vim.api.nvim_create_autocmd("FileType", {
    desc = "Don't should QuickFix list in the buffer",
    command = "set nobuflisted",
    group = _general_settings,
    pattern = "qf",
})

-- Git
local _git = vim.api.nvim_create_augroup("Git", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
    desc = "Automatically wrap git commit message",
    command = "setlocal wrap",
    group = _git,
    pattern = { "gitcommit" },
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    desc = "Check spelling mistake in git commit message",
    command = "setlocal spell",
    group = _git,
    pattern = { "gitcommit" },
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    desc = "Fugitive specific keymaps",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()

        vim.keymap.set("n", "<leader>f", function()
            vim.cmd.Git("fetch")
        end, { buffer = bufnr, remap = false, desc = "Fetch" })

        vim.keymap.set("n", "<leader>P", function()
            vim.cmd.Git("push")
        end, { buffer = bufnr, remap = false, desc = "Push" })

        vim.keymap.set("n", "<leader>p", function()
            vim.cmd.Git("pull")
        end, { buffer = bufnr, remap = false, desc = "Pull" })

        vim.keymap.set("n", "<leader>b", function()
            vim.cmd.Git("pull --rebase")
        end, { buffer = bufnr, remap = false, desc = "Rebase Pull" })
    end,
    group = _git,
    pattern = "*",
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        if vim.bo.ft ~= "git" then
            return
        end
        local bufnr = vim.api.nvim_get_current_buf()
        -- disable jumping to the next occurrence
        vim.keymap.set("n", "*", "<cmd>keepjumps normal! mi*`i<cr>", { buffer = bufnr, remap = false })
    desc = "Avoid word highlight to jump to the next occurrence in Fugitive",
    end,
    group = _git,
    pattern = "*",
})

-- Markdown
local _markdown = vim.api.nvim_create_augroup("Markdown", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
    desc = "Enable text wrapping in markdown files",
    command = "setlocal wrap",
    group = _markdown,
    pattern = { "markdown" },
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    desc = "Enable linebreak in markdown files",
    command = "setlocal linebreak",
    group = _markdown,
    pattern = { "markdown" },
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    desc = "Enable spelling checks in markdown files",
    command = "setlocal spell",
    group = _markdown,
    pattern = { "markdown" },
})

-- Display
local _auto_resize = vim.api.nvim_create_augroup("AutoResize", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
    desc = "Equalise buffer window when the Vim window size changes",
    command = "tabdo wincmd =",
    group = _auto_resize,
    pattern = { "*" },
})
local _auto_reload = vim.api.nvim_create_augroup("AutoReload", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    desc = "Automatically checks for external file changes and reloads",
    command = "if mode() != 'c' | checktime | endif",
    group = _auto_reload,
    pattern = { "*" },
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end
        vim.cmd([[call fugitive#ReloadStatus()]])
    end,
    desc = "Automatically update git status shown in fugitive",
    group = _auto_reload,
    pattern = { "*" },
})
