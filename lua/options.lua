-- =========================================================
-- options.lua：基础设置（与插件无关）
-- =========================================================

-- ---------- Provider：不需要就关掉，避免 checkhealth 一堆 warning ----------
-- Codex / LSP / cmp 都不依赖这些 provider
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- ---------- 基础体验 ----------
vim.opt.syntax = "on"
vim.cmd("filetype plugin indent on")

-- 绝对行号便于定位；相对行号按需关闭。
vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.mouse = "a"
-- 通过系统剪贴板同步复制/粘贴，便于与外部应用互通。
vim.opt.clipboard = "unnamedplus"

-- 启用真彩色；固定 signcolumn 避免文本左右跳动。
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- 降低 CursorHold 触发延迟；缩短映射等待时间。
vim.opt.updatetime = 300
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- ---------- 缩进/Tab ----------
-- 基础缩进规则，避免手动排版。
vim.opt.autoindent = true
vim.opt.smartindent = true

-- 统一 4 空格缩进，并将 Tab 转为空格（仅影响新插入）。
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- 说明：
-- 你看到“文件里很多 Tab（^I）”，是因为文件内容本来就有 Tab。
-- expandtab 只影响“新插入”的缩进，不会自动把旧 Tab 改成空格。
-- 需要把旧 Tab 转为空格：打开文件后执行 :retab

-- ---------- 显示不可见字符（可按需开关） ----------
-- 默认不显示不可见字符，需要时手动切换。
vim.opt.list = false
vim.opt.listchars = {
	tab = "»·",
	trail = "·",
	nbsp = "␣",
}

-- ---------- 搜索 ----------
-- 智能大小写：默认忽略大小写，包含大写时严格匹配。
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- 输入时即时搜索，并高亮所有匹配项。
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- ---------- 折叠：默认不折（treesitter 会设置 foldexpr，但 foldlevel 保持很高） ----------
-- 折叠功能可用但默认展开，避免打开文件即折叠。
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"

-- 一个小工具键：切换 list 显示
-- 快捷切换 listchars，便于临时排查缩进/空白问题。
vim.keymap.set("n", "<leader>ul", function()
	vim.opt.list = not vim.opt.list:get()
	vim.notify("list=" .. tostring(vim.opt.list:get()))
end, { desc = "Toggle listchars" })

-- 快速打开本配置的 README 帮助
vim.keymap.set("n", "<leader>?", function()
	local path = vim.fn.stdpath("config") .. "/README.md"
	vim.cmd("edit " .. path)
end, { desc = "Open README" })

-- 只对 loclist 生效：回车跳转后自动关闭 loclist 窗口。
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		local winid = vim.api.nvim_get_current_win()
		local info = vim.fn.getwininfo(winid)[1]
		if not info or info.loclist ~= 1 then
			return
		end
		vim.keymap.set("n", "<CR>", function()
			vim.cmd("ll")
			vim.cmd("lclose")
		end, { buffer = true, silent = true, nowait = true })

		vim.api.nvim_create_autocmd("CursorMoved", {
			buffer = 0,
			callback = function()
				local line = vim.fn.line(".")
				if vim.b.loclist_last_line == line then
					return
				end
				vim.b.loclist_last_line = line
				local loclist_win = vim.api.nvim_get_current_win()
				vim.cmd("silent! keepjumps ll")
				if vim.api.nvim_win_is_valid(loclist_win) then
					vim.api.nvim_set_current_win(loclist_win)
				end
			end,
		})
	end,
})
