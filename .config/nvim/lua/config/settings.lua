vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.opt.timeoutlen = 250

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

vim.opt.nrformats = "bin,octal,hex,alpha"

-- vim.opt.foldlevel = 20

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

local line_width = 120
vim.opt.textwidth = line_width
vim.opt.colorcolumn:append(tostring(line_width))

-- vim.opt.spell = true
-- vim.opt.spelllang = 'en_us'

vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch)

-- vim.keymap.set({ "n", "x" }, "<leader>sp", "\"+p")
-- vim.keymap.set("n", "<leader>sP", "\"+P", { noremap = true })
-- vim.keymap.set({ "n", "x" }, "<leader>sy", "\"+y")
-- vim.keymap.set("n", "<leader>sY", "\"+Y")

vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })

-- vim.keymap.set("n", "<C-u>", "<NOP>", { noremap = true })
-- vim.keymap.set("n", "<C-d>", "<NOP>", { noremap = true })

-- vim.keymap.set("n", "<C-f>", "<C-f>zz", { noremap = true })
-- vim.keymap.set("n", "<C-b>", "<C-b>zz", { noremap = true })

vim.keymap.set("n", "<leader>riw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { noremap = true })
vim.keymap.set("n", "<leader>riW", ":%s/<C-r><C-a>/<C-r><C-a>/gI<Left><Left><Left>", { noremap = true })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal mode" })

-- vim.keymap.set("n", "<leader>ff", "gg=G<C-o>", { noremap = true, desc = "[F]ormat: [F]ile" })

-- vim.keymap.set("x", ">", ">gv", { noremap = true })
-- vim.keymap.set("x", "<", "<gv", { noremap = true })

vim.keymap.set("x", "<C-J>", ":m '>+1<CR>gv", { noremap = true })
vim.keymap.set("x", "<C-K>", ":m '<-2<CR>gv", { noremap = true })

do
    local yank_augroup = vim.api.nvim_create_augroup("yank-augroup", { clear = true })

    vim.api.nvim_create_autocmd("TextYankPost", {
        group = yank_augroup,
        callback = function()
            vim.highlight.on_yank { timeout = 100 }
        end
    })
end

vim.diagnostic.config {
    underline = true,
    virtual_text = false,
    severity_sort = true,
    update_in_insert = true
}

vim.keymap.set("n", "<leader>tvt", function()
    local old_table = vim.diagnostic.config()
    local new_table = vim.tbl_deep_extend("force", old_table,
        { virtual_text = old_table and not old_table.virtual_text })
    vim.diagnostic.config(new_table)
end, { desc = '[T]oggle [V]irtual [T]ext' })

vim.keymap.set('n', "<C-S-e>", function()
    vim.cmd.Lex()
    local netrw_window = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_width(netrw_window, 40)
end)

use_alternate_theme = false
do
    local TERM = vim.env.TERM
    local OLDTERM = vim.env.OLDTERM
    if TERM == 'linux' or OLDTERM == '1' then
        use_alternate_theme = true
    end
end

vim.api.nvim_create_autocmd('BufReadCmd', {
    pattern = { "*.osz", "osz" },
    group = vim.api.nvim_create_augroup('zip', { clear = false }),
    command = 'vim#Browse(expand("<amatch>"))',
    desc = "Allow reading osz files as zips"
})

