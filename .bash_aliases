alias ll='ls -alF'
alias lf='ls -d'
alias lt='ls -lt'
alias la='ls -A'
alias l='ls -CF'
alias md='mkdir'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias mk='make'
alias ta='tmux attach 2>/null || tmux'
alias vd='vimdiff'
alias lr='less -r'
alias rf='readlink -f'
alias gd='git diff --no-index'
alias path='echo -e ${PATH//:/\\n}'
alias gc='git clone'
alias cx='cd `git rev-parse --show-toplevel`'

if [ $(type -P fd-find && alias fd='fd-find' || type -P fd) &>/dev/null ];then
	alias fd2='fd -d 2'
	alias fd3='fd -d 3'
	alias fd4='fd -d 4'
	alias fd5='fd -d 5'
else
	alias fd2='find -maxdepth 2 -name'
	alias fd3='find -maxdepth 3 -name'
	alias fd4='find -maxdepth 4 -name'
	alias fd5='find -maxdepth 5 -name'
fi

if type -P rg &>/dev/null;then
	alias gg='rg -inS -e'
	alias gw='rg -inw -e'
	alias gf='rg -inF -e'
	alias gc='rg -in -tc -e'
	alias gm='rg -in -tamake -tmake -e'
else
	alias gg='grep -inrI ./ -e'
	alias gf='grep -inrIF ./ -e'
fi

