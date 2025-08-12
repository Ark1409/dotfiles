return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        auto_install = true,
        ensure_installed = { "make", "cmake", "asm", "bash", "java", "c_sharp", "cpp", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "typescript", "javascript", "html", "css" },
        highlight = { enable = true },
        indent = { enable = true },
    },
    config = function(_, opts)
        local configs = require("nvim-treesitter.configs")
        configs.setup(opts)
        -- vim.api.nvim_create_autocmd("FileType", {
        --     callback = function()
        --         if require("nvim-treesitter.parsers").has_parser() then
        --             vim.wo.foldmethod = 'expr'
        --             vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        --         end
        --     end
        -- })
    end,

    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,

    event = { "BufReadPost", "InsertEnter" },
    lazy = true
}
