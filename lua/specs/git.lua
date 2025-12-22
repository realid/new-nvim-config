-- =========================================================
-- git.lua：gitsigns
-- =========================================================

return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signcolumn = true,
            current_line_blame = false,
        },
        config = function(_, opts)
            local gs = require("gitsigns")
            gs.setup(vim.tbl_deep_extend("force", opts, {
                on_attach = function(bufnr)
                    local map = vim.keymap.set
                    local o = { noremap = true, silent = true, buffer = bufnr }

                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(gs.next_hunk)
                        return "<Ignore>"
                    end, vim.tbl_extend("force", o, { expr = true }))

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(gs.prev_hunk)
                        return "<Ignore>"
                    end, vim.tbl_extend("force", o, { expr = true }))

                    map("n", "<leader>gs", gs.preview_hunk, o)
                    map("n", "<leader>gr", gs.reset_hunk, o)
                    map("n", "<leader>gb", gs.blame_line, o)
                end,
            }))
        end,
    },
}
