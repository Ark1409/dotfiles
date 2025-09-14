return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "mason-org/mason-lspconfig.nvim",
            dependencies = {
                {
                    "mason-org/mason.nvim",
                    opts = {
                        ui = {
                            icons = {
                                package_installed = "✓",
                                package_pending = "➜",
                                package_uninstalled = "✗"
                            }
                        },
                        registries = {
                            "github:mason-org/mason-registry",
                            "github:Crashdummyy/mason-registry",
                        },
                    },
                    config = function(_, opts)
                        require("mason").setup(opts)
                        vim.keymap.set("n", "<leader>om", vim.cmd.Mason, { desc = "[O]pen [M]ason" })
                    end
                }
            },
        },
        "nvim-telescope/telescope.nvim",
        -- "hrsh7th/cmp-nvim-lsp",
        "Hoffs/omnisharp-extended-lsp.nvim",
        -- "Decodetalkers/csharpls-extended-lsp.nvim",
        { "j-hui/fidget.nvim", opts = {} }
    },

    config = function()
        -- require("telescope").load_extension("csharpls_definition")
        -- require("csharpls_extended").buf_read_cmd_bind()

        -- LSP Attach config
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                if not client then return end

                -- Highlight references on cursor hold
                if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, args.buf) then
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
                                elseif client.supports_method(vim.lsp.protocol.Methods.textDocument_hover, args2.buf) then
                                    vim.lsp.buf.hover()
                                end
                            end

                            if hover_timer then
                                hover_timer:stop()
                                hover_timer:start(10000, 0, vim.schedule_wrap(show_diags_callback))
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
                                    if namespace_conf and namespace_conf.virtual_text ~= nil then return not
                                        namespace_conf.virtual_text end
                                    if global_conf and global_conf.virtual_text ~= nil then return not global_conf
                                        .virtual_text end
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

                    vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold", "BufEnter" }, {
                        group = lsp_buf_augroup,
                        callback = function(args2)
                            vim.lsp.codelens.refresh({ bufnr = args2.buf });
                        end,
                        buffer = args.buf
                    })

                    vim.api.nvim_create_autocmd({ "BufEnter" }, {
                        group = lsp_buf_augroup,
                        callback = function(args2)
                            vim.lsp.inlay_hint.enable(true, {
                                bufnr = args2.buf
                            });
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

                local should_autofold = true
                if should_autofold then
                    vim.api.nvim_create_autocmd("LspNotify", {
                        group = vim.api.nvim_create_augroup("lsp-notify", { clear = true }),
                        callback = function(args2)
                            if args2.data.method == vim.lsp.protocol.Methods.textDocument_didOpen then
                                if client.supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
                                    if vim.bo.filetype == 'cs' then
                                        local win_id = vim.api.nvim_get_current_win()
                                        vim.wo[win_id][0].foldmethod = 'expr'
                                        vim.wo[win_id][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
                                        vim.wo[win_id][0].foldlevel = 9999
                                        -- vim.print("Closing all region and import folds...")
                                        vim.lsp.foldclose('region', win_id)
                                        vim.lsp.foldclose('imports', win_id)
                                    end
                                end
                            end
                        end,
                        buffer = args.buf
                    })
                end

                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
                end

                if client and client.name == 'omnisharp' then
                    map('gd', require('omnisharp_extended').telescope_lsp_definition, "[G]o to [D]efinition",
                        { "n", "v" })
                    map("gtd", require('omnisharp_extended').telescope_lsp_type_definition,
                        "[G]o to [T]ype [D]efinition", { "n", "v" })
                    map("<leader>gr", require('omnisharp_extended').telescope_lsp_references, "[G]o to [R]eferences",
                        { "n", "v" })
                    map("grr", require('omnisharp_extended').telescope_lsp_references, "[G]o to [R]eferences",
                        { "n", "v" })
                    map('gri', require('omnisharp_extended').telescope_lsp_implementation, "[G]o to [I]mplementation")
                else
                    map('gd', require('telescope.builtin').lsp_definitions, "[G]o to [D]efinition", { "n", "v" })
                    map("gtd", require("telescope.builtin").lsp_type_definitions, "[G]o to [T]ype [D]efinition",
                        { "n", "v" })
                    map("grr", require("telescope.builtin").lsp_references, "[G]o to [R]eferences", { "n", "v" })
                    map('gri', require('telescope.builtin').lsp_implementations, "[G]o to [I]mplementation")
                end

                map('gD', vim.lsp.buf.declaration, "[G]o to [D]eclaration", { "n", "v" })

                map('<leader>td', require('telescope.builtin').lsp_type_definitions, '[T]ype [D]efinition', { "n", "v" })
                map('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch [S]ymbols')
                map('<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    '[S]earch [W]orkspace [S]ymbols')
                -- map('<leader>sd', require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics')
                -- map('<leader>ff', function() vim.lsp.buf.format { async = true } end, '[F]ormat: [F]ile')
                map("<leader>dt", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
                    "Toggle [D]iagnostics", { "n", "v" })
                map("<leader>ds", vim.diagnostic.open_float, "[D]iagnostics [S]how", { "n", "v" })
                map("<leader>dc", vim.diagnostic.hide, "[D]iagnostics [C]lose", { "n", "v" })
                map('gric', require('telescope.builtin').lsp_incoming_calls, '[I]ncoming [C]alls')
                map('groc', require('telescope.builtin').lsp_outgoing_calls, '[O]utgoing [C]alls')

                map('<leader>sad', vim.diagnostic.setqflist, '{S}earch [A]ll [D]iagnostics')

                if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, args.buf) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
                    end, "[T]oggle Inlay [H]ints")
                    vim.lsp.inlay_hint.enable() -- Enable by default
                end

                if client.name == 'jdtls' then
                    map("<leader>fo", require('jdtls').organize_imports, "[F]ormat: [O]rganize Imports", { "n", "v" })
                    map("grs", require('jdtls').super_implementation, "[G]o to [S]uper Implementation",
                        { "n", "v" }) -- why would i ever use `gs` to sleep
                end
            end,
        })

        local default_cap = vim.lsp.protocol.make_client_capabilities()
        local cap = vim.tbl_deep_extend("force", {}, default_cap, require("cmp_nvim_lsp").default_capabilities())

        local handlers = {
            function(server_name)
                return {
                    capabilities = cap
                }
            end,

            ["jdtls"] = function() end, -- jdtls handled by nvim-jdtls

            ["bashls"] = function()
                return {
                    capabilities = cap,
                    filetypes = { "bash", "sh" }
                }
            end,

            ["clangd"] = function()
                return {
                    filetypes = { "h", "hpp", "tcc", "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                    capabilities = cap
                }
            end,

            -- ["csharp_ls"] = function()
            --     return {
            --         root_dir = function(bufnr, on_dir)
            --             local fname = vim.api.nvim_buf_get_name(bufnr)
            --             local util = require('lspconfig.util')
            --             on_dir(util.root_pattern '*.slnf' (fname) or util.root_pattern '*.sln' (fname))
            --         end,
            --         handlers = {
            --             ["textDocument/definition"] = require('csharpls_extended').definition,
            --             ["textDocument/typeDefinition"] = require('csharpls_extended').type_definition,
            --         },
            --     };
            -- end

            ["omnisharp"] = function()
                return {
                    handlers = {
                        ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
                        ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
                        ["textDocument/references"] = require('omnisharp_extended').references_handler,
                        ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
                    },
                    capabilities = cap,
                    root_markers = { ".slnf", ".sln", ".csproj", "omnisharp.json", "function.json" },
                    settings = {
                        FormattingOptions = {
                            OrganizeImports = true
                        },
                        RoslynExtensionsOptions = {
                            EnableAnalyzersSupport = true,
                            AnalyzeOpenDocumentsOnly = true,
                            EnableImportCompletion = true,
                            EnableDecompilationSupport = true,
                            enableDecompilationSupport = true
                        }
                    }
                }
            end,
            ["roslyn"] = function()
                return {
                    capabilities = cap,
                    root_markers = { ".slnf", ".sln", ".csproj", "omnisharp.json", "function.json" },
                    settings = {
                        ['csharp|inlay_hints'] = {
                            csharp_enable_inlay_hints_for_implicit_object_creation = true,
                            csharp_enable_inlay_hints_for_implicit_variable_types = true,
                            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                            csharp_enable_inlay_hints_for_types = true,
                            dotnet_enable_inlay_hints_for_indexer_parameters = true,
                            dotnet_enable_inlay_hints_for_literal_parameters = true,
                            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                            dotnet_enable_inlay_hints_for_other_parameters = true,
                            csharp_enable_inlay_hints_for_lambda_parameters = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                        },
                        ['csharp|code_lens'] = {
                            dotnet_enable_references_code_lens = true,
                            dotnet_enable_tests_code_lens = true,
                        },
                        ['csharp|completion'] = {
                            dotnet_provide_regex_completions = true,
                            dotnet_show_completion_items_from_unimported_namespaces = true,
                            dotnet_show_name_completion_suggestions = true,
                        },
                        ['csharp|symbol_search'] = {
                            dotnet_search_reference_assemblies = true,
                        },
                        ['csharp|formatting'] = {
                            dotnet_organize_imports_on_format = true,
                        }
                    }
                }
            end
        };

        -- Servers to be automagically installed and configured
        local auto_servers = { "jdtls", "clangd", "lua_ls", "bashls", "cmake", "asm_lsp", "ts_ls", "eslint",
            "emmet_language_server",
        };

        do
            local config_servers = vim.tbl_extend('force', {}, auto_servers);

            for server, _ in pairs(handlers) do
                if type(server) == 'string' then
                    if server ~= 'omnisharp' then
                        table.insert(config_servers, server)
                    end
                end
            end


            for _, server in ipairs(config_servers) do
                local config_table = nil;

                do
                    local func = handlers[server]
                    if func ~= nil then
                        config_table = func();
                    end
                end
                if config_table == nil then
                    local func = handlers[1];
                    if func ~= nil then
                        config_table = func(server);
                    end
                end
                if config_table ~= nil then
                    if type(config_table) == 'table' then
                        local old_table = vim.lsp.config[server] or {};
                        local new_table = vim.tbl_deep_extend('force', old_table, config_table)
                        vim.lsp.config(server, new_table);
                        -- vim.print("The merged table for " .. server .. " is ", new_table, "what i merged in was:", config_table)
                    end
                end
            end

            vim.lsp.enable(config_servers)
        end

        local mason_lspconfig_opts = {
            ensure_installed = auto_servers,
            automatic_enable = false,
        };

        require("mason-lspconfig").setup(mason_lspconfig_opts)
    end,
    event = { "BufReadPost", "VeryLazy" },
}
