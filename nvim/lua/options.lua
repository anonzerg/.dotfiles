-- basic options
-- vim.g.mapleader = ' '
vim.o.number = true
vim.o.relativenumber = true
vim.o.wildignorecase = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.wrap = false
vim.o.wrapscan = false
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.title = true
vim.cmd('syntax on')
vim.cmd.filetype('plugin indent on')
vim.o.confirm = true
vim.o.colorcolumn = '80'
vim.o.swapfile = false
vim.o.backup = false
vim.o.mouse = 'nv'
vim.o.signcolumn = 'yes'
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.termguicolors = true
vim.o.winborder = 'rounded'
vim.o.scrolloff = 8
vim.o.autocomplete = true
vim.o.updatetime = 300

-- status line and current line
vim.o.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine', {fg = 'NONE'})
vim.api.nvim_set_hl(0, 'CursorLineNr', {fg = '#fce094'})
vim.api.nvim_set_hl(0, 'StatusLine', { fg = '#ffffff', bg = '#4f5258', bold = true })
vim.o.statusline = '%#StatusLine# %F %h%m%r%=%-14.(%l,%c%V%) %y %P '
