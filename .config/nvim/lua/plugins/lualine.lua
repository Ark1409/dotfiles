return {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = {
            theme = "onedark"
        }
    },
    init = function()
        vim.opt.showmode = false
    end,
    config = true,
    event = "VimEnter"
}
