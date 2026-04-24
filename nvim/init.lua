-- vim.g.mapleader = ' '
vim.o.number = true
vim.o.relativenumber = true
vim.o.wildignorecase = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true
vim.o.wrap = false
vim.o.wrapscan = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
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
-- vim.o.cmdheight = 2
vim.o.scrolloff = 8
vim.o.autocomplete = true

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

vim.lsp.config('*', {
    capabilities = vim.lsp.protocol.make_client_capabilities()
})

vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = { command = "clippy" },
            procMacro = { enable = true },
        }
    }
})

vim.lsp.config('gopls', {
    cmd = { 'gopls' },
    filetypes = { 'go' },
    root_markers = { 'go.mod', '.git' },
    settings = {
        gopls = { 
            analyses = { unusedparams = true },
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

vim.lsp.enable({ 'rust_analyzer', 'gopls', 'clangd', 'zls' })

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', { clear = true }),
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
            group = vim.api.nvim_create_augroup('my.lsp.format.' .. args.buf, {
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
        border = 'rounded',
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
            border = 'rounded',
            max_width = vim.o.columns,
            wrap = true,
            severity_sort = true,
        })
    end,
})

vim.o.updatetime = 300

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('HighlightYank', {clear = true}),
    callback = function()
        vim.highlight.on_yank({
            timeout = 512,
        })
    end,
})
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.o.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine', {fg = 'NONE'})
vim.api.nvim_set_hl(0, 'CursorLineNr', {fg = '#fce094'})

-- vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#4f5258", bold = true })
vim.api.nvim_set_hl(0, 'StatusLine', { fg = '#e0e2ea', bg = '#4f5258', bold = true })
vim.o.statusline = '%#StatusLine# %F %h%m%r%=%-14.(%l,%c%V%) %y %P '

vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

require('nvim-treesitter').install({
    'c',
    'go',
    'zig',
    'ruby',
    'rust',
    'python'
})

vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang then
            vim.treesitter.start(args.buf, lang)
        end
    end,
})
