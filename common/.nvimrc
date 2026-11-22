" Neovim loader: reuse the shared Vim config.
" (nvim does not fall back to ~/.vimrc since 0.12, so this file is sourced
" from ~/.config/nvim/init.vim — a symlink managed alongside this repo.)
"
" runtimepath first so plug#begin resolves through ~/.vim/autoload/plug.vim;
" packpath too, because packpath is fixed at startup and does not follow
" later runtimepath changes (~/.vim/pack/*/start needs it).
set runtimepath^=~/.vim
set packpath^=~/.vim
source ~/.vimrc
