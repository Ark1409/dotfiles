return {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
        processor = "magick_cli",
        integrations = {
            markdown = {
                clear_in_insert_mode = true,
                floating_windows = true
            }
        }
    },
    event = { "BufReadPre", "VeryLazy" },
    cond = function()
        local exepath = vim.fn.exepath("magick")
        return exepath:len() > 0 and vim.fn.executable(exepath)
    end
}
