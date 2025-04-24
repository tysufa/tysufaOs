-- IMPORTANT: make sure to setup neodev BEFORE lspconfig

vim.lsp.config("lua_ls", {
  cmd = {"lua-language-server"},
  root_markers = {".luarc.json"},
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    }
  }
})

vim.lsp.enable("lua_ls")


vim.lsp.config.clangd = {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
}

vim.lsp.enable({'clangd'})

vim.diagnostic.config({
  virtual_lines = { current_line = true },
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client:supports_method('textDocument/completion') then
--       vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--     end
--   end,
-- })
