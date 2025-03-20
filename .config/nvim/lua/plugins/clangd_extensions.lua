return {
    "p00f/clangd_extensions.nvim",
    init = function()
        vim.keymap.set('n', "<leader>sI", vim.cmd.ClangdSwitchSourceHeader, { desc = "[S]witch [I]mplementation" })
    end,
    event = "LspAttach",
    lazy = true
}
