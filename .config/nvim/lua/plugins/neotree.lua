return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        {
            "3rd/image.nvim",
            config = function()
                require("image").setup()
            end,
            lazy = true
        },
    },
    config = function()
        require("neo-tree").setup {
            add_blank_line_at_top = true,
            close_if_last_window = true,
            window = {
                mappings = {
                    ["P"] = {
                        "toggle_preview",
                        config = {
                            use_image_nvim = true
                        }
                    },
                    ["+"] = {
                        "toggle_node",
                    },
                    ["-"] = {
                        "toggle_node",
                    },
                    ["/"] = "filter_as_you_type", -- this was the default until v1.28
                }
            },
            sources = {
                "filesystem",
                "buffers",
                "git_status",
                "document_symbols",
            },
            source_selector = {
                winbar = true,
                statusline = true,
                show_separator_on_edge = false
            },
            filesystem = {
                bind_to_cwd = true,
                filtered_items = {
                    hide_dotfiles = true,
                    hide_hidden = false
                },
                hijack_netrw_behavior = "open_current",
                find_by_full_path_words = true,
                window = {
                    mapping = {
                        ["Z"] = "expand_all_nodes",
                        ["*"] = "expand_all_nodes",
                    }
                }
            }
        }
        vim.keymap.set('n', "<leader>ntt", "<cmd>Neotree toggle reveal<CR>", { desc = "[N]eo[t]ree [T]oggle" })
        vim.keymap.set('n', "<C-S-e>", "<cmd>Neotree toggle reveal<CR>", { desc = "Toggle File [E]xplorer" })
    end,
    event = "VeryLazy",
    cond = false
}
