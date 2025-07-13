local cmp = require("cmp")
local snip = require("luasnip")
local lspkind = require("lspkind")

local options = {
	snippet = {
		expand = function(args)
			snip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if snip.expandable() then
					snip.expand()
				else
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
				end
			else
				fallback()
			end
		end),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif snip.locally_jumpable(1) then
				snip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "calc" },
		{ name = "emoji" },
		{ name = "crates" },
		{ name = "luasnip" },
	},
	experimental = {
		ghost_text = true,
	},
	-- window = {
	-- 	completion = {
	-- 		winhightlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
	-- 		col_offset = 0,
	-- 		side_padding = 0,
	-- 		scrollbar = true,
	-- 	},
	-- },
	-- 	formatting = {
	-- 		fields = { "kind", "abbr", "menu" },
	-- 		format = function(entry, vim_item)
	-- 			local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 80 })(entry, vim_item)
	-- 			local strings = vim.split(kind.kind, "%s", { trimempty = true })
	-- 			-- kind.kind = " " .. strings[1] .. "  "
	-- 			-- kind.menu = "    (" .. strings[2] .. ") "
	-- 			kind.kind = " " .. strings[1]
	-- 			kind.menu = ""
	--
	-- 			return kind
	-- 		end,
	-- 	},
}

options = vim.tbl_deep_extend("force", options, require("nvchad.cmp"))
cmp.setup(options)

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})
