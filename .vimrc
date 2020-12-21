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
noremap <leader> p
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>
nnoremap <esc><esc> :nohlsearch<return><esc>
nnoremap <silent> <leader>p :set paste<cr>
inoremap jj <esc>
