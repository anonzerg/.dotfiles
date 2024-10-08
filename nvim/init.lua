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
vim.opt.expandtab = false
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
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.colorcolumn = "80"
vim.opt.swapfile = false
vim.opt.backup = false

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

require("lspconfig").gopls.setup({})

