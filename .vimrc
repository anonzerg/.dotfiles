if &compatible
	set nocompatible
endif

syntax on
filetype plugin indent on

set background=dark
colorscheme default

set textwidth=80
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set showmatch

set number
set relativenumber
set wrap

set omnifunc=syntaxcomplete#Complete

set laststatus=2
set ruler
set title
set showcmd

runtime! ftplugin/man.vim
set hlsearch
set ignorecase

set nobackup
set noswapfile
let g:netrw_save_history=0

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set backspace=indent,eol,start

