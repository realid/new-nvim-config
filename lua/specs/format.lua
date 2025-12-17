-- =========================================================
-- format.lua：统一格式化 + lint
--
-- 键位（避免占用 <leader>f 组，<leader>f* 全留给 search.lua 的 telescope）：
-- - <leader>lf  格式化（优先 conform；没有 formatter 就 fallback 到 LSP）
-- - <leader>lF  强制格式化（并提示）
-- - <leader>ll  触发 lint
--
-- 注意：
-- - formatter/linter 需要系统里装好对应命令：
--   stylua / ruff / black / prettier / shfmt / eslint_d / shellcheck 等
-- =========================================================

return {
	-- ========== 格式化：conform.nvim ==========
	{
		"stevearc/conform.nvim",
		event = "VeryLazy",

		keys = {
			{
				"<leader>lf",
				function()
					local ok, conform = pcall(require, "conform")
					if ok then
						conform.format({ async = true, lsp_fallback = true })
					else
						vim.lsp.buf.format({ async = true })
					end
				end,
				desc = "LSP: Format (Conform/LSP)",
			},
			{
				"<leader>lF",
				function()
					local ok, conform = pcall(require, "conform")
					if ok then
						conform.format({ async = true, lsp_fallback = true, timeout_ms = 5000 })
						vim.notify("Formatted", vim.log.levels.INFO)
					else
						vim.lsp.buf.format({ async = true })
						vim.notify("Formatted (LSP)", vim.log.levels.INFO)
					end
				end,
				desc = "LSP: Format (force)",
			},
		},

		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				sh = { "shfmt" },
			},

			format_on_save = function()
				return { lsp_fallback = true, timeout_ms = 2000 }
			end,
		},
	},

	-- ========== Lint：nvim-lint ==========
	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",

		keys = {
			{
				"<leader>ll",
				function()
					local ok, lint = pcall(require, "lint")
					if ok then
						lint.try_lint()
					end
				end,
				desc = "LSP: Lint",
			},
		},

		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "ruff" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				sh = { "shellcheck" },
			}

			local grp = vim.api.nvim_create_augroup("LintOnEvents", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = grp,
				callback = function()
					if vim.bo.buftype ~= "" then
						return
					end
					pcall(lint.try_lint)
				end,
			})
		end,
	},
}
