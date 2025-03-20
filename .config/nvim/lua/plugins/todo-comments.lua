return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    init = function()
        vim.keymap.set('n', "<leader>st", vim.cmd.TodoTelescope, { desc = "[S]earch [T]odo" })
    end,
    event = { "BufReadPost", "InsertEnter" }
}
