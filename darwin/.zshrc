HISTSIZE=5000
SAVEHIST=5000

setopt IGNORE_EOF

source ~/.zsh_alias

# environment token save in single file
source ~/.secret.env

# mask proxy under tun mode
# toggle_proxy on
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/simon/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Keep emacs keybind explicitly, zsh change to vi keybind when grep vi in EDITOR
bindkey -e


# Added by Antigravity CLI installer
export PATH="/Users/simon/.local/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

