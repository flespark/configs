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
" disable auto line feed
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

" get off arrow key
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>
" defend error type lead mess
noremap <U> <nop>
noremap <K> <nop>
" set undo breakpoint for unintentional C-w & C-u
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 4/3)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 3/4)<CR>
nnoremap <silent> <leader>p :set paste!<cr>
nnoremap <esc><esc> :nohlsearch<return><esc>
nnoremap <silent> <leader>l <esc>:set norelativenumber! nonumber!<cr>
" clean trailing whitspace
nnoremap <silent> <F12> :let _s=@/ <bar> :%s/\s\+$//e <bar> :let @/=_s <bar> :nohl <bar> :unlet _s <cr>
inoremap jj <esc>
" not auto indent when comment
autocmd BufNewFile,BufReadPost * if &filetype == "python" | set indentkeys-=0# | endif
autocmd BufNewFile,BufReadPost * if &filetype == "yaml" | set expandtab shiftwidth=2 indentkeys-=0# | endif

" fzf-vim shortkey
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>

" air-line
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'jellybeans'

" ale
let g:ale_linters = {
\       'c': ['clangd'],
\       'bash': ['shellcheck'],
\       'python': ['pylint'],
\}
let g:ale_linters_explicit = 1
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 300
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

nn <silent> <M-d> :ALEGoToDefinition<cr>
nn <silent> <M-r> :ALEFindReferences<cr>
nn <silent> <M-a> :ALESymbolSearch<cr>
"nn <silent> <M-h> :ALEHover<cr>

" autopair
packadd! auto-pairs

" easymotion
packadd! vim-easymotion
map <Leader><Leader> <Plug>(easymotion-prefix)
