-- =========================================================
-- cmp.lua：nvim-cmp 补全
--
-- 加载时机：
-- - InsertEnter：进入插入模式才加载（启动更快）
--
-- 组成：
-- - nvim-cmp：补全框架
-- - cmp-nvim-lsp：LSP 补全源
-- - cmp-buffer/cmp-path：buffer 词/路径补全
-- - LuaSnip + cmp_luasnip + friendly-snippets：片段系统
-- - lspkind：补全项图标（可选）
--
-- 快捷键：
-- - <C-Space> 手动触发补全
-- - <CR> 确认（不默认 select）
-- - <Tab>/<S-Tab>：优先补全导航，其次 snippet 跳转
-- =========================================================

return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- LSP source
			"hrsh7th/cmp-nvim-lsp",
			-- other sources
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",

			-- snippets
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",

			-- nice icons (optional)
			{ "onsails/lspkind.nvim", event = "InsertEnter" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- 加载一堆常见 snippets（vscode 格式）
			pcall(function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end)

			local ok_lk, lspkind = pcall(require, "lspkind")

			cmp.setup({
				snippet = {
					-- 告诉 cmp：怎么展开 snippet 内容
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				-- 补全源：先 LSP/snippet，再 buffer/path
				sources = cmp.config.sources(
					{ { name = "nvim_lsp" }, { name = "luasnip" } },
					{ { name = "buffer" }, { name = "path" } }
				),

				-- 展示格式：图标+文字（没有 lspkind 也能跑）
				formatting = ok_lk and {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
					}),
				} or nil,
			})
		end,
	},
}
