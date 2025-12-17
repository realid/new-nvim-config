-- =========================================================
-- git.lua：gitsigns.nvim
--
-- 作用：
-- - 左侧显示 git diff 标记
-- - 在文件内跳转/预览/重置改动
--
-- 键位（统一，贴近 Vim 习惯）：
-- - ]c / [c     下/上一个 hunk（改动块）
-- - <leader>gs  预览当前 hunk
-- - <leader>gr  重置当前 hunk
-- - <leader>gb  blame 当前行
--
-- 加载时机：
-- - BufReadPre/BufNewFile：打开文件就加载（通常很轻）
-- =========================================================

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },

        -- opts 是插件默认配置入口（你也可以只写 opts，不写 config）
        opts = {
            signcolumn = true,
            current_line_blame = false, -- 不默认开 blame（会很吵）
        },

        config = function(_, opts)
            local gs = require("gitsigns")
            gs.setup(vim.tbl_deep_extend("force", opts, {
                on_attach = function(bufnr)
                    local map = vim.keymap.set
                    local o = { noremap = true, silent = true, buffer = bufnr }

                    -- ]c / [c：如果你当前在 diff 模式，就保持原功能
                    map("n", "]c", function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(gs.next_hunk)
                        return "<Ignore>"
                    end, vim.tbl_extend("force", o, { expr = true }), { desc = "Next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(gs.prev_hunk)
                        return "<Ignore>"
                    end, vim.tbl_extend("force", o, { expr = true }), { desc = "Prev hunk" })

                    map("n", "<leader>gs", gs.preview_hunk, o)
                    map("n", "<leader>gr", gs.reset_hunk, o)
                    map("n", "<leader>gb", gs.blame_line, o)
                end,
            }))
        end,
    },
}

