-- =========================================================
-- options.lua：基础设置 + 全局快捷键（不依赖插件）
--
-- 这里放什么？
-- - vim.opt / vim.g / vim.diagnostic.config 等“基础体验”
-- - 不依赖插件的快捷键（窗口移动、保存退出、诊断导航等）
--
-- 这里不放什么？
-- - 插件相关快捷键（比如 telescope、gitsigns、bufferline）
--   这些放在各自插件 spec 的 keys/on_attach 里（避免插件没加载时报错）
-- =========================================================

-- 关闭不用的provider
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- leader 键
vim.g.mapleader = ","

-- 兼容之前的习惯（现在很多发行版不写也行）
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

-- ========== 缩进风格：4 空格 ==========
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- 行号
vim.opt.number = true

-- 真彩：UI 主题/状态栏/标签栏需要
vim.opt.termguicolors = true

-- 避免生成 backup 文件影响 LSP / 工具链
vim.opt.backup = false
vim.opt.writebackup = false

-- CursorHold 更快触发（一些提示/刷新更灵敏）
vim.opt.updatetime = 300

-- 诊断符号列固定，不然会左右抖动
vim.opt.signcolumn = "yes"

-- nvim-cmp 推荐：弹出菜单但不默认选中（避免误回车）
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- ========== 诊断展示策略 ==========
-- 这属于“基础体验”，不依赖某个特定 LSP 插件
vim.diagnostic.config({
    virtual_text = true,        -- 行尾虚拟文本（简短提示）
    signs = true,               -- 左侧符号列（E/W/I/H）
    underline = true,           -- 下划线标识
    update_in_insert = false,   -- 插入模式不频繁刷新（更稳更少抖）
    severity_sort = true,       -- 严重程度排序
    float = {
        border = "rounded",       -- 浮窗边框
        source = "if_many",       -- 多来源时显示来源
    },
})

-- ========== 全局快捷键（不依赖插件） ==========
do
    local map = vim.keymap.set
    local opt = { noremap = true, silent = true }

    -- 常用：清除搜索高亮
    map("n", "<leader><leader>", "<cmd>nohlsearch<CR>", opt)

    -- 文件：保存/退出
    map("n", "<leader>w", "<cmd>w<CR>", opt)
    map("n", "<leader>q", "<cmd>q<CR>", opt)

    -- 窗口：hjkl 移动
    map("n", "<C-h>", "<C-w>h", opt)
    map("n", "<C-j>", "<C-w>j", opt)
    map("n", "<C-k>", "<C-w>k", opt)
    map("n", "<C-l>", "<C-w>l", opt)

    -- 诊断：这些是“全局可用”的，不需要 LSP attach 才绑定
    map("n", "<leader>e", vim.diagnostic.open_float, opt)
    map("n", "[d", vim.diagnostic.goto_prev, opt)
    map("n", "]d", vim.diagnostic.goto_next, opt)
    map("n", "<leader>dl", vim.diagnostic.setloclist, opt)
end
