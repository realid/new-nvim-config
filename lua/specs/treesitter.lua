-- =========================================================
-- specs/treesitter.lua  (Neovim 0.11 + nvim-treesitter main)
--
-- 你现在用的是 nvim-treesitter 的 main 分支“新 API”风格：
-- - 高亮：vim.treesitter.start(buf, lang)
-- - 折叠：vim.treesitter.foldexpr()
-- - 缩进：require("nvim-treesitter").indentexpr()
-- - 安装 parser：require("nvim-treesitter").install(...)
--
-- 设计目标：
-- 1) treesitter 插件常驻（lazy=false），避免“功能随机不生效”
-- 2) 打开文件时自动启用：高亮 + 缩进 +（可选）折叠
-- 3) 折叠默认“可用但不自动折起来”（foldlevel=99）
-- =========================================================

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false, -- main 分支不建议 lazy-loading
		build = ":TSUpdate", -- 更新插件后同步更新 parsers

		config = function()
			local ts = require("nvim-treesitter")

			-- -----------------------------------------------------
			-- A) 基础设置：安装目录
			-- -----------------------------------------------------
			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- -----------------------------------------------------
			-- B) 预装一批常用 parser（等价旧版 ensure_installed 的“开机预热”）
			--    注意：这是异步任务，不 wait，避免启动卡顿。
			-- -----------------------------------------------------
			ts.install({
				"lua",
				"vim",
				"vimdoc",
				"query",
				"python",
				"c",
				"cpp",
				"javascript",
				"typescript",
				"bash",
				"cmake",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
				"html",
				"css",
			}, { summary = false })

			-- -----------------------------------------------------
			-- C) 折叠的“全局默认行为”
			--    foldlevelstart 是 global option（必须用 vim.o / vim.opt）
			--    设为 99 => 默认不自动折叠（但你仍可用 zM/zR/zo/zc）
			-- -----------------------------------------------------
			vim.opt.foldlevelstart = 99

			-- -----------------------------------------------------
			-- D) FileType：打开文件时启用功能
			-- -----------------------------------------------------
			local grp = vim.api.nvim_create_augroup("TSMainBranchEnable", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = grp,
				pattern = "*",
				callback = function(ev)
					local buf = ev.buf
					local ft = vim.bo[buf].filetype
					if not ft or ft == "" then
						return
					end

					-- filetype -> treesitter language 映射（例如：typescriptreact 等）
					local lang = vim.treesitter.language.get_lang(ft) or ft
					if not lang or lang == "" then
						return
					end

					-- -------------------------------------------------
					-- D-1) 兜底安装 parser
					-- 说明：
					-- - 首次打开某语言文件时，如果没装 parser，会尝试装一下
					-- - 为了不“卡死”，只等一小会儿（2s），超时就算了
					-- -------------------------------------------------
					do
						local ok, task = pcall(ts.install, { lang }, { summary = false })
						if ok and task and task.wait then
							pcall(task.wait, task, 2000) -- 最多等 2 秒：够用且不折磨
						end
					end

					-- -------------------------------------------------
					-- D-2) 启用高亮（buffer-local）
					-- -------------------------------------------------
					pcall(vim.treesitter.start, buf, lang)

					-- -------------------------------------------------
					-- D-3) 启用缩进（buffer-local）
					-- 注意：treesitter indent 仍偏“实验性”，不满意可以关掉这行
					-- -------------------------------------------------
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

					-- -------------------------------------------------
					-- D-4) 启用折叠（window-local）
					-- 你之前“代码自动折起来”，就是 foldlevel 太低导致。
					-- 这里把 foldlevel 拉到 99 => 默认全展开。
					-- -------------------------------------------------
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo.foldenable = true
					vim.wo.foldlevel = 99
				end,
			})
		end,
	},
}
