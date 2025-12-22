-- =========================================================
-- treesitter.lua（Neovim 0.11 + nvim-treesitter main 新 API）
--
-- 你当前环境已经在用 main 新 API（install / indentexpr / 手动 start）
-- 所以这里按“新 API”写，并把逻辑理清：
--
-- 目标：
-- 1) 打开文件后自动启用高亮（vim.treesitter.start）
-- 2) 默认不自动折叠（foldlevel=99），但折叠功能可用（zo/zc/zR/zM）
-- 3) 缩进可选启用（indentexpr），不满意就注释掉那一行
-- 4) 首次打开某语言文件，尝试补装 parser（最多等 2 秒，不折磨启动）
--
-- 注意：
-- - foldlevelstart 是“全局选项”，不能用 vim.wo 设置，只能 vim.o / vim.opt
-- - foldmethod / foldexpr / foldlevel 是“窗口选项”（vim.wo）
-- =========================================================

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            -- A) treesitter parser 安装目录
            ts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            -- B) 预装常用 parser（异步，不等待）
            ts.install({
                "lua",
                "vim",
                "vimdoc",
                "query",
                "python",
                "c",
                "cpp",
                "javascript",
                "typescript",
                "bash",
                "cmake",
                "json",
                "yaml",
                "markdown",
                "markdown_inline",
                "html",
                "css",
            }, { summary = false })

            -- C) 全局：默认不自动折叠
            vim.opt.foldlevelstart = 99

            -- D) FileType：对普通文件 buffer 启用 treesitter 功能
            local grp = vim.api.nvim_create_augroup("TSMainEnable", { clear = true })

            vim.api.nvim_create_autocmd("FileType", {
                group = grp,
                pattern = "*",
                callback = function(ev)
                    local buf = ev.buf

                    -- 跳过特殊 buffer（lazy/mason/help/terminal 等）
                    if vim.bo[buf].buftype ~= "" then
                        return
                    end

                    local ft = vim.bo[buf].filetype
                    if not ft or ft == "" then
                        return
                    end

                    -- filetype -> treesitter language（例如 typescriptreact）
                    local lang = vim.treesitter.language.get_lang(ft) or ft
                    if not lang or lang == "" then
                        return
                    end

                    -- D1) 兜底安装 parser（最多等 2 秒）
                    do
                        local ok, task = pcall(ts.install, { lang }, { summary = false })
                        if ok and task and task.wait then
                            pcall(task.wait, task, 2000)
                        end
                    end

                    -- D2) 启用高亮（buffer-local）
                    pcall(vim.treesitter.start, buf, lang)

                    -- D3) 启用缩进（buffer-local，可选）
                    -- 不喜欢 treesitter 缩进就把下一行注释掉
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    -- D4) 启用折叠（window-local），但默认全展开
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldenable = true
                    vim.wo.foldlevel = 99
                end,
            })
        end,
    },
}
