-- =========================================================
-- ui.lua：主题 / 状态栏 / bufferline / 缩进线
-- =========================================================

return {
	-- 主题（必须最早加载，避免闪屏）
	{
		"morhetz/gruvbox",
		lazy = false,
		priority = 1000,
		config = function()
			-- 固定深色背景，避免自动切换带来不一致。
			vim.opt.background = "dark"
			pcall(vim.cmd, "colorscheme gruvbox")
		end,
	},

	-- nvim-web-devicons：文件类型图标支持
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- mini.icons：轻量图标支持
	{ "echasnovski/mini.icons", version = false, event = "VeryLazy", opts = {} },

	-- lualine：状态栏配置
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			-- nvim-web-devicons：状态栏图标支持
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			-- 仅展示当前缓冲区关联的 LSP 客户端名称。
			local function lsp_name()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if not clients or #clients == 0 then
					return ""
				end
				local names = {}
				for _, c in ipairs(clients) do
					if c and c.name and c.name ~= "" then
						table.insert(names, c.name)
					end
				end
				if #names == 0 then
					return ""
				end
				return "LSP:" .. table.concat(names, ",")
			end

			-- Codex 状态：未加载时返回空，避免出现 “table:xxxx”。
			local function codex_status()
				local ok, codex = pcall(require, "codex")
				if not ok then
					return ""
				end
				if type(codex.status) ~= "function" then
					return ""
				end
				local ok2, s = pcall(codex.status)
				if not ok2 then
					return ""
				end
				if type(s) == "string" then
					return s
				end
				-- 有些版本可能返回 component/table，这里兜底避免显示 "table: ..."
				return ""
			end

			require("lualine").setup({
				options = {
					theme = "gruvbox",
					globalstatus = true,
					disabled_filetypes = { statusline = { "lazy", "mason" } },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", { "diff", symbols = { added = "+", modified = "~", removed = "-" } } },
					lualine_c = {
						{
							"filename",
							path = 1,
							symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
						},
					},
					lualine_x = {
						{ "diagnostics", sources = { "nvim_diagnostic" } },
						codex_status,
						lsp_name,
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- bufferline：buffer 标签栏
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = {
			-- nvim-web-devicons：buffer 标签图标支持
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<C-n>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
			{ "<C-p>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
			{ "<leader>bd", "<cmd>bdelete<CR>", desc = "Delete buffer" },
			{ "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go buffer 1" },
			{ "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go buffer 2" },
			{ "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go buffer 3" },
			{ "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go buffer 4" },
			{ "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go buffer 5" },
			{ "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go buffer 6" },
			{ "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go buffer 7" },
			{ "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go buffer 8" },
			{ "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go buffer 9" },
		},
		opts = {
			options = {
				numbers = "ordinal",
				diagnostics = "nvim_lsp",
				separator_style = "slant",
			},
		},
	},

	-- indent-blankline（ibl）：缩进可视化
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		config = function()
			require("ibl").setup({
				indent = { char = "▏", tab_char = "▏" },
				scope = { enabled = true, show_start = false, show_end = false },
				exclude = {
					buftypes = { "terminal", "nofile", "quickfix", "prompt" },
					filetypes = {
						"help",
						"lazy",
						"mason",
						"notify",
						"TelescopePrompt",
						"TelescopeResults",
						"NvimTree",
						"Trouble",
						"dashboard",
						"gitcommit",
					},
				},
			})
		end,
	},

	-- Outline：提供符号大纲侧边栏，便于浏览与跳转结构。
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen", "OutlineClose" },
		keys = {
			{ "<leader>so", "<cmd>Outline<CR>", desc = "Outline: Toggle (Right)" },
		},
		opts = {
			position = "right",
			width = 35,
		},
	},
}
