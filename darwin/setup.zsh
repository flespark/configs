#!/bin/zsh

zsh_setup() {
    # macOS ln has no -r: link by absolute path from the repo root (infect
    # pushd'd here). Existing files are skipped, not fatal.
    # .zshrc/.zshenv have no underscore: the glob alone never matched them.
    for zsh_file in darwin/.zshrc darwin/.zshenv darwin/.zsh_*; do
        local dst="$HOME/${zsh_file:t}"
        if [ -e "$dst" ] || [ -L "$dst" ]; then
            printf "zsh file: %s exist, skip\n" "$dst"
        else
            ln -s "$(pwd)/$zsh_file" "$dst"
        fi
    done
}

vim_setup() {
    local features
    features=$(vim --version | sed -n -e '/+job/p' -e '/+channel/p' -e '/+timers/p' | wc -l)
    if ((features == 3)); then
        for vim_file in .vimrc .vim; do
            if [ -e "$HOME/$vim_file" ] || [ -L "$HOME/$vim_file" ]; then
                printf "vim file: %s exist\n" "$HOME/$vim_file"
                exit 1
            fi
        done
        # macOS ln has no -r: link by absolute path from the repo root (infect
        # pushd'd here).
        ln -s "$(pwd)/common/.vimrc" "$HOME/.vimrc"
        ln -s "$(pwd)/common/.vim" "$HOME/.vim"
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
    ln -s "$(pwd)/common/.nvimrc" "$HOME/.config/nvim/init.vim"
}

tmux_setup() {
    if [ -e "$HOME/.tmux.conf" ] || [ -L "$HOME/.tmux.conf" ]; then
        printf "tmux file: %s exist\n" "$HOME/.tmux.conf"
        exit 1
    fi
    ln -s "$(pwd)/common/.tmux.conf" "$HOME/.tmux.conf"
    # bootstrap tpm, the tmux plugin manager (prefix + I inside tmux).
    mkdir -p "$HOME/.tmux/plugins"
    if [ ! -d "$HOME/.tmux/plugins/tpm/.git" ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
}

starship_setup() {
    mkdir -p "$HOME/.config"
    if [ -e "$HOME/.config/starship.toml" ] || [ -L "$HOME/.config/starship.toml" ]; then
        printf "starship config: %s exist, skip\n" "$HOME/.config/starship.toml"
        return 0
    fi
    # macOS ln has no -r: link by absolute path from the repo root (infect
    # pushd'd here). starship reads ~/.config/starship.toml by default.
    ln -s "$(pwd)/common/.starship.toml" "$HOME/.config/starship.toml"
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
    # official installer; the aliyun mirror is abandoned (brew.git data
    # incomplete - see the linked .zshenv for the NO_AUTO_UPDATE/CLEANUP vars).
    if ! command -v brew >/dev/null; then
        /bin/zsh -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"
    fi
    # restore the tracked tool/app lists (formulae leaves + casks)
    while read -r pkg; do
        [ -n "$pkg" ] && brew install "$pkg"
    done < darwin/brew.pkglist
    while read -r cask; do
        [ -n "$cask" ] && brew install --cask "$cask"
    done < darwin/brew.casklist
}

infect() {
    pushd $(git rev-parse --show-toplevel)
    zsh_setup
    vim_setup
    nvim_setup
    starship_setup
    tmux_setup
    plug_install
    brew_setup
    popd
}
