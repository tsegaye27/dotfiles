set nocompatible
set encoding=utf-8
set fileformats=unix,dos,mac

syntax on
if has("termguicolors")
 set termguicolors
endif
set background=dark

set number
set relativenumber
set cursorline
set showmatch
" set visualbell
set t_Co=256
set signcolumn=yes
set scrolloff=8
set sidescrolloff=8
set display=lastline

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent
set laststatus=2

set incsearch
set hlsearch
set ignorecase
set smartcase

set hidden
set history=1000
set undofile
set undodir=~/.vim/undo
set wrap
set linebreak
set wildmenu
set wildmode=longest:full,full
set mouse=a
set clipboard=unnamedplus
set lazyredraw
set ttyfast
set sessionoptions-=options
set viewoptions-=options

set updatetime=300
set timeoutlen=500
set ttimeoutlen=10
