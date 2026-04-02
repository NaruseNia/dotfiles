local global_exclude_filetypes = {
  aerial = true,
  dashboard = true,
  oil = true,
}

require("hlchunk").setup {
  chunk = {
    enable = true,
    use_treesitter = true,
    style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
    notify = false,
    priority = 0,
    exclude_filetypes = global_exclude_filetypes,
  },
  blank = {
    enable = true,
    style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
    priority = 9,
    chars = { "·" },
  },
}
