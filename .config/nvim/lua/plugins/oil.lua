return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        lsp_file_methods = {
            enabled = true,
            autosave_changes = "unmodified"
        },
        git = {
            add = function() return true end,
            rm = function() return true end,
            mv = function() return true end
        },
        float = {
            border = "single"
        },
        win_options = {
            cc = ""
        }
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
        require("oil").setup(opts)
        vim.keymap.set('n', '<C-S-E>', function()
            vim.cmd.Oil()
        end, { desc = "Open Oil" })
        vim.keymap.set('n', '<M-S-E>', vim.cmd.Oil, { desc = "Open Oil" })
    end,
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
}
