return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            cpp = { "clang-format" },
            rust = { "rustfmt" }
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
    },
    config = function (_, opts)
        require("conform").setup(opts)
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    event = { "FileType" }
}
