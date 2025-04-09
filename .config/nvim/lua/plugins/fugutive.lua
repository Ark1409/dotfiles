return {
    "tpope/vim-fugitive",
    cmd = { "Git" },
    config = function()
        vim.keymap.set('n', "<leader>G", vim.cmd.Git, { desc = "Open Fu[g]itive" })
    end,
    lazy = true
}
