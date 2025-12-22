-- =========================================================
-- search.lua：telescope（找文件/grep/buffers/help/最近文件）
-- =========================================================

return {
    { "nvim-lua/plenary.nvim", lazy = true },

    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Find files",
            },
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Live grep (rg)",
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>fh",
                function()
                    require("telescope.builtin").help_tags()
                end,
                desc = "Help tags",
            },
            {
                "<leader>fr",
                function()
                    require("telescope.builtin").oldfiles()
                end,
                desc = "Recent files",
            },
        },
        opts = {
            defaults = {
                border = true,
                sorting_strategy = "ascending",
                layout_config = { prompt_position = "top" },
            },
        },
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            pcall(require("telescope").load_extension, "fzf")
        end,
    },
}
