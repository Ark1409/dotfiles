return {
    "tpope/vim-fugitive",
    ft = { "gitcommit" },
    keys = {
        { mode = 'n', "<leader>G", vim.cmd.Git, desc = "Open Fu[g]itive" },
        { mode = 'n', "<leader>g", vim.cmd.Git, desc = "Open Fu[g]itive" }
    },
    cmd = { "Git" },
    config = function()
        vim.api.nvim_create_autocmd({ 'DiffUpdated' }, {
            callback = function(args)
                local win_ids = vim.fn.win_findbuf(args.buf);
                local main_win_id = nil;
                for _, win in ipairs(win_ids) do
                    if vim.wo[win].diff then
                        if vim.api.nvim_buf_get_name(args.buf):match('^fugitive://') then
                            vim.keymap.set({ 'n', 'v' }, 'dp', '<cmd>diffput //1<CR><cmd>windo diffupdate<CR>',
                                { buffer = true, desc = "diffput keymap for merge conflicts" })
                        else
                            if not vim.api.nvim_buf_get_name(args.buf):find('//') then
                                main_win_id = win;
                            end
                        end
                        vim.keymap.set({ 'n', 'v' }, 'dg',
                            function()
                                local bufinfo = nil;
                                repeat
                                    local result = vim.fn.input { prompt = 'Get diff from which buffer?: ' };

                                    if #result == 0 then return end

                                    local bufs = vim.api.nvim_list_bufs();

                                    for _, buf in ipairs(bufs) do
                                        if vim.api.nvim_buf_get_name(buf):match('^fugitive://') then
                                            local name = vim.api.nvim_buf_get_name(buf);
                                            if name:match(".*" .. result .. ".*") then
                                                bufinfo = { buf = buf, name = name };
                                                break;
                                            end
                                        end
                                    end

                                    if bufinfo == nil then
                                        vim.print("buffer name '" .. result .. "' not found");
                                    end
                                until bufinfo ~= nil
                                assert(bufinfo ~= nil);

                                local original_win = vim.api.nvim_get_current_win();
                                vim.cmd("diffget " .. bufinfo.name);
                                vim.cmd("windo diffupdate");
                                vim.api.nvim_set_current_win(original_win);
                            end,
                            { buffer = true, desc = "diffget keymap for merge conflicts", noremap = true });
                        vim.keymap.set({ 'n', 'v' }, 'gdh', function()
                            local original_win = vim.api.nvim_get_current_win();
                            vim.cmd("diffget //2");
                            vim.cmd("windo diffupdate");
                            vim.cmd("norm ]c");
                            vim.api.nvim_set_current_win(original_win);
                        end, { buffer = true });
                        vim.keymap.set({ 'n', 'v' }, 'gdl', function()
                            local original_win = vim.api.nvim_get_current_win();
                            vim.cmd("diffget //3");
                            vim.cmd("windo diffupdate");
                            vim.cmd("norm ]c");
                            vim.api.nvim_set_current_win(original_win);
                        end, { buffer = true });
                    else
                    end
                end
                if main_win_id ~= nil then
                    vim.keymap.set({ 'n', 'v' }, 'gdo', function()
                        vim.api.nvim_set_current_win(main_win_id);
                        vim.cmd.update();
                        local wins = vim.api.nvim_tabpage_list_wins(0);
                        for _, win in ipairs(wins) do
                            if win ~= main_win_id then
                                local win_buf = vim.api.nvim_win_get_buf(win);
                                local buf_path = vim.api.nvim_buf_get_name(win_buf);
                                if buf_path:match('.*//[0-9]+.*') then
                                    vim.api.nvim_win_close(win, false);
                                end
                            end;
                        end
                        vim.cmd("wincmd =")
                        vim.print('WE DID IT')
                    end, { buffer = true });
                end
            end
        })

        -- A bit hacky :/
        vim.api.nvim_create_autocmd({ 'DiffUpdated' }, {
            callback = function(args)
                local win_ids = vim.fn.win_findbuf(args.buf);
                for _, win in ipairs(win_ids) do
                    if vim.wo[win].diff then
                        if vim.api.nvim_buf_get_name(args.buf):match('^fugitive://') then
                            -- only in vertical diff split
                            if vim.api.nvim_win_get_width(win) * 100 / vim.o.columns < vim.api.nvim_win_get_height(win) * 100 / vim.o.lines then
                                vim.cmd('wincmd _')
                            end
                        end
                    else
                    end
                end
            end,
            once = true
        })
    end,
    lazy = true
}
