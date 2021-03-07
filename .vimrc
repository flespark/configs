" ban backspace for a better command edit habit
set backspace=
set nocompatible
set autoindent
set nowrap
set relativenumber number
syntax on
set showmatch
set ignorecase smartcase
set incsearch
colorscheme jellybeans
filetype plugin indent on
set cursorline
" turn off auto line feed display
set nowrap
set hlsearch
set showmatch
" hide buffer when switch
set hidden
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
set tags=./.tags;,.tags
" a faciler leader key
let mapleader = "\<space>"

set foldenable
set foldmethod=indent
set foldlevel=99

"take away from arrow key
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>
" set undo breakpoint for unintentional C-w & C-u
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 4/3)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 3/4)<CR>
nnoremap <silent> <leader>p :set paste!<cr>
nnoremap <esc><esc> :nohlsearch<return><esc>
nnoremap <silent> <leader>l <esc>:set norelativenumber! nonumber!<cr>
nnoremap <silent> <F12> :let _s=@/ <bar> :%s/\s\+$//e <bar> :let @/=_s <bar> :nohl <bar> :unlet _s <cr>
inoremap jj <esc>
" fzf-vim shortkey
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>

