return {
    "mfussenegger/nvim-jdtls",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        local jdtls_augroup = vim.api.nvim_create_augroup("jdtls-ft", { clear = true })
        vim.api.nvim_create_autocmd("FileType",
            {
                group = jdtls_augroup,
                pattern = { "java", "*.java" },
                desc = "jdtls *.java file hook",
                callback = function(args)
                    local root_dir = vim.fs.root(0,
                        { ".git", "mvnw", "gradlew", "pom.xml", "build.xml", "settings.gradle", "settings.gradle.kts" })
                    if not root_dir then
                        error("Unable find root dir for java project from " .. vim.fn.bufname(args.buf))
                    end

                    local jdtls_dir = require("mason-registry").get_package("jdtls"):get_install_path()

                    local launcher_jar_candidates = vim.fs.find(function(name, _)
                        local jar_prefix = "^org%.eclipse%.equinox%.launcher"
                        local jar_patterns = { jar_prefix .. "_.*%.jar$", jar_prefix .. "%.jar$" }

                        local is_valid_launcher = vim.iter(jar_patterns):any(function(jar_pattern)
                            return name:match(jar_pattern)
                        end)

                        return is_valid_launcher
                    end, { path = vim.fs.joinpath(jdtls_dir, '/plugins'), type = "file" })

                    if not launcher_jar_candidates or #launcher_jar_candidates == 0 then
                        error("Unable to find jdtls launcher")
                    end

                    local launcher_jar = launcher_jar_candidates[1] -- Choose first candidate

                    local config = {
                        -- The command that starts the language server
                        -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
                        cmd = {
                            'java', -- or '/path/to/java21_or_newer/bin/java'
                            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

                            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                            '-Dosgi.bundles.defaultStartLevel=4',
                            '-Declipse.product=org.eclipse.jdt.ls.core.product',
                            '-Dlog.protocol=true',
                            '-Dlog.level=ALL',
                            '-Xmx1g',
                            '--add-modules=ALL-SYSTEM',
                            '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                            '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

                            '-jar', launcher_jar,
                            '-configuration', vim.fs.joinpath(jdtls_dir, '/config_linux'),

                            '-data', vim.fs.joinpath(vim.fn.stdpath('cache'), '/jdtls/workspace/',
                            vim.fn.fnamemodify(root_dir, ':p:~'))
                        },

                        -- 💀
                        -- This is the default if not provided, you can remove it. Or adjust as needed.
                        -- One dedicated LSP server & client will be started per unique root_dir
                        --
                        -- vim.fs.root requires Neovim 0.10.
                        -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
                        root_dir = root_dir,

                        -- Here you can configure eclipse.jdt.ls specific settings
                        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                        -- for a list of options
                        settings = {
                            java = {
                            }
                        },

                        -- Language server `initializationOptions`
                        -- You need to extend the `bundles` with paths to jar files
                        -- if you want to use additional eclipse.jdt.ls plugins.
                        --
                        -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
                        --
                        -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
                        init_options = {
                            bundles = {}
                        },
                    }
                    -- This starts a new client & server,
                    -- or attaches to an existing client & server depending on the `root_dir`.
                    require('jdtls').start_or_attach(config)
                end
            })
    end,
    event = { "BufReadPost", "VeryLazy" },
    lazy = true
}
