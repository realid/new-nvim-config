-- =========================================================
-- codex.lua：johnseth97/codex.nvim
-- 只在需要时加载（cmd/keys），适合“纯 neovim 无窗口登录”的场景
-- =========================================================

return {
    {
        "johnseth97/codex.nvim",
        cmd = { "Codex", "CodexToggle" },
        keys = {
            {
                "<leader>cx",
                function()
                    require("codex").toggle()
                end,
                desc = "Codex: Toggle",
                mode = { "n", "t" },
            },
            { "<leader>cX", "<cmd>Codex<cr>", desc = "Codex: Open", mode = "n" },
        },
        opts = {
            keymaps = {
                toggle = nil, -- 不用插件默认键位
                quit = "<C-q>", -- 在 Codex 窗口按 Ctrl+Q 关闭
            },
            border = "rounded",
            width = 0.82,
            height = 0.82,
            panel = false,
            use_buffer = false,
            autoinstall = false,
            model = nil,
        },
    },
}
