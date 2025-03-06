return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && pnpm install",
    version = "v0.0.10",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_browser = "zen-browser"
        -- vim.g.mkdp_echo_preview_url = true
        vim.g.mkdp_image_path = vim.fs.joinpath(vim.fn.stdpath('cache'), "/.markdown-preview.nvim/")
    end,
    ft = { "markdown" },
}
