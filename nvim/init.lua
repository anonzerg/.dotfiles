vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = false
vim.opt.wrap = false
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
vim.cmd("syntax on")
vim.opt.showcmd = true
vim.opt.confirm = true
vim.opt.ruler = true
vim.opt.colorcolumn = "80"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.o.completeopt = "menuone,noselect"
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.o.winborder = "single"

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
    enable = true,
  },
  ensure_installed = {
    "c", "zig", "lua", "python", "rust", "ruby", "go", "make",
  },
  auto_install = false,
}

vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities()
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local opts = { buffer = args.buf, silent = true }
    
    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    end
    if client:supports_method("textDocument/references") then
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    end
    if client:supports_method("textDocument/implementation") then
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    end
    if client:supports_method("textDocument/hover") then
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end
    if client:supports_method("textDocument/signatureHelp") then
      vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
    end
    if client:supports_method("textDocument/rename") then
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end
    if client:supports_method("textDocument/codeAction") then
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
    if not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp.format." .. args.buf, { clear = true }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = args.buf,
            id = client.id,
            timeout_ms = 1000
          })
        end,
      })
    end
  end,
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
})
vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", },
  root_markers = { ".clangd", "compile_commands.json", ".git" },
})
vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig" },
  root_markers = { "build.zig", ".git" },
  settings = {
    zig = {
      enableBuildOnSave = true,
      buildOnSaveStep = "check",
    },
  },
})
vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        features = "all",
      },
      checkOnSave = true
    },
  },
})

vim.diagnostic.config({
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
  underline = true,
  severity_sort = true,
  float = {
    border = "single",
    format = function(diagnostic)
      if diagnostic.source then
        return string.format("%s: %s", diagnostic.source, diagnostic.message)
      end
      return diagnostic.message
    end,
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
  if result then
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      vim.lsp.util.buf_highlight_references(ctx.bufnr, result, client.offset_encoding)
    end
  end
end

vim.lsp.enable({ "gopls", "clangd", "zls", "rust_analyzer" })

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      border = "single",
      max_width = vim.o.columns,
      wrap = true,
      severity_sort = true,
    })
  end,
})

vim.o.updatetime = 300

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", {clear = true}),
  callback = function()
    vim.highlight.on_yank({
      timeout = 512,
    })
  end,
})
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.o.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", {fg = "NONE"})
vim.api.nvim_set_hl(0, "CursorLineNr", {fg = "#fce094"})

vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#4f5258", bold = true })
vim.o.statusline = "%#StatusLine# %F %h%m%r%=%-14.(%l,%c%V%) %y %P "
