scriptencoding utf-8
set encoding=utf-8

syntax on

set nocompatible
set noshowmode

set cursorline
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set nowrap

set ignorecase
set smartcase
set showcmd
set showmatch
set hlsearch
set incsearch
set scrolloff=5

set history=100

set number
set relativenumber
set signcolumn=yes
set termguicolors
set mouse=a

set list
set listchars=tab:>-,lead:.,trail:.,multispace:.,nbsp:-
set sidescroll=1
set fileformat=unix

filetype plugin indent on

let mapleader=" "

call plug#begin()
    Plug 'machakann/vim-highlightedyank'

    Plug 'vim-airline/vim-airline'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-fugitive'

    Plug 'sheerun/vim-polyglot'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'joshdick/onedark.vim'

    Plug 'jasonccox/vim-wayland-clipboard'
call plug#end()

colorscheme onedark
let g:airline_theme='onedark'
let g:onedark_terminal_italics=1

let g:highlightedyank_highlight_duration = 100
let g:airline_powerline_fonts = 1

inoremap <left> <nop>
inoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>

source ~/.vim/coc.vim
