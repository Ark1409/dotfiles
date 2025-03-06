return {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
        style = "deep",
        transparent = false,
        code_style = {
            keywords = "bold"
        },
        diagnostics = {
            undercurl = false,
            background = false
        },
        toggle_style_key = "<leader>ts",
        ending_tildes = true,
        lualine = {
            transparent = false
        },
        highlights = {
            ["@lsp.type.modifier.java"] = { fg = '$purple' },
            ["@type.builtin"] = { fg = '$purple' },
        }
    },
    config = function(_, opts)
        require('onedark').setup(opts)
        require('onedark').load()
    end,
}
