require('mason-lspconfig').setup_handlers({ function(server)
  local opt = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  if server ~= 'jdtls' then
    require('lspconfig')[server].setup(opt)
  end
end })
