return {
    "Soares/base16.nvim",
    priority = 1000,
    config = function()
        vim.opt.tgc = false
        vim.opt.cursorline = false
        -- vim.opt.guicursor = "n-i-v-c-ci-cr:block,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"
        vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"
        vim.cmd('colorscheme unokai')
    end,
    cond = use_alternate_theme,
    lazy = false
}
