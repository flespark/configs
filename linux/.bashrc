
# correct the spell error in cd command
shopt -s cdspell

PS1='\[\033[0;31m\]\A \[\033[32m\]\W \[\033[36m\]>\[\033[00m\]'

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_alias
fi

if [ -f ~/.bash_env ]; then
	. ~/.bash_env
fi

if [ -f ~/.bash_command ]; then
	. ~/.bash_command
fi

if type -P fzf &>/dev/null;then

if fd -V &>/dev/null;then
	# Use fd (https://github.com/sharkdp/fd) instead of the default find
	# command for listing path candidates.
	# - The first argument to the function ($1) is the base path to start traversal
	# - See the source code (completion.{bash,zsh}) for the details.
	_fzf_compgen_path() {
		fd --hidden --follow --exclude ".git" . "$1"
	}

	# Use fd to generate the list for directory completion
	_fzf_compgen_dir() {
		fd --type d --hidden --follow --exclude ".git" . "$1"
	}

fi

fi

#load fzf default config
. ~/.fzf/key-bindings.bash
. ~/.fzf/completion.bash
