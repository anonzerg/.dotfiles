-- language server settings
vim.lsp.config('*', {
  capabilities = vim.lsp.protocol.make_client_capabilities()
})
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('languageServer', { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local opts = { buffer = args.buf, noremap = true, silent = true }

    if client:supports_method('textDocument/definition') then
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end
    if client:supports_method('textDocument/signatureHelp') then
      vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
    end
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
    if not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('languageServer.lsp.format.' .. args.buf, {
        clear = true
      }),
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
      end,
    })
    end
  end,
})

vim.diagnostic.config({
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.HINT] = 'H',
      [vim.diagnostic.severity.INFO] = 'I',
    },
  },
  underline = true,
  severity_sort = true,
  float = {
    format = function(diagnostic)
      if diagnostic.source then
        return string.format('%s: %s', diagnostic.source, diagnostic.message)
      end
    return diagnostic.message
    end,
  },
})

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      max_width = vim.o.columns,
      wrap = true,
      severity_sort = true,
    })
  end,
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod', '.git' },
  settings = {
    gopls = { 
      analyses = { unusedparams = true, nilness = true, shadow = true },
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  root_markers = { '.clangd', '.clang-format', 'compile_commands.json', '.git' },
})

vim.lsp.config('zls', {
  cmd = { 'zls' },
  filetypes = { 'zig' },
  root_markers = { 'build.zig', 'zls.json', '.git' },
})

vim.lsp.enable({ 'gopls', 'clangd', 'zls' })
