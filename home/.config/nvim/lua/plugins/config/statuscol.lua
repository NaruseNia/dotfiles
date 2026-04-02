local builtin = require("statuscol.builtin")
require("statuscol").setup({
  bt_ignore = { "terminal", "nofile", "ddu-ff", "ddu-ff-filter" },
  relculright = true,
  setopt = true,
  segments = {
    { text = { "%s" }, click = "v:lua.ScSa" },
    {
      sign = {
        name = { "Diagnostic.*" },
        maxwidth = 1,
      },
    },
    -- {
    --   sign = {
    --     namespace = { "gitsigns" },
    --     maxwidth = 1,
    --     colwidth = 1,
    --     wrap = true,
    --   },
    -- },
    {
      text = { builtin.foldfunc },
      click = "v:lua.ScFa",
    },
    {
      text = { builtin.lnumfunc },
    },
    { text = { "│" } },
  },
})
