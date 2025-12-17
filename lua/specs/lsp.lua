-- =========================================================
-- lsp.lua：LSP 配置（Nvim 0.11+）
--
-- 重要背景：
-- - 之前遇到 “require('lspconfig') framework is deprecated”
--   这是 nvim-lspconfig 的旧“setup 框架入口”逐步弃用的提示
-- - 我们这里不用 require("lspconfig").xxx.setup
--   改用 Nvim 0.11 的：
--     vim.lsp.config("server", {...})
--     vim.lsp.enable({ ... })
--
-- 加载策略：
-- - mason.nvim：只在 :Mason 时加载 UI（cmd="Mason"）
-- - mason-lspconfig：打开文件前就加载（BufReadPre/BufNewFile）
--   这样打开文件后 LSP 可以及时 attach
--
-- 快捷键策略：
-- - 所有 LSP 快捷键都只在 on_attach 里绑定
--   => “LSP 快捷键全部只在 attach 后生效” 的要求完全满足
--
-- 和格式化的关系：
-- - 全局 <leader>f 留给 conform（统一格式化）
-- - LSP 自带格式化单独用 <leader>lf
-- =========================================================

return {
	-- Mason：只负责管理/安装 LSP server（UI）
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {},
	},

	-- mason-lspconfig：负责把 Mason 的 server 和 Neovim LSP 对接
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "VeryLazy" },

		-- 依赖：保证下面 require 的模块一定存在
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig", -- 仍需要它提供 server 定义/元数据
			"hrsh7th/cmp-nvim-lsp", -- capabilities 用
		},

		opts = {
			-- 想要支持哪些语言，就写哪些 server 名
			-- 注意：ts_ls 是新名字（对应 typescript-language-server）
			ensure_installed = { "lua_ls", "pylsp", "rust_analyzer", "ts_ls" },
			automatic_enable = false, -- 我们自己控制 enable
		},

		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			-- 补全能力：让 LSP 和 nvim-cmp 更好协作
			local caps = require("cmp_nvim_lsp").default_capabilities()

			-- 只在 LSP attach 后才绑定快捷键
			local function on_attach(_, bufnr)
				local map = vim.keymap.set
				local o = { noremap = true, silent = true, buffer = bufnr }

				-- 跳转/查看
				map("n", "gd", vim.lsp.buf.definition, o)
				map("n", "gD", vim.lsp.buf.declaration, o)
				map("n", "gi", vim.lsp.buf.implementation, o)
				map("n", "gr", vim.lsp.buf.references, o)
				map("n", "K", vim.lsp.buf.hover, o)
				map("n", "<C-k>", vim.lsp.buf.signature_help, o)

				-- 重构/动作
				map("n", "<leader>rn", vim.lsp.buf.rename, o)
				map("n", "<leader>ca", vim.lsp.buf.code_action, o)

				-- LSP 自带格式化（避免和 conform 的 <leader>f 冲突）
				map("n", "<leader>lf", function()
					vim.lsp.buf.format({ async = true })
				end, o)
			end

			-- lua_ls
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

			vim.lsp.enable({ "lua_ls", "pylsp", "rust_analyzer", "ts_ls" })

			-- pylsp：关掉 pycodestyle（你之前就关过）
			vim.lsp.config("pylsp", {
				capabilities = caps,
				on_attach = on_attach,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = { enabled = false },
						},
					},
				},
			})

			-- rust analyzer
			vim.lsp.config("rust_analyzer", {
				capabilities = caps,
				on_attach = on_attach,
				settings = { ["rust-analyzer"] = {} },
			})

			-- typescript language server（新名字 ts_ls）
			vim.lsp.config("ts_ls", {
				capabilities = caps,
				on_attach = on_attach,
			})

			-- 显式启用：只有写在这里的才会启动
			vim.lsp.enable({ "pylsp", "rust_analyzer", "ts_ls" })
		end,
	},
}
