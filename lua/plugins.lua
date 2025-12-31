-- =========================================================
-- plugins.lua：lazy.nvim 启动 + import specs
--
-- 插件用途与使用说明请见：
-- README.md
-- =========================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 若未安装 lazy.nvim，则在本地自动拉取以完成引导。
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

-- 将 lazy.nvim 加入 runtimepath 以供加载。
vim.opt.rtp:prepend(lazypath)

-- 仅导入 specs 目录，其他插件配置集中在 lua/specs/*.lua。
require("lazy").setup({
    { import = "specs" }, -- 自动加载 lua/specs/*.lua
}, {
    defaults = { lazy = true }, -- 默认懒加载，减少启动压力
    ui = { border = "rounded" }, -- 窗口统一圆角边框
    change_detection = { notify = false }, -- 不提示配置变更
    checker = { enabled = false }, -- 禁用自动更新检查
    install = { colorscheme = { "gruvbox" } }, -- 首次安装时优先配色
    rocks = { enabled = false }, -- 不启用 luarocks 依赖解析
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
                "netrw",
                "netrwPlugin", -- 你不用 nvim 内置文件浏览的话可以关
            },
        },
    },
})
