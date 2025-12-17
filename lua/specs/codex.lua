-- lua/specs/codex.lua
return {
    {
        "johnseth97/codex.nvim",
        cmd = { "Codex", "CodexToggle" }, -- 只在用到时加载
        keys = {
            -- 统一你的 leader（你是 , 号），建议用 ,cx
            { "<leader>cx", function() require("codex").toggle() end, desc = "Codex: Toggle", mode = { "n", "t" } },
            -- 你也可以再加一个显式打开
            { "<leader>cX", "<cmd>Codex<cr>", desc = "Codex: Open", mode = "n" },
        },
        opts = {
            -- 不让插件内部占用 <leader>cc，全部由我们自己 keys 管
            keymaps = {
                toggle = nil,      -- 禁用插件默认 toggle 绑定 :contentReference[oaicite:1]{index=1}
                quit   = "<C-q>",  -- 在 Codex 窗口里用 Ctrl+Q 关闭（不是退出 codex 进程）:contentReference[oaicite:2]{index=2}
            },

            border = "rounded",
            width = 0.82,
            height = 0.82,

            -- 想要右侧侧栏：true；想要浮窗：false
            panel = false,       -- :contentReference[oaicite:3]{index=3}

            -- 输出到普通 buffer（可编辑/可复制）还是 terminal buffer
            use_buffer = false,  -- :contentReference[oaicite:4]{index=4}

            -- 你已经装好 codex 了就关掉；否则开 true 让它自动装 CLI :contentReference[oaicite:5]{index=5}
            autoinstall = false,

            -- 可选：固定模型（不填就用 codex 自己配置的默认）
            model = nil,
        },
    },
}

