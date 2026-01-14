-- =========================================================
-- format.lua：conform(格式化) + nvim-lint(静态检查)
--
-- 目标（你的要求）：
-- 1) 外部命令不存在 => 不执行、不报错
-- 2) 保存时可以“改缩进/格式化”，但最终写入文件时：
--    - 缩进区（行首空白）必须是空格
--    - 不要 Tab（至少不要缩进 Tab）
--
-- 做法：
-- - 不用 conform 内置 format_on_save（我们自己写 BufWritePre，保证顺序：format -> 去 Tab）
-- - BufWritePre：
--     conform.format(sync) -> 把行首 \t 展开成空格
--
-- 参考：conform 官方 README 的 BufWritePre 用法、format_on_save、formatters(prepend_args) 说明
-- =========================================================
-- :contentReference[oaicite:0]{index=0}
-- =========================================================

-- 判断外部 formatter/linter 是否可执行，用于动态选择工具。
local function has(cmd)
	return vim.fn.executable(cmd) == 1
end

-- 只把“行首缩进区域”的 Tab 展开成空格（不动正文里的 Tab 字符）
local function expand_indent_tabs_to_spaces(bufnr)
	bufnr = bufnr or 0

	-- 尊重 buffer 自己的设置：如果这个 buffer 就是 noexpandtab（例如 make），直接跳过
	if not vim.bo[bufnr].expandtab then
		return
	end

	local ft = vim.bo[bufnr].filetype
	if ft == "make" then
		return
	end

	-- 用 tabstop 来计算“tab 展开后的对齐列”
	local ts = vim.bo[bufnr].tabstop
	if ts <= 0 then
		ts = 8
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local changed = false

	for i, line in ipairs(lines) do
		-- 提取行首空白（tabs/spaces）
		local prefix = line:match("^[\t ]+")
		if prefix and prefix:find("\t", 1, true) then
			local col = 0
			local out = {}

			for j = 1, #prefix do
				local ch = prefix:sub(j, j)
				if ch == "\t" then
					local n = ts - (col % ts)
					out[#out + 1] = string.rep(" ", n)
					col = col + n
				else
					out[#out + 1] = " "
					col = col + 1
				end
			end

			lines[i] = table.concat(out) .. line:sub(#prefix + 1)
			changed = true
		end
	end

	if changed then
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	end
end

return {
	-- =========================================================
	-- conform：格式化
	-- =========================================================
	-- conform.nvim：格式化调度与配置
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },

		keys = {
			{
				"<leader>f",
				function()
					local ok, conform = pcall(require, "conform")
					if ok then
						conform.format({ async = true, lsp_format = "fallback" })
					else
						vim.lsp.buf.format({ async = true })
					end
				end,
				desc = "Format (Conform/LSP)",
			},
			{
				"<leader>F",
				function()
					local ok, conform = pcall(require, "conform")
					if ok then
						conform.format({ async = true, lsp_format = "fallback", timeout_ms = 5000 })
					else
						vim.lsp.buf.format({ async = true })
					end
				end,
				desc = "Format (force)",
			},
		},

		opts = {
			notify_on_error = false, -- 避免弹窗干扰
			notify_no_formatters = false, -- 无 formatter 时保持安静

			-- 按“命令是否存在”动态选择 formatter，避免 ENOENT。
			formatters_by_ft = {
				lua = function()
					return has("stylua") and { "stylua" } or {}
				end,

				python = function()
					if has("ruff") then
						return { "ruff_format" }
					end
					return has("black") and { "black" } or {}
				end,

				javascript = function()
					return has("prettier") and { "prettier" } or {}
				end,
				typescript = function()
					return has("prettier") and { "prettier" } or {}
				end,
				json = function()
					return has("prettier") and { "prettier" } or {}
				end,
				yaml = function()
					return has("prettier") and { "prettier" } or {}
				end,
				markdown = function()
					return has("prettier") and { "prettier" } or {}
				end,

				sh = function()
					return has("shfmt") and { "shfmt" } or {}
				end,
			},

			-- 覆盖/追加 formatter 参数：prepend_args/append_args
			-- :contentReference[oaicite:1]{index=1}
			formatters = {
				-- 尽量让 shfmt 走“空格缩进”的风格（随后我们还会在保存前兜底清 Tab）
				shfmt = {
					prepend_args = { "-i", "4" },
				},
			},
		},

		config = function(_, opts)
			require("conform").setup(opts)

			-- 我们自己做“保存前格式化”，保证顺序：format -> 去缩进 Tab
			-- conform README 推荐的 BufWritePre 方式：
			-- :contentReference[oaicite:2]{index=2}
			local grp = vim.api.nvim_create_augroup("ConformFormatThenDetab", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = grp,
				pattern = "*",
				callback = function(args)
					local bufnr = args.buf

					-- 跳过特殊 buffer
					if vim.bo[bufnr].buftype ~= "" then
						return
					end

					-- 先同步格式化，避免保存后再修改导致文件变更。
					local ok, conform = pcall(require, "conform")
					if ok then
						-- quiet=true：没有 formatter 的时候别吵；lsp_format=fallback：没 formatter 就用 LSP
						conform.format({
							bufnr = bufnr,
							async = false,
							timeout_ms = 2000,
							lsp_format = "fallback",
							quiet = true,
						})
					else
						-- 极端兜底
						pcall(vim.lsp.buf.format, { bufnr = bufnr, async = false })
					end

					-- 再把“缩进区 Tab”清成空格（保证落盘无缩进 Tab）。
					expand_indent_tabs_to_spaces(bufnr)
				end,
			})
		end,
	},

	-- =========================================================
	-- nvim-lint：lint（外部命令不存在就不启用）
	-- =========================================================
	-- nvim-lint：按文件类型触发外部 lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },

		keys = {
			{
				"<leader>l",
				function()
					local ok, lint = pcall(require, "lint")
					if ok then
						pcall(lint.try_lint)
					end
				end,
				desc = "Lint",
			},
		},

		config = function()
			local lint = require("lint")

			-- 直接重置，避免残留旧配置导致 ENOENT。
			lint.linters_by_ft = {}

			local by_ft = {}

			if has("ruff") then
				by_ft.python = { "ruff" }
			end

			if has("eslint_d") then
				by_ft.javascript = { "eslint_d" }
				by_ft.typescript = { "eslint_d" }
			elseif has("eslint") then
				by_ft.javascript = { "eslint" }
				by_ft.typescript = { "eslint" }
			end

			if has("shellcheck") then
				by_ft.sh = { "shellcheck" }
			end

			lint.linters_by_ft = by_ft

			-- 自动 lint：进入、保存、退出插入后触发。
			local grp = vim.api.nvim_create_augroup("LintOnEvents", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = grp,
				callback = function()
					if vim.bo.buftype ~= "" then
						return
					end
					local ft = vim.bo.filetype
					local linters = lint.linters_by_ft[ft]
					if not linters or #linters == 0 then
						return
					end

					-- 再兜底一层：PATH 变了也别炸
					for _, name in ipairs(linters) do
						local l = lint.linters[name]
						local cmd = l and l.cmd
						if type(cmd) == "string" and not has(cmd) then
							return
						end
					end

					pcall(lint.try_lint)
				end,
			})
		end,
	},
}
