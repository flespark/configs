set relativenumber number
syntax on
set ignorecase smartcase
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
"a faciler leader key
let mapleader = "\<space>"
"take away from arrow key
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>
"set undo breakpoint for unintentional C-w & C-u
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
nnoremap <silent> <leader>p :set paste!<cr>
nnoremap <esc><esc> :nohlsearch<return><esc>
nnoremap <silent> <leader>l <esc>:set norelativenumber! nonumber!<cr>
nnoremap <silent> <F12> :let _s=@/ <bar> :%s/\s\+$//e <bar> :let @/=_s <bar> :nohl <bar> :unlet _s <cr>
inoremap jj <esc>
