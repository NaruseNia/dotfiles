local exports = {}

exports.base46 = {
  changed_themes = {
    gruvchad = {
      base_16 = {
        base00 = "#191c19",
      },
      base_30 = {
        baby_pink = "#f75779",
        black = "#191c19",
      },
    },
  },
  theme = "gruvchad",
}

exports.ui = {
  cmp = {
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    format_colors = {
      tailwind = false,
    },
    icons_left = false,
  },
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
  },
}

exports.lsp = {
  signature = true,
}

return exports
