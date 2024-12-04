vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.wildignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.showmatch = true
vim.opt.autoindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.title = true
vim.opt.ttimeout = false
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
vim.opt.scrolloff = 0

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local last_line = vim.fn.getline('$')
    if last_line ~= '' then
      vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
    end
  end,
})

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

local lspconfig = require("lspconfig")
lspconfig.gopls.setup({})
lspconfig.clangd.setup({})
lspconfig.zls.setup({})

vim.diagnostic.config({
  update_in_insert = true,
  virtual_text = true,
  signs = false,
  underline = true,
})

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
  ensure_installed = {"c", "zig", "lua", "python", "rust", "toml", "ruby", "go", "make"},
  auto_install = false,
}

