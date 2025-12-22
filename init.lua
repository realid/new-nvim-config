-- =========================================================
-- init.lua：入口（只做三件事）
-- 1) 设置 leader
-- 2) 加载基础选项 options
-- 3) 启动 lazy + 插件 specs
-- =========================================================

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- 可选：加速 Lua 模块加载（Nvim 0.9+）
pcall(function() vim.loader.enable() end)

require("options")
require("plugins")

