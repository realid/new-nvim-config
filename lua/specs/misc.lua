-- =========================================================
-- misc.lua：which-key / 注释 / icons / graphviz
-- =========================================================

return {
	-- which-key.nvim：按键提示与分组展示
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			-- 使用默认配置即可满足提示需求。
			wk.setup({})
			-- which-key 的前缀分组配置，用于组织提示菜单。
			wk.add({
				{ "<leader>f", group = "Find/Format" },
				{ "<leader>g", group = "Git" },
				{ "<leader>l", group = "Lint/LSP" },
			})
		end,
	},

	-- Comment.nvim：快速注释/反注释
	{ "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },

	{
		-- graphviz.vim：Graphviz dot/gv 文件支持
		"liuchengxu/graphviz.vim",
		ft = { "dot", "gv", "graphviz" },
		init = function()
			-- Graphviz 默认输出格式。
			vim.g.graphviz_output_format = "png"
		end,
	},
}
