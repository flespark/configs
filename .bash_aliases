alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ta='tmux attach'

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
	alias lg='rg -inS -e'
	alias lw='rg -inw -e'
	alias lf='rg -inF -e'
	alias lgc='rg -in -tc -e'
	alias lgm='rg -in -tamake -tmake -e'
else
	alias lg='grep -inrI ./ -e'
	alias lf='grep -inrIF ./ -e'
fi

