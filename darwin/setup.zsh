#!/bin/zsh

zsh_setup() {
    for zsh_file in darwin/.zsh_*; do
        if [ -f "$HOME/$zsh_file" ]; then
            printf "zsh file: %s exist\n" "$zsh_file"
            exit 1
        else
            ln -srL "$zsh_file" "$HOME/"
        fi
    done
}

vim_setup() {
    local features
    features=$(vim --version | sed -n -e '/+job/p' -e '/+channel/p' -e '/+timers/p' | wc -l)
    if ((features == 3)); then
        for vim_file in common/.vimrc common/.vim; do
            if [ -e "$HOME/$vim_file" ] || [ -L "$HOME/$vim_file" ]; then
                printf "vim file: %s exist\n" "$HOME/$vim_file"
                exit 1
            fi
        done
        ln -srL common/.vimrc "$HOME/"
        ln -srL common/.vim "$HOME/"
    else
        printf "Vim version must above 8.0 with features +job +timer +channel for LSP support\n"
        printf "macOS bundled vim lacks these; 'brew install vim' first, then re-run.\n"
        return 1
    fi
}

nvim_setup() {
    if ! command -v nvim >/dev/null; then
        printf "nvim not installed, skip\n"
        return 0
    fi
    # .nvimrc reuses the vim config: prepends ~/.vim to runtimepath/packpath
    # and sources ~/.vimrc.
    mkdir -p "$HOME/.config/nvim"
    if [ -e "$HOME/.config/nvim/init.vim" ] || [ -L "$HOME/.config/nvim/init.vim" ]; then
        printf "nvim init: %s exist\n" "$HOME/.config/nvim/init.vim"
        exit 1
    fi
    ln -srL common/.nvimrc "$HOME/.config/nvim/init.vim"
}

tmux_setup() {
    if [ -e "$HOME/.tmux.conf" ] || [ -L "$HOME/.tmux.conf" ]; then
        printf "tmux file: %s exist\n" "$HOME/.tmux.conf"
        exit 1
    fi
    ln -srL common/.tmux.conf "$HOME/"
    # bootstrap tpm, the tmux plugin manager (prefix + I inside tmux).
    mkdir -p "$HOME/.tmux/plugins"
    if [ ! -d "$HOME/.tmux/plugins/tpm/.git" ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
}

plug_install() {
    if command -v nvim >/dev/null; then
        nvim --headless '+PlugInstall' '+qa' || printf "warn: PlugInstall failed\n"
    elif command -v vim >/dev/null; then
        vim -es '+PlugInstall' +qa || printf "warn: PlugInstall failed\n"
    fi
}

editorconfig_setup() {
    if [ -e "$HOME/.editorconfig" ] || [ -L "$HOME/.editorconfig" ]; then
        printf "editorconfig: %s exist, skip\n" "$HOME/.editorconfig"
        return 0
    fi
    # macOS ln has no -r: link by absolute path from the repo root (infect
    # pushd'd here). The lookup walks up from ~/Project/configs to ~/.editorconfig,
    # so the rules also govern this repo's own files outside common/.
    ln -s "$(pwd)/common/.editorconfig" "$HOME/.editorconfig"
}

brew_setup() {
	# download homebrew from aliyun mirros and install
	git clone https://mirrors.aliyun.com/homebrew/install.git brew-install
	/bin/zsh brew-install/install.sh
	rm -rf brew-install

	# from github
	# /bin/zsh -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"

	# use aliyun mirror
	echo 'export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api"' >> ~/.zshrc
	echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"' >> ~/.zshrc
	echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"' >> ~/.zshrc
	echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"' >> ~/.zshrc
	source ~/.zshrc
	brew update
}

infect() {
    pushd $(git rev-parse --show-toplevel)
    zsh_setup
    vim_setup
    nvim_setup
    tmux_setup
    plug_install
    brew_setup
    popd
}
