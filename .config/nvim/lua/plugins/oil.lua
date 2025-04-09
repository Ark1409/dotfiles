return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
        require("oil").setup(opts)
        vim.keymap.set('n', '<C-S-E>', vim.cmd.Oil, { desc = "Open Oil" })
        vim.keymap.set('n', '<M-S-E>', vim.cmd.Oil, { desc = "Open Oil" })
    end,
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
}
