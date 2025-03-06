return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",

        -- Change vim.ui.select to use telescope
        "nvim-telescope/telescope-ui-select.nvim",

        -- For faster sorting performance
        { "nvim-telescope/telescope-fzf-native.nvim", build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },

        {
            "nvim-tree/nvim-web-devicons",
            opts = { variant = "dark" },
            cond = vim.g.nerd_font
        }
    },

    config = function()
        local opts = {
            extensions = {
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",
                },

                ["ui-select"] = {
                    require("telescope.themes").get_dropdown()
                }
            }
        }

        require("telescope").setup(opts)

        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "ui-select")

        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
        vim.keymap.set("n", "<leader>sf", function() builtin.find_files({ hidden = true }) end, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch Live [G]rep" })
        vim.keymap.set("n", "<leader>sG", builtin.git_files, { desc = "[S]earch [G]it Files" })
        vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "View [G]it [S]tatus" })
        vim.keymap.set("n", '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set("n", '<leader>se', builtin.diagnostics, { desc = '[S]earch Diagnostics ([E]rrors)' }) -- though they can be warnings, info, etc...
        vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
        vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = '[S]earch [O]ld Files' })
        vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
        vim.keymap.set("n", "<leader>cs", builtin.colorscheme, { desc = 'Change [C]olor[s]cheme' })
        vim.keymap.set("n", "<leader>au", builtin.autocommands, { desc = 'View [A]uto[c]ommands' })
        vim.keymap.set("n", "<leader>man", builtin.man_pages, { desc = 'Open [Man] Pages' })
        vim.keymap.set("n", "<leader>jl", builtin.jumplist, { desc = 'Open [J]ump[l]ist' })
        vim.keymap.set("n", "<leader>hl", builtin.highlights, { desc = 'Open [H]igh[l]ights' })
        vim.keymap.set("n", "<leader>rl", builtin.reloader, { desc = '[R]eload [L]ua Module' })
        vim.keymap.set("n", "<leader>ft", builtin.filetypes, { desc = 'Set [F]ile[t]ype' })
        vim.keymap.set("n", "<leader>ts", builtin.treesitter, { desc = 'Open [T]ree[s]itter' })
        vim.keymap.set("n", "<leader>sH", builtin.search_history, { desc = 'Open [S]earch [H]istory' })

        vim.keymap.set("n", "<leader>ot", builtin.builtin, { desc = "[O]pen [T]elescope" })

        do
            local fuzzy_find_func = function()
                builtin.current_buffer_fuzzy_find({ skip_empty_lines = true })
            end

            vim.keymap.set("n", "<leader>/", fuzzy_find_func, { desc = "[/] Live fuzzy search inside currently open buffer" })
            vim.keymap.set("n", "<leader>fz", fuzzy_find_func, { desc = "Live [f]u[z]zy search inside currently open buffer" })

            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files"
                })
            end, { desc = "[S]earch [/] in open files (Live Grep)" })
        end


        vim.keymap.set("n", "<leader>sc", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
        end, { desc = "[S]earch [C]onfig files" })
    end,

    event = "VimEnter",
    lazy = true
}
