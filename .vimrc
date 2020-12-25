set relativenumber number
syntax on
colorscheme peachpuff
set tabstop=8
set shiftwidth=8
set noexpandtab
filetype plugin indent on
set cursorline
set hlsearch
set encoding=utf8

"enable netrw file explorer
set nocp
let mapleader = "\<space>"
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>
nnoremap <silent> <leader>p :set paste!<cr>
nnoremap <esc><esc> :nohlsearch<return><esc>
nnoremap <silent> <leader>l <esc>:set norelativenumber! nonumber!<cr>
:nnoremap <silent> <F5> :let _s=@/ <bar> :%s/\s\+$//e <bar> :let @/=_s <bar> :nohl <bar> :unlet _s <cr>
inoremap jj <esc>
