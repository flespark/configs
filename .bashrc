
PS1='\[\033[0;31m\]\A \[\033[32m\]\W \[\033[36m\]>\[\033[00m\]'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias fd2='find ./* -maxdepth 2 -name'
alias fd3='find ./* -maxdepth 3 -name'
alias fd4='find ./* -maxdepth 4 -name'
alias fd5='find ./* -maxdepth 5 -name'
alias ta='tmux attach'
alias lg='grep -inrI ./ -e'
alias lf='grep -inrIF ./ -e'

export FZF_DEFAULT_COMMAND='find -type f'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
