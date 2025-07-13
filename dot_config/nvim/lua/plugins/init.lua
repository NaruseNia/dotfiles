local config_util = require("libs._set_config")
local load_conf = config_util.load_conf
local load_confs = config_util.load_confs

require("lazy").setup({
  "onsails/lspkind.nvim",

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "L3MON4D3/LuaSnip",
  "hrsh7th/nvim-cmp",

  -- Mason, LSP, DAP, Lint and etc.
  "aznhe21/actions-preview.nvim",
  "hrsh7th/nvim-gtd",
  "ollykel/v-vim",
  {
    "williamboman/mason.nvim",
    version = "^1.0.0",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "^1.0.0",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },
  "jay-babu/mason-nvim-dap.nvim",
  {
    "github/copilot.vim",
    lazy = false,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false,   -- This plugin is already lazy
  },
  {
    "ranjithshegde/ccls.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup({
        filetypes = { "c", "cpp" }
      })
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    config = function()
      require("crates").setup()
    end,
  },
  -- {
  --   "nvimdev/lspsaga.nvim",
  --   config = function()
  --     require("lspsaga").setup({
  --       implement = {
  --         enable = false,
  --       }
  --     })
  --   end,
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter", -- optional
  --     "nvim-tree/nvim-web-devicons",     -- optional
  --   }
  -- },
  {
    "oclay1st/gradle.nvim",
    cmd = { "Gradle", "GradleExec", "GradleInit" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {}, -- options, see default configuration
    keys = {
      {
        "<Leader>G",
        function()
          require("gradle").toggle_projects_view()
        end,
        desc = "Gradle",
      },
    },
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {} -- your configuration
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-context",
    build = ":TSUpdate",
  },

  -- Fizzy
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      -- Only required if using match_algorithm fzf
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  },
  "sindrets/diffview.nvim",
  "paopaol/telescope-git-diffs.nvim",
  {
    "linrongbin16/fzfx.nvim",
    -- Optional to avoid break changes between major versions.
    version = "v7.*",
    dependencies = { "nvim-tree/nvim-web-devicons", "junegunn/fzf" },
    config = function()
      require("fzfx").setup()
    end,
  },

  -- UI
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "antosha417/nvim-lsp-file-operations",
  "nvim-lua/lsp-status.nvim",
  "shellRaining/hlchunk.nvim",
  "dstein64/nvim-scrollview",
  "luukvbaal/statuscol.nvim",
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = false,
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "nvchad/ui",
    config = function()
      require("nvchad")
    end,
    dependencies = { "nvim-lua/plenary.nvim", "nvchad/volt" },
  },
  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    },
    config = function()
      local dropbar_api = require("dropbar.api")
      vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
      vim.keymap.set("n", "[;", dropbar_api.goto_context_start,
        { desc = "Go to start of current context" })
      vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
    end
  },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup {
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          -- require('hover.providers.dap')
          -- require('hover.providers.fold_preview')
          require('hover.providers.diagnostic')
          -- require('hover.providers.man')
          -- require('hover.providers.dictionary')
          -- require('hover.providers.highlight')
        end,
        preview_opts = {
          border = 'rounded'
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = true,
        title = false,
        mouse_delay = 1000
      }

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end,
        { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end,
        { desc = "hover.nvim (next source)" })

      -- Mouse support
      vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
      vim.o.mousemoveevent = true
    end
  },

  -- Utils
  "numToStr/Comment.nvim",
  "yamatsum/nvim-cursorline",
  "mattn/emmet-vim",
  "code-biscuits/nvim-biscuits",
  "toppair/reach.nvim",
  "kazhala/close-buffers.nvim",
  "sitiom/nvim-numbertoggle",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = { char = "┊" },
      whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
      },
      scope = {
        enabled = true,
      },
    },
  },
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {}, -- needed even when using default config
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    }
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  { "akinsho/toggleterm.nvim", version = "*",       config = true },
  {
    "ghillb/cybu.nvim",
    branch = "main",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
    }
  },
  {
    "samharju/yeet.nvim",
    dependencies = {
      "stevearc/dressing.nvim", -- optional, provides sane UX
    },
    version = "*",              -- use the latest release, remove for master
    cmd = "Yeet",
    opts = {},
  },
  {
    "jedrzejboczar/possession.nvim",
    init = function()
      require("possession").setup({})
    end,
  },
  "kdheepak/lazygit.nvim",
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- For blink.cmp's completion
    -- source
    -- dependencies = {
    --     "saghen/blink.cmp"
    -- },
  },
  {
    'dnlhc/glance.nvim',
    cmd = 'Glance'
  },

  -- UX
  "monaqa/dial.nvim",
  "rainbowhxch/accelerated-jk.nvim",
  "kosayoda/nvim-lightbulb",
  "tris203/precognition.nvim",
  "windwp/nvim-ts-autotag",
  "nvim-focus/focus.nvim",
  "rapan931/lasterisk.nvim",
  {
    "saifulapm/commasemi.nvim",
    lazy = false,
    opts = {
      leader = "<localleader>",
      keymaps = true,
      commands = true
    }
  },
  {
    "m4xshen/autoclose.nvim",
    init = function()
      require("autoclose").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {},
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({})
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    -- Note (lazy loading): grug-far.lua defers all it"s requires so it"s lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
      });
    end
  },
  {
    "wasabeef/bufferin.nvim",
    cmd = { "Bufferin" },
    config = function()
      require("bufferin").setup()
    end,
    -- Optional dependencies for enhanced experience
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- For file icons
      -- "willothy/nvim-cokeline",     -- For buffer line integration
      -- "akinsho/bufferline.nvim",    -- Alternative buffer line
    }
  },
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
  },
  {
    "bassamsdata/namu.nvim",
    config = function()
      require("namu").setup({
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {}, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        ui_select = { enable = false }, -- vim.ui.select() wrapper
      })
      -- === Suggested Keymaps: ===
      vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
        desc = "Jump to LSP symbol",
        silent = true,
      })
      vim.keymap.set("n", "<leader>sw", ":Namu workspace<cr>", {
        desc = "LSP Symbols - Workspace",
        silent = true,
      })
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000,    -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end
  },
  {
    'felpafel/inlay-hint.nvim',
    event = 'LspAttach',
    config = function()
      require("inlay-hint").setup {
        virt_text_pos = "inline",
      }
    end,
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end
  },

  -- Color
  "RRethy/base16-nvim",
  "nanotech/jellybeans.vim",
  "vim-scripts/Spacegray.vim",
  "AlessandroYorba/Alduin",
  "baskerville/bubblegum",
  "w0ng/vim-hybrid",
  "frenzyexists/aquarium-vim",
  "rebelot/kanagawa.nvim",
  "vague2k/vague.nvim",
  { "catppuccin/nvim",         name = "catppuccin", priority = 1000 },
  { "rose-pine/neovim",        name = "rose-pine" },
  {
    "killitar/obscure.nvim",
    priority = 1000,
    opts = {
      styles = {
        keywords = { italic = false },
        identifiers = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
        booleans = { italic = false },
        comments = { italic = false },
      },
    },
  },

  -- Git
  "sindrets/diffview.nvim",
  "lewis6991/gitsigns.nvim",

  -- AI
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",

      behaviour = {
        auto_suggestions = true,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = false,
        minimize_diff = true,
      },

      windows = {
        position = "right",
        wrap = true,
        width = 30,
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    }
  },

  -- Themes
  "morhetz/gruvbox",
})

load_confs({
  "common",
  "cmp",
  "lspkind",
  "lsp",
  "lsp-config",
  "mason-lspconfig",
  "mason-adaptor",
  "ccls",
  "telescope",
  "neo-tree",
  "noice",
  "toggleterm",
  "conform",
  "ufo",
  "statuscol",
  "scrollview",
})
