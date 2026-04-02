local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local c = require("libs.config")

-- Safely execute immediately
now(function()
  require("mini.notify").setup()
  vim.notify = require("mini.notify").make_notify()
end)
now(function()
  require("mini.icons").setup()
  require("mini.tabline").setup()
  -- require("mini.statusline").setup()
end)

later(function()
  require("mini.ai").setup()
  require("mini.comment").setup()
  require("mini.pairs").setup()
  require("mini.pick").setup()
end)

now(function()
  add({
    source = "neovim/nvim-lspconfig",
    depends = { "williamboman/mason.nvim" },
  })
end)

add({
  source = "zbirenbaum/copilot.lua",
})
require("copilot").setup({})

add({
  source = "nvim-treesitter/nvim-treesitter",
  checkout = "master",
  monitor = "main",
  hooks = {
    post_checkout = function()
      vim.cmd("TSUpdate")
    end,
  },
})
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
})

-- File explorer [[
do
  add({ source = "stevearc/oil.nvim" })
  require("oil").setup({
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    }
  })
  add({
    source = "nvim-neo-tree/neo-tree.nvim",
    checkout = "v3.x",
    depends = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  })
  c.load_conf("neo-tree")
end
-- ]]

add({
  source = "nvim-lualine/lualine.nvim",
  depends = { "nvim-tree/nvim-web-devicons" },
})
c.load_conf("lualine")

add({ source = "aznhe21/actions-preview.nvim" })

add({
  source = "williamboman/mason.nvim",
  hooks = {
    post_checkout = function()
      vim.cmd("MasonUpdate")
    end,
  },
})
require("mason").setup({})

add({
  source = "williamboman/mason-lspconfig.nvim",
  hooks = {
    post = function()
      vim.cmd("MasonUpdate")
    end,
  },
})
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "vtsls",
  },
  automatic_installation = true,
})

-- Themes [[
do
  add({ source = "rebelot/kanagawa.nvim" })
  add({ source = "nyoom-engineering/oxocarbon.nvim" })
  add({ source = "dgox16/oldworld.nvim" })
  add({
    source = "metalelf0/jellybeans-nvim",
    depends = {
      "rktjmp/lush.nvim"
    }
  })
  add({ source = "vague2k/vague.nvim" })
  require("vague").setup({})
  add({ source = "zaldih/themery.nvim" })
  require("themery").setup({
    themes = vim.fn.getcompletion("", "color"),
    livePreview = true,
  })
end
-- ]]

do
  add({ source = "stevearc/aerial.nvim" })
  require("aerial").setup {}

  add({
    source = "nvim-telescope/telescope.nvim",
    depends = {
      "nvim-lua/plenary.nvim",
    },
  })
  add({
    source = "danielfalk/smart-open.nvim",
    depends = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
  })
  c.load_conf("telescope")
end

add({
  source = "nvimtools/none-ls.nvim",
  depends = { "nvim-lua/plenary.nvim" },
})
add({ source = "jay-babu/mason-null-ls.nvim" })

add({
  source = "L3MON4D3/LuaSnip",
})
require("luasnip").setup({})
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()

add({
  source = "fang2hou/blink-copilot",
})
add({
  source = "saghen/blink.cmp",
  checkout = "v1.6.0",
  depends = {
    "L3MON4D3/LuaSnip",
  },
})
c.load_conf("blink")

later(function()
  add({ source = "lewis6991/hover.nvim" })
  c.load_conf("hover")
end)

later(function()
  add({ source = "folke/flash.nvim" })
  c.load_conf("flash")
end)

add({ source = "akinsho/toggleterm.nvim" })
c.load_conf("toggleterm")

later(function()
  add({ source = "stevearc/conform.nvim" })
  c.load_conf("conform")
end)

add({ source = "kevinhwang91/nvim-ufo", depends = { "kevinhwang91/promise-async" } })
c.load_conf("ufo")
add({ source = "luukvbaal/statuscol.nvim" })
c.load_conf("statuscol")

later(function()
  add({ source = "dnlhc/glance.nvim" })
  c.load_conf("glance")
end)
add({ source = "mrcjkb/rustaceanvim" })
add({ source = "kazhala/close-buffers.nvim" })

later(function()
  add({
    source = "wasabeef/bufferin.nvim",
    depends = {
      "nvim-tree/nvim-web-devicons",
    },
  })
  c.load_conf("bufferin")
end)

add({ source = "MeanderingProgrammer/render-markdown.nvim" })
require('render-markdown').setup({
  completions = { lsp = { enabled = true } },
})
add({ source = "kdheepak/lazygit.nvim" })
add({ source = "sitiom/nvim-numbertoggle" })
add({ source = "SmiteshP/nvim-navic", depends = { "neovim/nvim-lspconfig" } })

do
  add({ source = "b0o/incline.nvim" })
  add({ source = "shellRaining/hlchunk.nvim" })
  c.load_conf("incline")
  c.load_conf("hlchunk")
end

do
  add({ source = "jake-stewart/multicursor.nvim" })
  c.load_conf("multicursor")
end
