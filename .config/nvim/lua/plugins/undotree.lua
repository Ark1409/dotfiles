return {
    "mbbill/undotree",
    keys = {
        { "<leader>u", function() vim.cmd.UndotreeToggle() vim.cmd.UndotreeFocus() end, { desc = "[U]ndotree Toggle" }, "n" }
    },
    cmd = { "UndotreeShow", "UndotreeHide", "UndotreeToggle" }
}
