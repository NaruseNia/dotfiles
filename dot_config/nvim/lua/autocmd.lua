-- vim.api.nvim_create_autocmd({ "QuitPre" }, {
-- 	callback = function(context)
-- 		vim.api.nvim_buf_delete(context.buf, { force = true })
-- 	end,
-- })

-- local function on_cursor_hold()
--   vim.diagnostic.open_float()
-- end
--
-- local diagnostic_hover_augroup_name = "lspconfig-diagnostic"
--
-- local function enable_diagnostics_hover()
--   vim.api.nvim_create_augroup(diagnostic_hover_augroup_name, { clear = true })
--   vim.api.nvim_create_autocmd({ "CursorHold" }, { group = diagnostic_hover_augroup_name, callback = on_cursor_hold })
-- end
--
-- local function disable_diagnostics_hover()
--   vim.api.nvim_clear_autocmds({ group = diagnostic_hover_augroup_name })
-- end
--
-- vim.api.nvim_set_option('updatetime', 500)
-- enable_diagnostics_hover()
--
-- -- diagnosticがある行でホバーをするとすぐにdiagnosticのfloating windowで上書きされてしまうのを阻止する
-- -- ホバーをしたら一時的にdiagnosticを開くautocmdを無効化する
-- -- これだけだとそれ以降diagnosticが自動表示されなくなってしまうので有効化するautocmdを一回だけ発行して削除する
-- local function on_hover()
--   disable_diagnostics_hover()
--
--   vim.lsp.buf.hover()
--
--   vim.api.nvim_create_augroup("lspconfig-enable-diagnostics-hover", { clear = true })
--   -- ウィンドウの切り替えなどのイベントが絡んでくるとおかしくなるかもしれない
--   vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
--     {
--       group = "lspconfig-enable-diagnostics-hover",
--       callback = function()
--         vim.api.nvim_clear_autocmds({ group = "lspconfig-enable-diagnostics-hover" })
--         enable_diagnostics_hover()
--       end
--     })
-- end
--
-- vim.keymap.set('n', '<Leader>gl', on_hover, {})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf ---@type number
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      vim.keymap.set('n', '<leader>i', function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
          { bufnr = bufnr }
        )
      end, { buffer = bufnr })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})
