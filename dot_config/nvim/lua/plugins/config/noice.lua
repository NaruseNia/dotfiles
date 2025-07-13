local wrapper = function(event, kind, pattern)
  event = event or "msg_show"
  kind = kind or ""
  return {
    filter = {
      event = event,
      kind = kind,
      find = pattern,
    },
    opts = { skip = true },
  }
end

local suppressed = {
  wrapper("lsp", "progress", "Validate document"),
  wrapper("lsp", "progress", "Publish Diagnostics")
}

require("noice").setup({
  views = {
    cmdline_popup = {
      border = {
        style = "none",
        padding = { 1, 2 },
      },
      filter_options = {},
      win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  cmdline = {
    enabled = true,
    format = {
      search_down = {
        view = "cmdline",
      },
      search_up = {
        view = "cmdline",
      },
    },
  },
  messages = {
    enabled = true,              -- enables the Noice messages UI
    view = "mini",               -- default view for messages
    view_error = "mini",         -- view for errors
    view_warn = "mini",          -- view for warnings
    view_history = "messages",   -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
  lsp = {
    signature = {
      enabled = false, -- enables the Noice signature UI
    },
    hover = {
      enabled = false, -- enables the Noice hover UI
    },
  },
  routes = suppressed,
})
