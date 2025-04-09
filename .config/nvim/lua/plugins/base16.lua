return {
    "Soares/base16.nvim",
    priority = 1000,
    config = function()
        vim.opt.tgc = false
    end,
    cond = function()
        local TERM = vim.env.TERM
        return not TERM or TERM == 'linux'
    end,
    lazy = false
}
