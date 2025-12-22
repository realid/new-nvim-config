-- =========================================================
-- misc.lua：which-key / 注释 / icons / graphviz
-- =========================================================

return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({})
            wk.add({
                { "<leader>f", group = "Find/Format" },
                { "<leader>g", group = "Git" },
                { "<leader>l", group = "Lint/LSP" },
            })
        end,
    },

    { "echasnovski/mini.icons", version = false, event = "VeryLazy", opts = {} },

    { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },

    {
        "liuchengxu/graphviz.vim",
        ft = { "dot", "gv", "graphviz" },
        init = function()
            vim.g.graphviz_output_format = "png"
        end,
    },
}
