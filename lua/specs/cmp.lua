-- =========================================================
-- cmp.lua：nvim-cmp 补全（InsertEnter 才加载）
-- =========================================================

return {
	-- nvim-cmp：补全引擎
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- cmp-nvim-lsp：LSP 补全来源
			"hrsh7th/cmp-nvim-lsp",
			-- cmp-buffer：缓冲区词条补全
			"hrsh7th/cmp-buffer",
			-- cmp-path：路径补全
			"hrsh7th/cmp-path",

			-- LuaSnip：片段引擎
			"L3MON4D3/LuaSnip",
			-- cmp_luasnip：将 LuaSnip 作为补全来源
			"saadparwaiz1/cmp_luasnip",
			-- friendly-snippets：预置片段集合
			"rafamadriz/friendly-snippets",

			-- lspkind.nvim：补全项图标
			{ "onsails/lspkind.nvim", event = "InsertEnter" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- 按需加载 VSCode 风格片段，避免启动时不必要的耗时。
			pcall(function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end)

			-- lspkind 仅用于补全项图标，不影响核心功能。
			local ok_lk, lspkind = pcall(require, "lspkind")

			cmp.setup({
				-- 片段展开逻辑统一交给 LuaSnip。
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					-- 基础补全触发/确认
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Tab/Shift-Tab：在补全项与片段跳转间切换。
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
				-- 来源优先级：LSP/片段在前，缓冲区/路径在后。
				sources = cmp.config.sources(
					{ { name = "nvim_lsp" }, { name = "luasnip" } },
					{ { name = "buffer" }, { name = "path" } }
				),
				-- 若 lspkind 可用则启用图标格式化。
				formatting = ok_lk and {
					format = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 }),
				} or nil,
			})
		end,
	},
}
