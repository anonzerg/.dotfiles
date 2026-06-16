require("options")
require("lsp")
require("keymaps")

-- highlights selected text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('HighlightYank', {clear = true}),
  callback = function()
    vim.highlight.on_yank({
      timeout = 512,
    })
  end,
})

-- jumps to last position in text buffer
local function jump_to_last_pos()
  local last_pos = vim.api.nvim_buf_get_mark(0, '"')
  local line_count = vim.api.nvim_buf_line_count(0)
  if last_pos[1] > 0 and last_pos[1] <= line_count then
    vim.api.nvim_win_set_cursor(0, last_pos)
  end
end
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = jump_to_last_pos
})

-- packages
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
})
require('nvim-treesitter').install({ 'c', 'go', 'zig', 'rust', 'ruby', 'python', 'julia' })
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end
    local ok = pcall(vim.treesitter.start, args.buf, lanf)
  end,
})
