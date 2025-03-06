return {
    "nvim-treesitter/nvim-treesitter-context",

    config = function()
        local opts = {
            enabled = true,
            multiwindow = true,
            line_numbers = true,
            min_window_height = 20,
            max_lines = 4,
            -- "topline" might be useful
            mode = "cursor"
        }

        require("treesitter-context").setup(opts)

        vim.keymap.set("n", "<leader>ct", "<cmd>:TSContextToggle<CR>", { desc = "[C]ontext [T]oggle for TreeSitter" })
    end,

    event = "VeryLazy",
    lazy = true
}
