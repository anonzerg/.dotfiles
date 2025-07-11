vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = false
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.showmatch = true
vim.opt.autoindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.title = true
vim.opt.wildmenu = true
vim.opt.syntax = "on"
vim.opt.showcmd = true
vim.opt.confirm = true
vim.opt.laststatus = 3
vim.opt.ruler = true
vim.opt.colorcolumn = "80"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.mouse = ""
-- vim.opt.scrolloff = 0

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     local last_line = vim.fn.getline('$')
--     if last_line ~= '' then
--       vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
--     end
--   end,
-- })

local function jump_to_last_pos()
  local last_pos = vim.api.nvim_buf_get_mark(0, '"')
  local line_count = vim.api.nvim_buf_line_count(0)
  if last_pos[1] > 0 and last_pos[1] <= line_count then
    vim.api.nvim_win_set_cursor(0, last_pos)
  end
end

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = jump_to_last_pos,
})

require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  },
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single"
})

local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(
    bufnr,
    "omnifunc",
    "v:lua.vim.lsp.omnifunc"
  )
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", {
        clear = true
      }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          async = false
        })
      end,
    })
  end
  local opts = {
    noremap = true,
  }
  vim.api.nvim_buf_set_keymap(
    bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts
  )
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
lspconfig.zls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.diagnostic.config({
  update_in_insert = false,
  virtual_lines = true,
  -- virtual_text = true,
  signs = false,
  underline = true,
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     vim.diagnostic.open_float(nil, {
--       focusable = false,
--       border = "single",
--       max_width = vim.o.columns,
--       wrap = true,
--       severity_sort = true,
--     })
--   end,
-- })

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(env)
--     local client = vim.lsp.get_client_by_id(env.data.client_id)
--     if client.supports_method("textDocument/completion") then
--       vim.lsp.completion.enable(true, client.id, env.buf, {autotrigger = true})
--     end
--   end,
-- })

vim.o.updatetime = 128

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", {clear = true}),
  callback = function()
    vim.highlight.on_yank({
      timeout = 512,
    })
  end,
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c", "zig", "lua", "python", "rust", "ruby", "go", "make", "html", "css",
    "javascript",
  },
  auto_install = false,
}

vim.o.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", {fg = "NONE"})
vim.api.nvim_set_hl(0, "CursorLineNr", {fg = "#fce094"})

vim.o.statusline = " %F %h%m%r%=%-14.(%l,%c%V%) %y %P "

