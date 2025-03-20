return {
    "neovim/nvim-lspconfig",

    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = {
                {
                    "williamboman/mason.nvim",
                    opts = {
                        ui = {
                            icons = {
                                package_installed = "✓",
                                package_pending = "➜",
                                package_uninstalled = "✗"
                            }
                        }
                    },
                    init = function()
                        vim.keymap.set("n", "<leader>om", vim.cmd.Mason, { desc = "[O]pen [M]ason" })
                    end
                }
            },
        },
        "nvim-telescope/telescope.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "Hoffs/omnisharp-extended-lsp.nvim",
        { "j-hui/fidget.nvim", opts = {} }
    },

    config = function()
        -- Lsp Attach config
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                if not client then
                    return
                end

                -- Highlight references on cursor hold
                if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, { bufnr = args.buf }) then
                    local lsp_buf_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = true })

                    local diag_namespace = vim.api.nvim_create_namespace("lsp-cursorhold")
                    vim.diagnostic.config({ virtual_text = true }, diag_namespace)

                    -- Timer on which to show line diagnostics
                    local hover_timer = vim.uv.new_timer()

                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        group = lsp_buf_augroup,
                        callback = vim.lsp.buf.document_highlight,
                        buffer = args.buf
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        group = lsp_buf_augroup,
                        callback = vim.lsp.buf.clear_references,
                        buffer = args.buf
                    })

                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        group = lsp_buf_augroup,
                        callback = function(args2)
                            local function show_diags_callback()
                                for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                                    local win_config = vim.api.nvim_win_get_config(win_id)
                                    if win_config.zindex and win_config.focusable then
                                        -- Assume a float is visible
                                        return
                                    end
                                end

                                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                                local line_diags = vim.diagnostic.get(args2.buf, { lnum = (cursor_pos[1] or 1) - 1 });

                                local has_diag = vim.iter(line_diags):any(function(diag)
                                    return cursor_pos[2] >= diag.col and cursor_pos[2] <= diag.end_col
                                end)

                                if has_diag then
                                    vim.diagnostic.open_float { bufnr = args2.buf, scope = 'cursor' }
                                elseif client.supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
                                    vim.lsp.buf.hover()
                                end
                            end

                            if hover_timer then
                                hover_timer:stop()
                                hover_timer:start(3000, 0, vim.schedule_wrap(show_diags_callback))
                            end
                        end,
                        buffer = args.buf
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "TextChanged" }, {
                        group = lsp_buf_augroup,
                        callback = function(args2)
                            vim.diagnostic.reset(diag_namespace, args2.buf)

                            local cursor_pos = vim.api.nvim_win_get_cursor(0)
                            local line_diags = vim.diagnostic.get(args2.buf, { lnum = (cursor_pos[1] or 1) - 1 });

                            local valid_line_diags;
                            do
                                local global_conf = vim.diagnostic.config()
                                valid_line_diags = vim.iter(line_diags):filter(function(diag)
                                    local namespace_conf = vim.diagnostic.config(nil, diag.namespace)
                                    if namespace_conf and namespace_conf.virtual_text ~= nil then return not namespace_conf.virtual_text end
                                    if global_conf and global_conf.virtual_text ~= nil then return not global_conf.virtual_text end
                                    return false
                                end):totable()
                            end

                            vim.diagnostic.show(diag_namespace, args2.buf, valid_line_diags, { virtual_text = true })
                        end,
                        buffer = args.buf
                    })

                    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
                        group = lsp_buf_augroup,
                        callback = function(args2)
                            vim.diagnostic.reset(diag_namespace, args2.buf)
                        end,
                        buffer = args.buf
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                        callback = function(args2)
                            if hover_timer then
                                hover_timer:stop()
                                hover_timer:close()
                            end
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = lsp_buf_augroup }
                        end,
                        buffer = args.buf
                    })
                end

                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
                end

                map('<leader>ca', vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v" })

                if client and client.name == 'omnisharp' then
                    map('gd', require('omnisharp_extended').telescope_lsp_definition, "[G]o to [D]efinition",
                        { "n", "v" })
                    map("<leader>gD", require('omnisharp_extended').telescope_lsp_type_definition,
                        "[G]o to [T]ype [D]efinition", { "n", "v" })
                    map("gtd", require('omnisharp_extended').telescope_lsp_type_definition,
                        "[G]o to [T]ype [D]efinition", { "n", "v" })
                    map("<leader>gr", require('omnisharp_extended').telescope_lsp_references, "[G]o to [R]eferences",
                        { "n", "v" })
                    map('gI', require('omnisharp_extended').telescope_lsp_implementation, "[G]o to [I]mplementation")
                else
                    map('gd', require('telescope.builtin').lsp_definitions, "[G]o to [D]efinition", { "n", "v" })
                    map("<leader>gD", require("telescope.builtin").lsp_type_definitions, "[G]o to [T]ype [D]efinition",
                        { "n", "v" })
                    map("gtd", require("telescope.builtin").lsp_type_definitions, "[G]o to [T]ype [D]efinition",
                        { "n", "v" })
                    map("<leader>gr", require("telescope.builtin").lsp_references, "[G]o to [R]eferences", { "n", "v" })
                    map('gI', require('telescope.builtin').lsp_implementations, "[G]o to [I]mplementation")
                end

                map('gD', vim.lsp.buf.declaration, "[G]o to [D]eclaration", { "n", "v" })

                map('<leader>rn', vim.lsp.buf.rename, "[R]e[n]ame", { "n", "v" })
                map('<leader>td', require('telescope.builtin').lsp_type_definitions, '[T]ype [D]efinition', { "n", "v" })
                map('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch [S]ymbols')
                map('<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    '[S]earch [W]orkspace [S]ymbols')
                map('<leader>sd', require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics') -- though they can be warnings, info, etc...
                map('<leader>ff', function() vim.lsp.buf.format { async = true } end, '[F]ormat: [F]ile')
                map("<leader>dt", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
                    "Toggle [D]iagnostics", { "n", "v" })
                map("<leader>do", vim.diagnostic.open_float, "[D]iagnostics [O]pen", { "n", "v" })
                map("<leader>ds", vim.diagnostic.open_float, "[D]iagnostics [S]how", { "n", "v" })
                map("<leader>dc", vim.diagnostic.hide, "[D]iagnostics [C]lose", { "n", "v" })
                map('<leader>gic', require('telescope.builtin').lsp_incoming_calls, '')
                map('<leader>goc', require('telescope.builtin').lsp_outgoing_calls, '')

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, { bufnr = args.buf }) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
                    end, "[T]oggle Inlay [H]ints")
                    vim.lsp.inlay_hint.enable() -- Enable by default
                end

                if client.name == 'jdtls' then
                    map("<leader>fo", require('jdtls').organize_imports, "[F]ormat: [O]rganize Imports", { "n", "v" })
                    map("<leader>gs", require('jdtls').super_implementation, "[G]o to [S]uper Implementation",
                        { "n", "v" })
                end
            end,
        })

        local cap = vim.lsp.protocol.make_client_capabilities()
        cap = vim.tbl_deep_extend("force", cap, require("cmp_nvim_lsp").default_capabilities())

        local handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup {
                    capabilities = cap
                }
            end,

            ["jdtls"] = function() end, -- jdtls handled by nvim-jdtls

            ["bashls"] = function()
                require("lspconfig").bashls.setup {
                    capabilities = cap,
                    filetypes = { "bash", "sh", "*.sh" }
                }
            end,

            ["clangd"] = function()
                require("lspconfig").clangd.setup {
                    filetypes = { "h", "hpp", "tcc", "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                    capabilities = cap
                }
            end,

            ["omnisharp"] = function()
                local config = {
                    handlers = {
                        ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
                        ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
                        ["textDocument/references"] = require('omnisharp_extended').references_handler,
                        ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
                    },
                    capabilities = cap
                }
                require("lspconfig").omnisharp.setup(config)
            end
        };

        local mason_lspconfig_opts = {
            ensure_installed = { "jdtls", "clangd", "lua_ls", "bashls", "omnisharp", "cmake", "asm_lsp" },
            automatic_installation = true,
        };

        require("mason-lspconfig").setup(mason_lspconfig_opts)
        require("mason-lspconfig").setup_handlers(handlers)
    end,
    event = { "BufReadPost", "VeryLazy" }
}
