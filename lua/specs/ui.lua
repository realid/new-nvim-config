-- =========================================================
-- ui.lua：UI 相关插件
--
-- 加载策略（尽量不抢启动）：
-- - 主题：必须立即加载（lazy=false + priority），避免闪屏
-- - lualine/bufferline：VeryLazy（界面稳定后再加载）
-- - indent-blankline：打开文件后再加载（BufReadPost/BufNewFile）
--
-- 快捷键策略：
-- - bufferline 的快捷键用 spec.keys 挂载
--   好处：按键按下时如果插件未加载，lazy 会先加载插件再执行
-- =========================================================

return {
    -- 主题（必须最早）
    {
        "morhetz/gruvbox",
        lazy = false,    -- 启动立即加载
        priority = 1000, -- 优先级很高，确保最先设置 colorscheme
        config = function()
            vim.opt.background = "dark"
            pcall(vim.cmd, "colorscheme gruvbox")
        end,
    },

    -- 图标库（很多 UI 插件会用，但不必抢启动）
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- 状态栏
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy", -- Neovim 初始化后再加载，启动更快
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local lualine = require("lualine")

            -- 在状态栏显示当前 buffer attach 的 LSP 名称
            local function lsp_name()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if not clients or #clients == 0 then return "" end
                local names = {}
                for _, c in ipairs(clients) do
                    if c and c.name and c.name ~= "" then
                        names[#names + 1] = c.name
                    end
                end
                if #names == 0 then return "" end
                return "LSP:" .. table.concat(names, ",")
            end

            -- Codex 状态（装了 johnseth97/codex.nvim 才会有）
            local codex_component = nil
            do
                local ok, codex = pcall(require, "codex")
                if ok and type(codex.status) == "function" then
                    codex_component = codex.status()  -- 注意：这是 table（lualine component spec）
                end
            end

            lualine.setup({
                options = {
                    theme = "gruvbox",
                    globalstatus = true, -- 单一全局状态栏（更清爽）
                    disabled_filetypes = {
                        statusline = { "lazy", "mason" }, -- 这些页面不显示状态栏更清爽
                    },
                },
                sections = {
                    lualine_a = { "mode" },

                    -- git 信息
                    lualine_b = {
                        "branch",
                        { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
                    },

                    -- 文件信息：相对路径 + 修改标记
                    lualine_c = {
                        { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" } },
                    },

                    -- 右侧信息（尽量“有用但不吵”）
                    lualine_x = (function()
                        local x = {
                            { "diagnostics", sources = { "nvim_diagnostic" } },
                            lsp_name,
                            "filetype",
                        }
                        if codex_component then
                            table.insert(x, 2, codex_component) -- 插到 diagnostics 后面
                        end
                        return x
                    end)(),


                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- 顶部 buffer 标签栏
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },

        -- keys：lazy 自动挂键 + 按键触发时可自动加载插件
        keys = (function()
            local keys = {
                { "<C-n>", "<cmd>BufferLineCycleNext<CR>", desc = "BufferLine next" },
                { "<C-p>", "<cmd>BufferLineCyclePrev<CR>", desc = "BufferLine prev" },
                { "<leader>bd", "<cmd>bdelete<CR>", desc = "Delete buffer" },
            }
            -- <leader>1..9 跳转到第 N 个 buffer
            for i = 1, 9 do
                table.insert(keys, {
                    "<leader>" .. i,
                    function()
                        pcall(vim.cmd, "BufferLineGoToBuffer " .. i)
                    end,
                    desc = "Go to buffer " .. i,
                })
            end
            return keys
        end)(),

        config = function()
            require("bufferline").setup({
                options = {
                    numbers = "ordinal",
                    diagnostics = "nvim_lsp",    -- 结合 LSP 诊断显示小图标
                    separator_style = "slant",
                },
            })
        end,
    },

    -- 缩进线（ibl）：打开文件再加载
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "VeryLazy" },
        config = function()
            local ibl = require("ibl")
            ibl.setup({
                indent = { char = "▏", tab_char = "▏" },
                scope = {
                    enabled = true,     -- 显示作用域（函数/块范围）
                    show_start = false,
                    show_end = false,
                },
                exclude = {
                    buftypes = { "terminal", "nofile", "quickfix", "prompt" },
                    filetypes = {
                        "help", "lazy", "mason", "notify",
                        "TelescopePrompt", "TelescopeResults",
                        "NvimTree", "Trouble", "dashboard", "gitcommit",
                    },
                },
            })
        end,
    },
}

