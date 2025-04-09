return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local harpoon_extensions = require("harpoon.extensions")

        harpoon:setup()
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

        vim.keymap.set('n', "<leader>a", function()
            harpoon:list():add()
            local newItem, index = harpoon:list():get_by_value(vim.fn.bufname(vim.api.nvim_get_current_buf()))
            print("(" .. index .. ")" .. ": Added " .. newItem.value)
        end, { desc = "[A]dd to Harpoon list" })
        vim.keymap.set('n', "<leader>r", function() harpoon:list():remove() end, { desc = "[R]emove from Harpoon list" })

        vim.keymap.set('n', "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set('n', "<leader>c", function() harpoon:list():clear() end)

        vim.keymap.set('n', "<C-1>", function() harpoon:list():select(1) end)
        vim.keymap.set('n', "<C-2>", function() harpoon:list():select(2) end)
        vim.keymap.set('n', "<C-3>", function() harpoon:list():select(3) end)
        vim.keymap.set('n', "<C-4>", function() harpoon:list():select(4) end)
        vim.keymap.set('n', "<C-5>", function() harpoon:list():select(5) end)

        vim.keymap.set('n', "<M-1>", function() harpoon:list():select(1) end)
        vim.keymap.set('n', "<M-2>", function() harpoon:list():select(2) end)
        vim.keymap.set('n', "<M-3>", function() harpoon:list():select(3) end)
        vim.keymap.set('n', "<M-4>", function() harpoon:list():select(4) end)
        vim.keymap.set('n', "<M-5>", function() harpoon:list():select(5) end)

        vim.keymap.set("n", "<C-e>", function() harpoon:list():next() end)
        vim.keymap.set("n", "<C-y>", function() harpoon:list():prev() end)
    end,
    event = "VeryLazy",
    lazy = true,
    cond = false
}

