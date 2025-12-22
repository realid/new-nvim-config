-- =========================================================
-- ui.lua：主题 / 状态栏 / bufferline / 缩进线
-- =========================================================

return {
    -- 主题（必须最早，避免闪屏）
    {
        "morhetz/gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            vim.opt.background = "dark"
            pcall(vim.cmd, "colorscheme gruvbox")
        end,
    },

    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- lualine
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local function lsp_name()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if not clients or #clients == 0 then
                    return ""
                end
                local names = {}
                for _, c in ipairs(clients) do
                    if c and c.name and c.name ~= "" then
                        table.insert(names, c.name)
                    end
                end
                if #names == 0 then
                    return ""
                end
                return "LSP:" .. table.concat(names, ",")
            end

            -- Codex 状态：Codex 没加载时返回空，不会在右下角出现 “table:xxxx”
            local function codex_status()
                local ok, codex = pcall(require, "codex")
                if not ok then
                    return ""
                end
                if type(codex.status) ~= "function" then
                    return ""
                end
                local ok2, s = pcall(codex.status)
                if not ok2 then
                    return ""
                end
                if type(s) == "string" then
                    return s
                end
                -- 有些版本可能返回 component/table，这里兜底避免显示 "table: ..."
                return ""
            end

            require("lualine").setup({
                options = {
                    theme = "gruvbox",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "lazy", "mason" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", { "diff", symbols = { added = "+", modified = "~", removed = "-" } } },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
                        },
                    },
                    lualine_x = {
                        { "diagnostics", sources = { "nvim_diagnostic" } },
                        codex_status,
                        lsp_name,
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- bufferline
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<C-n>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
            { "<C-p>", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
            { "<leader>bd", "<cmd>bdelete<CR>", desc = "Delete buffer" },
            { "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go buffer 1" },
            { "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go buffer 2" },
            { "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go buffer 3" },
            { "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go buffer 4" },
            { "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go buffer 5" },
            { "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go buffer 6" },
            { "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go buffer 7" },
            { "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go buffer 8" },
            { "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go buffer 9" },
        },
        opts = {
            options = {
                numbers = "ordinal",
                diagnostics = "nvim_lsp",
                separator_style = "slant",
            },
        },
    },

    -- indent-blankline（ibl）
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        config = function()
            require("ibl").setup({
                indent = { char = "▏", tab_char = "▏" },
                scope = { enabled = true, show_start = false, show_end = false },
                exclude = {
                    buftypes = { "terminal", "nofile", "quickfix", "prompt" },
                    filetypes = {
                        "help",
                        "lazy",
                        "mason",
                        "notify",
                        "TelescopePrompt",
                        "TelescopeResults",
                        "NvimTree",
                        "Trouble",
                        "dashboard",
                        "gitcommit",
                    },
                },
            })
        end,
    },
}
