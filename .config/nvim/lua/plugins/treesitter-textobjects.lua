return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "lewis6991/gitsigns.nvim"
    },
    opts = {
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",

                    ["aP"] = "@parameter.outer",
                    ["iP"] = "@parameter.inner",

                    ["il"] = "@loop.inner",
                    ["al"] = "@loop.outer",

                    ["iC"] = "@class.inner",
                    ["aC"] = "@class.outer",

                    ["ic"] = "@conditional.inner",
                    ["ac"] = "@conditional.outer",
                },
                selection_modes = {
                    ['@parameter.outer'] = 'v',
                    ['@function.outer'] = 'V',
                    ['@class.outer'] = 'V',
                },
            },
            lsp_interop = {
                enable = true,
                border = 'none',
                floating_preview_opts = {},
                peek_definition_code = {
                    ["<leader>pfd"] = "@function.outer",
                    ["<leader>pCd"] = "@class.outer",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold start" },
                    ["]o"] = { query = "@loop.*", query_group = "folds", desc = "Next loop start" },
                },
                goto_previous_start = {
                    ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold start" },
                    ["[o"] = { query = "@loop.*", query_group = "folds", desc = "Previous loop start" },
                },
                goto_next_end = {
                    ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold end" },
                    ["]O"] = { query = "@loop.*", query_group = "folds", desc = "Next loop end" },
                },
                goto_previous_end = {
                    ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold end" },
                    ["[O"] = { query = "@loop.*", query_group = "folds", desc = "Previous loop end" },
                }
            }
        }
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
        local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

        local gs = require("gitsigns")
        local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
        vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat)
        vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat)
    end,
    event = { "BufReadPost", "InsertEnter" },
    lazy = true,
    cond = true
}
