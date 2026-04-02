local M = {}

-- Palette extracted from aizen_base.itermcolors
local p = {
  bg            = "#141414",
  bg_dark       = "#111111",
  bg_float      = "#141414",
  bg_cursorline = "#222228",
  bg_visual     = "#333333",
  bg_gutter     = "#1a1a1a",

  fg            = "#d0d6f0",
  fg_dim        = "#9098b8",
  fg_dark       = "#6068a0",

  red           = "#f08898",
  green         = "#a4e09c",
  yellow        = "#f5dea4",
  blue          = "#84b4f8",
  magenta       = "#c8a2f4",
  cyan          = "#90dcd0",
  orange        = "#f8b080",
  white         = "#ffffff",

  comment       = "#5a5a7a",
  grey          = "#444444",
  none          = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.setup()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "aizen"

  -- Editor UI
  hi("Normal", { fg = p.fg, bg = p.bg })
  hi("NormalFloat", { fg = p.fg, bg = p.bg_float })
  hi("FloatBorder", { fg = p.fg_dark, bg = p.bg_float })
  hi("FloatTitle", { fg = p.magenta, bg = p.bg_float, bold = true })
  hi("Cursor", { fg = p.bg, bg = p.orange })
  hi("CursorLine", { bg = p.bg_cursorline })
  hi("CursorColumn", { bg = p.bg_cursorline })
  hi("ColorColumn", { bg = p.bg_cursorline })
  hi("LineNr", { fg = p.grey })
  hi("CursorLineNr", { fg = p.orange, bold = true })
  hi("SignColumn", { fg = p.fg_dark, bg = p.bg_gutter })
  hi("FoldColumn", { fg = p.grey, bg = p.bg_gutter })
  hi("Folded", { fg = p.fg_dim, bg = p.bg_cursorline })
  hi("VertSplit", { fg = p.grey })
  hi("WinSeparator", { fg = p.grey })
  hi("Visual", { bg = p.bg_visual })
  hi("VisualNOS", { bg = p.bg_visual })
  hi("Search", { fg = p.bg, bg = p.yellow })
  hi("IncSearch", { fg = p.bg, bg = p.orange })
  hi("CurSearch", { fg = p.bg, bg = p.orange })
  hi("Substitute", { fg = p.bg, bg = p.red })
  hi("MatchParen", { fg = p.orange, bold = true, underline = true })
  hi("NonText", { fg = p.grey })
  hi("SpecialKey", { fg = p.grey })
  hi("Whitespace", { fg = p.grey })
  hi("EndOfBuffer", { fg = p.bg })
  hi("Directory", { fg = p.blue })
  hi("Conceal", { fg = p.fg_dark })
  hi("WildMenu", { fg = p.bg, bg = p.blue })

  -- Pmenu
  hi("Pmenu", { fg = p.fg, bg = p.bg_float })
  hi("PmenuSel", { fg = p.bg, bg = p.blue })
  hi("PmenuSbar", { bg = p.bg_visual })
  hi("PmenuThumb", { bg = p.fg_dark })

  -- StatusLine / TabLine
  hi("StatusLine", { fg = p.fg, bg = p.bg_cursorline })
  hi("StatusLineNC", { fg = p.fg_dark, bg = p.bg_dark })
  hi("TabLine", { fg = p.fg_dark, bg = p.bg_dark })
  hi("TabLineFill", { bg = p.bg_dark })
  hi("TabLineSel", { fg = p.fg, bg = p.bg, bold = true })
  hi("WinBar", { fg = p.fg_dim, bg = p.none, bold = true })
  hi("WinBarNC", { fg = p.fg_dark, bg = p.none })

  -- Messages
  hi("MsgArea", { fg = p.fg })
  hi("ModeMsg", { fg = p.blue, bold = true })
  hi("MoreMsg", { fg = p.green })
  hi("ErrorMsg", { fg = p.red })
  hi("WarningMsg", { fg = p.yellow })
  hi("Question", { fg = p.cyan })
  hi("Title", { fg = p.magenta, bold = true })

  -- Diff
  hi("DiffAdd", { bg = "#1e2e1e" })
  hi("DiffChange", { bg = "#1e1e2e" })
  hi("DiffDelete", { fg = p.red, bg = "#2e1e1e" })
  hi("DiffText", { bg = "#2a2a40" })

  -- Spell
  hi("SpellBad", { sp = p.red, undercurl = true })
  hi("SpellCap", { sp = p.yellow, undercurl = true })
  hi("SpellLocal", { sp = p.cyan, undercurl = true })
  hi("SpellRare", { sp = p.magenta, undercurl = true })

  -- Syntax
  hi("Comment", { fg = p.comment, italic = true })
  hi("Constant", { fg = p.orange })
  hi("String", { fg = p.green })
  hi("Character", { fg = p.green })
  hi("Number", { fg = p.orange })
  hi("Boolean", { fg = p.orange })
  hi("Float", { fg = p.orange })
  hi("Identifier", { fg = p.fg })
  hi("Function", { fg = p.blue })
  hi("Statement", { fg = p.magenta })
  hi("Conditional", { fg = p.magenta })
  hi("Repeat", { fg = p.magenta })
  hi("Label", { fg = p.cyan })
  hi("Operator", { fg = p.fg_dim })
  hi("Keyword", { fg = p.magenta, italic = true })
  hi("Exception", { fg = p.red })
  hi("PreProc", { fg = p.cyan })
  hi("Include", { fg = p.magenta })
  hi("Define", { fg = p.magenta })
  hi("Macro", { fg = p.cyan })
  hi("PreCondit", { fg = p.cyan })
  hi("Type", { fg = p.yellow })
  hi("StorageClass", { fg = p.magenta })
  hi("Structure", { fg = p.yellow })
  hi("Typedef", { fg = p.yellow })
  hi("Special", { fg = p.cyan })
  hi("SpecialChar", { fg = p.orange })
  hi("Tag", { fg = p.red })
  hi("Delimiter", { fg = p.fg_dim })
  hi("SpecialComment", { fg = p.comment, bold = true })
  hi("Debug", { fg = p.red })
  hi("Underlined", { fg = p.blue, underline = true })
  hi("Ignore", { fg = p.grey })
  hi("Error", { fg = p.red })
  hi("Todo", { fg = p.yellow, bg = p.bg_cursorline, bold = true })

  -- Diagnostics
  hi("DiagnosticError", { fg = p.red })
  hi("DiagnosticWarn", { fg = p.yellow })
  hi("DiagnosticInfo", { fg = p.blue })
  hi("DiagnosticHint", { fg = p.cyan })
  hi("DiagnosticOk", { fg = p.green })
  hi("DiagnosticUnderlineError", { sp = p.red, undercurl = true })
  hi("DiagnosticUnderlineWarn", { sp = p.yellow, undercurl = true })
  hi("DiagnosticUnderlineInfo", { sp = p.blue, undercurl = true })
  hi("DiagnosticUnderlineHint", { sp = p.cyan, undercurl = true })
  hi("DiagnosticVirtualTextError", { fg = p.red, bg = "#2a1a1e" })
  hi("DiagnosticVirtualTextWarn", { fg = p.yellow, bg = "#2a2418" })
  hi("DiagnosticVirtualTextInfo", { fg = p.blue, bg = "#1a1e2a" })
  hi("DiagnosticVirtualTextHint", { fg = p.cyan, bg = "#1a2a28" })

  -- LSP
  hi("LspReferenceText", { bg = p.bg_visual })
  hi("LspReferenceRead", { bg = p.bg_visual })
  hi("LspReferenceWrite", { bg = p.bg_visual, bold = true })
  hi("LspSignatureActiveParameter", { fg = p.orange, bold = true })
  hi("LspInlayHint", { fg = p.fg_dark, italic = true })

  -- Treesitter
  hi("@variable", { fg = p.fg })
  hi("@variable.builtin", { fg = p.red, italic = true })
  hi("@variable.parameter", { fg = p.fg_dim })
  hi("@variable.member", { fg = p.cyan })
  hi("@constant", { fg = p.orange })
  hi("@constant.builtin", { fg = p.orange, italic = true })
  hi("@module", { fg = p.fg_dim })
  hi("@string", { fg = p.green })
  hi("@string.escape", { fg = p.orange })
  hi("@string.regexp", { fg = p.cyan })
  hi("@character", { fg = p.green })
  hi("@number", { fg = p.orange })
  hi("@boolean", { fg = p.orange })
  hi("@type", { fg = p.yellow })
  hi("@type.builtin", { fg = p.yellow, italic = true })
  hi("@type.qualifier", { fg = p.magenta })
  hi("@attribute", { fg = p.cyan })
  hi("@property", { fg = p.cyan })
  hi("@function", { fg = p.blue })
  hi("@function.builtin", { fg = p.blue, italic = true })
  hi("@function.call", { fg = p.blue })
  hi("@function.macro", { fg = p.cyan })
  hi("@function.method", { fg = p.blue })
  hi("@function.method.call", { fg = p.blue })
  hi("@constructor", { fg = p.yellow })
  hi("@operator", { fg = p.fg_dim })
  hi("@keyword", { fg = p.magenta, italic = true })
  hi("@keyword.function", { fg = p.magenta, italic = true })
  hi("@keyword.return", { fg = p.magenta, italic = true })
  hi("@keyword.operator", { fg = p.magenta })
  hi("@keyword.import", { fg = p.magenta })
  hi("@keyword.conditional", { fg = p.magenta })
  hi("@keyword.repeat", { fg = p.magenta })
  hi("@keyword.exception", { fg = p.red })
  hi("@punctuation.bracket", { fg = p.fg_dim })
  hi("@punctuation.delimiter", { fg = p.fg_dim })
  hi("@punctuation.special", { fg = p.cyan })
  hi("@comment", { fg = p.comment, italic = true })
  hi("@comment.todo", { fg = p.yellow, bold = true })
  hi("@comment.note", { fg = p.cyan, bold = true })
  hi("@comment.warning", { fg = p.orange, bold = true })
  hi("@comment.error", { fg = p.red, bold = true })
  hi("@tag", { fg = p.red })
  hi("@tag.attribute", { fg = p.yellow })
  hi("@tag.delimiter", { fg = p.fg_dim })
  hi("@markup.heading", { fg = p.magenta, bold = true })
  hi("@markup.strong", { bold = true })
  hi("@markup.italic", { italic = true })
  hi("@markup.strikethrough", { strikethrough = true })
  hi("@markup.link", { fg = p.blue, underline = true })
  hi("@markup.link.url", { fg = p.cyan, underline = true })
  hi("@markup.raw", { fg = p.green })
  hi("@markup.list", { fg = p.magenta })

  -- Git signs
  hi("GitSignsAdd", { fg = p.green })
  hi("GitSignsChange", { fg = p.blue })
  hi("GitSignsDelete", { fg = p.red })

  -- Telescope
  hi("TelescopeNormal", { fg = p.fg, bg = p.bg_float })
  hi("TelescopeBorder", { fg = p.fg_dark, bg = p.bg_float })
  hi("TelescopePromptNormal", { fg = p.fg, bg = p.bg_cursorline })
  hi("TelescopePromptBorder", { fg = p.fg_dark, bg = p.bg_cursorline })
  hi("TelescopePromptTitle", { fg = p.bg, bg = p.magenta, bold = true })
  hi("TelescopePreviewTitle", { fg = p.bg, bg = p.green, bold = true })
  hi("TelescopeResultsTitle", { fg = p.bg, bg = p.blue, bold = true })
  hi("TelescopeSelection", { bg = p.bg_visual })
  hi("TelescopeMatching", { fg = p.orange, bold = true })

  -- Indent Blankline
  hi("IblIndent", { fg = "#252530" })
  hi("IblScope", { fg = p.magenta })

  -- Lazy
  hi("LazyH1", { fg = p.bg, bg = p.magenta, bold = true })
  hi("LazyButton", { fg = p.fg_dim, bg = p.bg_cursorline })
  hi("LazyButtonActive", { fg = p.bg, bg = p.blue, bold = true })
  hi("LazySpecial", { fg = p.cyan })

  -- Aerial
  hi("AerialLine", { bg = p.bg_visual })

  -- Notify
  hi("NotifyERRORBorder", { fg = p.red })
  hi("NotifyWARNBorder", { fg = p.yellow })
  hi("NotifyINFOBorder", { fg = p.blue })
  hi("NotifyDEBUGBorder", { fg = p.fg_dark })
  hi("NotifyTRACEBorder", { fg = p.magenta })
  hi("NotifyERRORIcon", { fg = p.red })
  hi("NotifyWARNIcon", { fg = p.yellow })
  hi("NotifyINFOIcon", { fg = p.blue })
  hi("NotifyDEBUGIcon", { fg = p.fg_dark })
  hi("NotifyTRACEIcon", { fg = p.magenta })
  hi("NotifyERRORTitle", { fg = p.red, bold = true })
  hi("NotifyWARNTitle", { fg = p.yellow, bold = true })
  hi("NotifyINFOTitle", { fg = p.blue, bold = true })
  hi("NotifyDEBUGTitle", { fg = p.fg_dark, bold = true })
  hi("NotifyTRACETitle", { fg = p.magenta, bold = true })

  -- Cmp
  hi("CmpItemAbbr", { fg = p.fg })
  hi("CmpItemAbbrMatch", { fg = p.blue, bold = true })
  hi("CmpItemAbbrMatchFuzzy", { fg = p.blue, bold = true })
  hi("CmpItemAbbrDeprecated", { fg = p.fg_dark, strikethrough = true })
  hi("CmpItemKindFunction", { fg = p.blue })
  hi("CmpItemKindMethod", { fg = p.blue })
  hi("CmpItemKindVariable", { fg = p.fg })
  hi("CmpItemKindKeyword", { fg = p.magenta })
  hi("CmpItemKindText", { fg = p.fg_dim })
  hi("CmpItemKindProperty", { fg = p.cyan })
  hi("CmpItemKindUnit", { fg = p.orange })
  hi("CmpItemKindSnippet", { fg = p.yellow })
  hi("CmpItemKindFile", { fg = p.fg_dim })
  hi("CmpItemKindFolder", { fg = p.blue })
end

M.palette = p

return M
