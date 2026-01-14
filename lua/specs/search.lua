-- =========================================================
-- search.lua：telescope（找文件/grep/buffers/help/最近文件）
-- =========================================================

return {
	-- plenary.nvim：Telescope 等插件的公共工具库
	{ "nvim-lua/plenary.nvim", lazy = true },

	{
		"nvim-telescope/telescope.nvim",
		-- telescope.nvim：模糊查找/内容搜索等入口
		cmd = "Telescope",
		dependencies = {
			-- plenary.nvim：Telescope 依赖的 Lua 工具库
			"nvim-lua/plenary.nvim",
		},
		-- 常用查找快捷键
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Live grep (rg)",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help tags",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Recent files",
			},
		},
		opts = {
			defaults = {
				border = true, -- 使用边框分隔
				sorting_strategy = "ascending", -- 结果从上到下
				layout_config = { prompt_position = "top" }, -- 提示框置顶
			},
		},
	},

	-- 原生 fzf 扩展（需要 make 编译），用于提升搜索性能。
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
		dependencies = {
			-- telescope.nvim：提供核心查找能力
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			pcall(require("telescope").load_extension, "fzf")
		end,
	},
}
