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
        local conform = require("conform");
        conform.setup(opts)
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

        vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePre' }, {
            callback = function()
                local last_edit_start = vim.fn.getpos("'[")
                local last_edit_end = vim.fn.getpos("']")
                local last_edit_end_col = vim.fn.col { last_edit_end[2], '$' };

                conform.format({
                    range = {
                        start = { last_edit_start[2], 0 },
                        ["end"] = { last_edit_end[2], last_edit_end_col - 1 }
                    },
                    async = true
                })
            end,
            desc = "conform.nvim auto format after insert"
        });
    end,
    event = { "FileType" }
}
