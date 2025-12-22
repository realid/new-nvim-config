-- =========================================================
-- plugins.lua：lazy.nvim 启动 + import specs
-- =========================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { import = "specs" }, -- 自动加载 lua/specs/*.lua
}, {
    defaults = { lazy = true },
    ui = { border = "rounded" },
    change_detection = { notify = false },
    checker = { enabled = false },
    install = { colorscheme = { "gruvbox" } },
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
