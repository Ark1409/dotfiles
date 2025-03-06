vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- util
vim.g.nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitbelow = false
vim.opt.splitright = true

-- CursorHold + swapfile timeout line
vim.opt.updatetime = 1000

-- Timeout for key sequence (e.g. <leader>+something)
vim.opt.timeoutlen = 300

vim.opt.swapfile = false

vim.opt.signcolumn = "yes"

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

vim.opt.cursorline = true
vim.opt.guicursor = "n-i-v-c-ci-cr:block,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.scrolloff = 5
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set({ "n", "x" }, "<leader>sp", "\"+p")
vim.keymap.set("n", "<leader>sP", "\"+P", { noremap = true })
vim.keymap.set({ "n", "x" }, "<leader>sy", "\"+y")

vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set({ "n", "x" }, "<leader>y", "\"+y")

vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })

vim.keymap.set("n", "<leader>riw", ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>", { noremap = true })
vim.keymap.set("n", "<leader>riW", ":%s/<C-r><C-a>/<C-r><C-a>/gI<Left><Left><Left>", { noremap = true })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>ff", "gg=G<C-o>", { noremap = true, desc = "[F]ormat: [F]ile" })

do
    local yank_augroup = vim.api.nvim_create_augroup("yank-augroup", { clear = true })

    vim.api.nvim_create_autocmd("TextYankPost", {
        group = yank_augroup,
        callback = function()
            vim.highlight.on_yank{ timeout = 100 }
        end
    })
end

vim.diagnostic.config{
    underline = true,
    virtual_text = false,
    severity_sort = true,
    update_in_insert = true
}
