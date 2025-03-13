call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-fugitive'
  Plug 'rust-lang/rust.vim'
call plug#end()

if &compatible
	set nocompatible
endif

colorscheme lunaperche
set background=dark

filetype on
filetype plugin on
filetype indent on

syntax on

set textwidth=80
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set showmatch
set colorcolumn=80

set number
set relativenumber
set nowrap

set omnifunc=syntaxcomplete#Complete

set laststatus=2
set ruler
set title
set showcmd

runtime! ftplugin/man.vim
set hlsearch
set ignorecase
set smartcase
set incsearch

set nobackup
set noswapfile
let g:netrw_save_history=0

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set backspace=indent,eol,start

nnoremap <Esc> :nohlsearch<CR>
set updatetime=256
set timeoutlen=256

