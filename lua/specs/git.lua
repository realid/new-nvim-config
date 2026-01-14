-- =========================================================
-- git.lua：gitsigns
-- =========================================================

return {
	-- gitsigns.nvim：行级 git 变更标记与操作
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signcolumn = true,
			current_line_blame = false,
		},
		config = function(_, opts)
			local gs = require("gitsigns")
			gs.setup(vim.tbl_deep_extend("force", opts, {
				on_attach = function(bufnr)
					local map = vim.keymap.set
					local o = { noremap = true, silent = true, buffer = bufnr }

					-- diff 模式下保留原生 ]c 行为，避免覆盖默认跳转逻辑。
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(gs.next_hunk)
						return "<Ignore>"
					end, vim.tbl_extend("force", o, { expr = true }))

					-- diff 模式下保留原生 [c 行为，避免覆盖默认跳转逻辑。
					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(gs.prev_hunk)
						return "<Ignore>"
					end, vim.tbl_extend("force", o, { expr = true }))

					-- 常用 git 操作：预览/重置 hunk、查看 blame。
					map("n", "<leader>gs", gs.preview_hunk, o)
					map("n", "<leader>gr", gs.reset_hunk, o)
					map("n", "<leader>gb", gs.blame_line, o)
				end,
			}))
		end,
	},
}
