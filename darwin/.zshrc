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

# prompt: synced from linux/.bashrc (fallback) + linux/.bash_env (powerline-go).
# powerline-go installs to ~/go/bin (GOPATH default) via:
#   go install github.com/justjanne/powerline-go@latest
PROMPT='%{\e[0;31m%}%T %{\e[32m%}%1~ %{\e[36m%}>%{\e[00m%}'

function _update_ps1() {
    PROMPT="$($HOME/go/bin/powerline-go -cwd-max-depth 4 -cwd-mode semifancy -modules user,ssh,cwd,perms,git,exit,root -git-assume-unchanged-size 2048 -error $?)"
}

if [ "$TERM" != "linux" ] && [ -x "$HOME/go/bin/powerline-go" ]; then
    precmd() { _update_ps1 }
fi
