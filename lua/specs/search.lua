-- =========================================================
-- search.lua：telescope.nvim（搜索/模糊查找）
--
-- 作用：
-- - 找文件、全局 grep、查 buffers、help、最近文件
--
-- 键位（统一在 <leader>f*）：
-- - <leader>ff  Find files
-- - <leader>fg  Live grep（ripgrep）
-- - <leader>fb  Buffers
-- - <leader>fh  Help tags
-- - <leader>fr  Recent files
--
-- 加载策略：
-- - cmd="Telescope"：你执行 :Telescope 才加载
-- - keys：你按这些快捷键时也会加载
--
-- 性能加速：
-- - telescope-fzf-native.nvim：可选，需要系统有 make
-- =========================================================

return {
    -- telescope 依赖 plenary（工具函数库）
    { "nvim-lua/plenary.nvim", lazy = true },

    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },

        -- keys：按键触发自动加载 telescope
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
            { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
        },

        -- opts：telescope 默认配置
        opts = {
            defaults = {
                border = true,
                sorting_strategy = "ascending",
                layout_config = { prompt_position = "top" },
            },
        },
    },

    -- 可选：fzf-native 扩展（更快）
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            -- 没有 make 就不装（避免报错）
            return vim.fn.executable("make") == 1
        end,
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            -- 安全加载扩展
            pcall(require("telescope").load_extension, "fzf")
        end,
    },
}

