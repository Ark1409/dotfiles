return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '-' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    },
    init = function()
        vim.keymap.set('n', "<leader>ogs", "<cmd>Gitsigns<CR>", { noremap = true, desc = "[O]pen [G]it[s]igns" })
        vim.keymap.set('n', "<leader>gsr", "<cmd>Gitsigns refresh<CR>", { noremap = true, desc = "[G]itsigns: [R]efresh" })
        vim.keymap.set('n', "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { noremap = true, desc = "[G]itsigns: [T]oggle Line [B]lame" })
        vim.keymap.set('n', "<leader>bl", "<cmd>Gitsigns blame_line<CR>", { noremap = true, desc = "[G]itsigns: [B]lame [L]ine" })
        vim.keymap.set('n', "<leader>gtfb", "<cmd>Gitsigns blame<CR>", { noremap = true, desc = "[G]itsigns: [T]oggle [F]ull [B]lame" })
        vim.keymap.set('n', "<leader>gtd", "<cmd>Gitsigns toggle_word_diff<CR>", { noremap = true, desc = "[G]itsigns: [T]oggle Word [D]iff" })
        vim.keymap.set('n', "<leader>god", "<cmd>Gitsigns diff_this<CR>", { noremap = true, desc = "[G]itsigns: [O]pen [D]iff" })
        vim.keymap.set('n', "<leader>gsh", "<cmd>Gitsigns stage_hunk<CR>", { noremap = true, desc = "[G]itsigns: [S]tage [H]unk" })
        vim.keymap.set('n', "<leader>gush", "<cmd>Gitsigns undo_stage_hunk<CR>", { noremap = true, desc = "[G]itsigns: [U]n[s]tage [H]unk" })
        vim.keymap.set('n', "<leader>gnh", "<cmd>Gitsigns next_hunk<CR>", { noremap = true, desc = "[G]itsigns: [N]ext [H[unk" })
        vim.keymap.set('n', "<leader>gph", "<cmd>Gitsigns prev_hunk<CR>", { noremap = true, desc = "[G]itsigns: [P]revious [H]unk" })
        vim.keymap.set('n', "]h", "<cmd>Gitsigns next_hunk<CR>", { noremap = true, desc = "Gitsigns Next Hunk" })
        vim.keymap.set('n', "[h", "<cmd>Gitsigns prev_hunk<CR>", { noremap = true, desc = "Gitsigns Previous Hunk" })
        vim.keymap.set('n', "<leader>gvh", "<cmd>Gitsigns preview_hunk<CR>", { noremap = true, desc = "[G]itsigns: Pre[v]iew [H]unk" })
    end,
    config = function(_, opts)
        local git_signs = require("gitsigns")
        git_signs.setup(opts)
        git_signs.toggle_current_line_blame(true)
        git_signs.toggle_numhl(true)
    end,
    event = { "BufReadPost", "InsertEnter" },
    lazy = true,
}
