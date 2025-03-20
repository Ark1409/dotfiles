return {
    "nvim-treesitter/nvim-treesitter-context",

    opts = {
        enabled = true,
        multiwindow = true,
        line_numbers = true,
        min_window_height = 20,
        max_lines = 4,
        -- "topline" might be useful
        mode = "cursor"
    },

    config = function(_, opts)
        require("treesitter-context").setup(opts)

        vim.keymap.set("n", "<leader>tc", "<cmd>TSContextToggle<CR>", { desc = "[T]reesitter [C]ontext Toggle" })
    end,

    event = { "BufReadPost", "InsertEnter" },
    cmd = "TSContextToggle",
    lazy = true
}
