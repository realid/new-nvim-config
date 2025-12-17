-- =========================================================
-- misc.lua：杂项插件
--
-- which-key：显示你按下 leader 后的快捷键提示（非常适合“记不住键位”）
-- Comment.nvim：快速注释/反注释
-- graphviz.vim：渲染 dot 文件（只在 dot/gv filetype 才加载）
--
-- 加载策略：
-- - which-key/comment：VeryLazy（不影响启动）
-- - graphviz：ft 触发（没打开 dot 文件显示 Not Loaded 正常）
-- =========================================================

return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({})

            -- 分组只是提示用，不会“强绑定按键”
            wk.add({
                { "<leader>f", group = "Find/Format" },
                { "<leader>g", group = "Git" },
                { "<leader>l", group = "Lint/LSP" },
                { "<leader>d", group = "Diagnostics" },
            })
        end,
    },

    { "echasnovski/mini.icons", version = false, event = "VeryLazy", opts = {} },

    { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },

    {
        "liuchengxu/graphviz.vim",
        ft = { "dot", "gv", "graphviz" },
        init = function()
            -- 输出 png（你之前就要这个）
            vim.g.graphviz_output_format = "png"
        end,
    },
}

