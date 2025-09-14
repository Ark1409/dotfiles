return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        { "petertriho/cmp-git", config = true },
        "chrisgrieser/cmp-nerdfont",
        "hrsh7th/cmp-emoji",
        {
            "paopaol/cmp-doxygen",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                "nvim-treesitter/nvim-treesitter-textobjects"
            }
        },
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            dependencies = { "rafamadriz/friendly-snippets" },
            build = function()
                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end,
            config = function()
                require("luasnip").setup()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        },

        "saadparwaiz1/cmp_luasnip",
        "p00f/clangd_extensions.nvim",
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp");
        local luasnip = require('luasnip');
        local lspkind = require('lspkind');

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            sources = cmp.config.sources {
                {
                    name = "nvim_lsp",
                    -- entry_filter = function(entry, ctx) return entry.source.source.client.name ~= 'omnisharp' end -- NO C# autocomplete
                },
                { name = "nvim_lsp_signature_help" },
                { name = "buffer" },
                { name = "path" },
                { name = "git" },
                { name = "nerdfont" },
                { name = "emoji" },
                { name = "doxygen" },
                { name = "luasnip" },
                { name = "lazydev", group_index = 0 }
            },

            completion = { completeopt = "menu,menuone,preview,popup,noinsert,fuzzy" },

            mapping = {
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-8),
                ['<C-f>'] = cmp.mapping.scroll_docs(8),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-X><C-o>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),

                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    end
                end, { "i", "s" }),

                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { "i", "s" }),
            },

            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.recently_used,
                require("clangd_extensions.cmp_scores"),
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },

            window = {
                completion = cmp.config.window.bordered {
                    winhighlight = "Normal:Pmenu,FloatBorder:PmenuMatch,CursorLine:PmenuSel,Search:None"
                },
                documentation = cmp.config.window.bordered {
                    winhighlight = "Normal:Pmenu,FloatBorder:PmenuMatch,CursorLine:PmenuSel,Search:None"
                },
            },

            formatting = {
                format = lspkind.cmp_format({
                    mode = 'text_symbol', -- show only symbol annotations
                    maxwidth = {
                        menu = 50, -- leading text (labelDetails)
                        abbr = 50, -- actual suggestion item
                    },
                    ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    show_labelDetails = true, -- show labelDetails in menu.

                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    before = function(entry, vim_item)
                        return vim_item
                    end
                })
            }
        }

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'nvim_lsp_document_symbol' },
                { name = 'buffer' },
                { name = "nerdfont" },
                { name = "emoji" },
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'nvim_lsp_document_symbol' },
                { name = "nerdfont" },
                { name = "emoji" },
                { name = 'nvim_lsp_document_symbol' },
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                },
            })
        })
    end,
    event = { "InsertEnter", "CmdlineEnter" },
}
