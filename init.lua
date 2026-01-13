-- =========================================================
-- init.lua：入口（只做三件事）
-- 1) 设置 leader
-- 2) 加载基础选项 options
-- 3) 启动 lazy + 插件 specs
-- =========================================================

-- 统一设置全局/本地 Leader，确保按键提示与映射一致。
vim.g.mapleader = ","
vim.g.maplocalleader = ","

if vim.lsp and vim.lsp.get_clients then
    -- 兼容仍调用 vim.lsp.buf_get_clients 的旧插件，转发到新的 get_clients 接口。
    vim.lsp.buf_get_clients = function(bufnr)
        return vim.lsp.get_clients({ bufnr = bufnr })
    end
end

-- 可选：加速 Lua 模块加载（Nvim 0.9+），缩短启动耗时。
pcall(function()
    vim.loader.enable()
end)

-- 加载基础选项与插件清单。
require("options")
require("plugins")
