-- =========================================================
-- codex.lua：johnseth97/codex.nvim
-- 目标：
-- - 右侧常驻面板（panel=true）
-- - 开机不自动弹（只在按键/命令时加载）
-- - 手动 toggle
-- - 关键：用 terminal buffer（use_buffer=false），否则会 stdin not a terminal
-- =========================================================

return {
	-- codex.nvim：在终端内提供 Codex 面板
	{
		"johnseth97/codex.nvim",
		cmd = { "Codex", "CodexToggle" },
		keys = {
			-- 在普通/终端模式均可触发，确保面板内也能切换。
			{
				"<leader>cx",
				function()
					require("codex").toggle()
				end,
				desc = "Codex: Toggle (Right Panel)",
				mode = { "n", "t" },
			},
			{
				"<leader>cX",
				"<cmd>Codex<cr>",
				desc = "Codex: Open (Right Panel)",
				mode = "n",
			},
		},
		opts = {
			keymaps = {
				toggle = nil, -- 禁用内置快捷键，统一由本配置接管
				quit = "<C-q>", -- 在 codex 面板里按 Ctrl+Q 关闭
			},

			panel = false, -- ✅ 右侧常驻面板模式
			width = 0.88, -- 面板宽度占比
			height = 0.92, -- 面板高度占比

			use_buffer = false, -- ✅ 必须：使用终端 buffer 才能获得 tty
			border = "rounded", -- 统一圆角边框

			autoinstall = false, -- 不自动安装依赖
			model = nil, -- 不强制指定模型
		},
	},
}
