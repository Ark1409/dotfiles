return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local harpoon_extensions = require("harpoon.extensions")
        harpoon:setup()
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

        vim.keymap.set('n', "<leader>a", function() harpoon:list():add() end, { desc = "[A]dd to Harpoon list" })
        vim.keymap.set('n', "<leader>r", function() harpoon:list():remove() end, { desc = "[R]emove from Harpoon list" })

        vim.keymap.set('n', "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<C-y>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<C-e>", function() harpoon:list():next() end)
    end,
    keys = { "<leader>a", "<leader>e", "<leader>r" },
    lazy = true
}
