return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            theme = "onedark"
        }
    },
    config = function(_, opts)
        require("lualine").setup(opts)
        vim.opt.showmode = false
    end,
    event = "VimEnter"
}
