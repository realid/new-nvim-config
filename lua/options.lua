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

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 300
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- ---------- 缩进/Tab ----------
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- 说明：
-- 你看到“文件里很多 Tab（^I）”，是因为文件内容本来就有 Tab。
-- expandtab 只影响“新插入”的缩进，不会自动把旧 Tab 改成空格。
-- 需要把旧 Tab 转为空格：打开文件后执行 :retab

-- ---------- 显示不可见字符（可按需开关） ----------
vim.opt.list = false
vim.opt.listchars = {
    tab = "»·",
    trail = "·",
    nbsp = "␣",
}

-- ---------- 搜索 ----------
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- ---------- 折叠：默认不折（treesitter 会设置 foldexpr，但 foldlevel 保持很高） ----------
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"

-- 一个小工具键：切换 list 显示
vim.keymap.set("n", "<leader>ul", function()
    vim.opt.list = not vim.opt.list:get()
    vim.notify("list=" .. tostring(vim.opt.list:get()))
end, { desc = "Toggle listchars" })
