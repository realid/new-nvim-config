-- =========================================================
-- lsp.lua：Neovim 0.11+ 原生 LSP（vim.lsp.config / vim.lsp.enable）
-- 重点：所有 LSP 快捷键只在 attach 后生效
-- =========================================================

return {
    -- nvim-lspconfig：提供 LSP server 定义与 :LspInfo 命令
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- mason.nvim：LSP/工具的安装与管理 UI
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
    },

    -- mason-lspconfig.nvim：Mason 与 LSP 配置桥接
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- mason.nvim：LSP/工具管理
            "williamboman/mason.nvim",
            -- nvim-lspconfig：LSP server 定义
            "neovim/nvim-lspconfig",
            -- cmp-nvim-lsp：补全能力扩展
            "hrsh7th/cmp-nvim-lsp",
        },
        opts = {
            ensure_installed = { "lua_ls", "pylsp", "rust_analyzer", "ts_ls" },
            automatic_installation = true,
        },
        config = function(_, opts)
            -- Mason 负责安装与管理 LSP，可自动补齐缺失服务。
            require("mason-lspconfig").setup(opts)

            -- 从 nvim-cmp 获取 LSP capabilities，保证补全能力一致。
            local caps = require("cmp_nvim_lsp").default_capabilities()

            local function on_attach(_, bufnr)
                local map = vim.keymap.set
                local o = { noremap = true, silent = true, buffer = bufnr }

                -- 光标停留时自动弹出诊断浮窗
                local diag_group = vim.api.nvim_create_augroup("LspDiagnosticsOnHover", { clear = false })
                vim.api.nvim_clear_autocmds({ group = diag_group, buffer = bufnr })
                vim.api.nvim_create_autocmd("CursorHold", {
                    group = diag_group,
                    buffer = bufnr,
                    callback = function()
                        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
                    end,
                })

                -- 跳转/查看：仅在 LSP attach 后生效。
                map("n", "gd", vim.lsp.buf.definition, o)
                map("n", "gD", vim.lsp.buf.declaration, o)
                map("n", "gi", vim.lsp.buf.implementation, o)
                map("n", "gr", vim.lsp.buf.references, o)
                map("n", "K", vim.lsp.buf.hover, o)
                map("n", "<C-k>", vim.lsp.buf.signature_help, o)

                -- 诊断（也放 attach 后，满足“只在 attach 生效”）
                map("n", "[d", vim.diagnostic.goto_prev, o)
                map("n", "]d", vim.diagnostic.goto_next, o)
                map("n", "<leader>e", vim.diagnostic.open_float, o)

                -- 重构/动作
                map("n", "<leader>rn", vim.lsp.buf.rename, o)
                map("n", "<leader>ca", vim.lsp.buf.code_action, o)

                -- LSP 自带格式化（conform 用 <leader>f）
                map("n", "<leader>lf", function()
                    vim.lsp.buf.format({ async = true })
                end, o)
            end

            -- lua_ls：Lua 语言服务
            vim.lsp.config("lua_ls", {
                capabilities = caps,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            })

            -- pylsp：Python 语言服务
            vim.lsp.config("pylsp", {
                capabilities = caps,
                on_attach = on_attach,
                settings = {
                    pylsp = { plugins = { pycodestyle = { enabled = false } } },
                },
            })

            -- rust-analyzer：Rust 语言服务
            vim.lsp.config("rust_analyzer", {
                capabilities = caps,
                on_attach = on_attach,
                settings = { ["rust-analyzer"] = {} },
            })

            -- ts_ls：TypeScript/JavaScript 语言服务
            vim.lsp.config("ts_ls", {
                capabilities = caps,
                on_attach = on_attach,
            })

            -- 统一启用上面已配置的 LSP 服务。
            vim.lsp.enable({ "lua_ls", "pylsp", "rust_analyzer", "ts_ls" })
        end,
    },
}
