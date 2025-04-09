return {
    "p00f/clangd_extensions.nvim",
    config = function()
        vim.keymap.set('n', "<C-7>", vim.cmd.ClangdSwitchSourceHeader, { desc = "clangd: Switch Implementation" })
    end,
    event = "LspAttach",
    lazy = true
}
