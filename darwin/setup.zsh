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
    brew_setup
    popd
}
