" ban backspace for a better command edit habit
set nocompatible
set autoindent
set relativenumber number
syntax on
set showmatch
set ignorecase smartcase
set incsearch
colorscheme jellybeans
hi normal guibg=NONE ctermbg=NONE
hi endofbuffer guibg=NONE ctermbg=NONE
filetype plugin indent on
set cursorline
" disable auto line feed
set nowrap
set hlsearch
set showmatch
" paste mode will obstruct auto-pairs, use shortkey
" set paste
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

set undofile
set undodir=~/.vim/undo
set viminfo=%,<100,'10,/50,:100,h,f0,n~/.vim/.viminfo
" manually save/load view
" set viewoptions=folds,cursor,curdir
" manually save/load session
" set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal
set directory=~/.vim/swap
set backup
set backupdir=~/.vim/backup

" get off arrow key
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>
" ban useless key prone to hit
noremap <U> <nop>
noremap <K> <nop>
" set undo breakpoint for unintentional C-w & C-u
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 4/3)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 3/4)<CR>
" Hex read
nmap <Leader>hr :%!xxd<CR> :set filetype=xxd<CR>
" Hex write
nmap <Leader>hw :%!xxd -r<CR> :set binary<CR> :set filetype=<CR>
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
\       'c': ['ccls'],
\       'sh': ['shellcheck'],
\       'python': ['pylint'],
\}
let g:ale_linters_explicit = 1
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 300
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_insert_leave = 1
let g:ale_c_clangd_options = '--clang-tidy --completion-style=bundled --suggest-missing-includes'
let g:ale_c_parse_makefile = 1
let g:airline#extensions#ale#enabled = 1

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nn <silent> <M-d> :ALEGoToDefinition<cr>
nn <silent> <M-r> :ALEFindReferences<cr>
nn <silent> <M-a> :ALESymbolSearch<cr>
"nn <silent> <M-h> :ALEHover<cr>

" autopair
" let g:AutoPairsFlyMode = 1
packadd! auto-pairs

" easymotion
packadd! vim-easymotion
map <Leader><Leader> <Plug>(easymotion-prefix)
