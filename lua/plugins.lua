-- =========================================================
-- plugins.lua：只负责启动 lazy.nvim
--
-- 关键点：
-- - 不在这里写具体插件配置
-- - 只 bootstrap lazy.nvim，并 import "specs"
--
-- 为什么用 import？
-- - specs/ 目录下每个文件 return 一个“插件 spec 列表”
-- - lazy 会自动把它们合并起来
-- - 便于分类（ui / lsp / cmp / format / git / search）
-- =========================================================

-- lazy.nvim 的安装目录（Neovim 标准数据目录）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 如果 lazy.nvim 不存在，就自动 git clone 一份
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

-- 把 lazy.nvim 加入 runtimepath
vim.opt.rtp:prepend(lazypath)

-- setup：把 specs 目录作为插件清单入口
require("lazy").setup({
    { import = "specs" },
}, {
    install = { missing = true }, -- 缺插件自动装
    checker = { enabled = true }, -- 自动检查更新
})

