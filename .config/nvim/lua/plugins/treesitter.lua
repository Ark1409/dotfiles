return {
    "nvim-treesitter/nvim-treesitter",

    config = function()
        local configs = require("nvim-treesitter.configs")
        local opts = {
            auto_install = true,
            ensure_installed = { "make", "cmake", "asm", "bash", "java", "c_sharp", "cpp", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "typescript", "javascript", "html", "css" },
            highlight = { enable = true },
            indent = { enable = true },
        }
        configs.setup(opts)
        -- vim.wo.foldmethod = 'expr'
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,

    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,

    event = "VimEnter",
    lazy = true
}
