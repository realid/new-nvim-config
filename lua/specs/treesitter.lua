-- =========================================================
-- treesitter.lua（Neovim 0.11 + nvim-treesitter main 新 API）
--
-- 修复点：
-- 1) 不在 FileType 里同步 install + wait（这就是你“卡住”的原因）
-- 2) install_dir 必须放进 runtimepath，否则“装了也找不到”，会反复安装
-- 3) 只负责：启用高亮 + folds +（可选）indentexpr
-- 4) parser 安装改为“手动/后台”，不阻塞编辑
-- =========================================================

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            -- 1) 安装目录 + 加入 runtimepath（非常关键）
            local install_dir = vim.fn.stdpath("data") .. "/site"
            vim.opt.rtp:prepend(install_dir)
            ts.setup({ install_dir = install_dir })

            -- 2) 全局：默认不自动折叠（但折叠功能可用）
            vim.opt.foldenable = true
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99

            -- 3) 可选：是否自动后台安装缺失 parser（默认关：最稳）
            local AUTO_INSTALL = true

            local function ensure_parser_async(lang)
                if not AUTO_INSTALL then return end
                -- 如果语言 parser 不存在，就后台装一下（不 wait，不阻塞）
                local ok = pcall(vim.treesitter.language.add, lang, nil, true)
                if ok then return end
                vim.schedule(function()
                    pcall(ts.install, { lang }, { summary = false })
                end)
            end

            -- 4) FileType：只做“启用”，不做“同步安装/等待”
            local grp = vim.api.nvim_create_augroup("TSMainEnable", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = grp,
                pattern = "*",
                callback = function(ev)
                    local buf = ev.buf
                    if vim.bo[buf].buftype ~= "" then return end

                    local ft = vim.bo[buf].filetype
                    if not ft or ft == "" then return end

                    local lang = vim.treesitter.language.get_lang(ft) or ft
                    if not lang or lang == "" then return end

                    ensure_parser_async(lang)

                    -- 启用高亮
                    pcall(vim.treesitter.start, buf, lang)

                    -- 折叠（窗口局部）：可用但默认全展开
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldlevel = 99

                    -- 缩进（可选：如果你觉得缩进“怪”，就注释掉下一行）
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            -- 5) 提供一个手动安装常用 parser 的命令（需要时你自己执行）
            vim.api.nvim_create_user_command("TSInstallCommon", function()
                ts.install({
                    "lua", "vim", "vimdoc", "query",
                    "python", "c", "cpp",
                    "javascript", "typescript",
                    "bash", "cmake",
                    "json", "yaml",
                    "markdown", "markdown_inline",
                    "html", "css",
                }, { summary = true })
            end, {})
        end,
    },
}
