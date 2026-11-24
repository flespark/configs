#!/bin/bash

##############################
# TODO LIST:
# swith shell prompt to starship
# bash config reentry defence
# switch tmux system to .tmux or tmuxp
#############################
set -e

read_bool() {
    if (($# == 1)); then
        read -p "$1 [Y/n] >"
        if [[ "$REPLY" =~ [Yy] ]]; then
            return 0
        else
            return 1
        fi

        echo "internal error: bad useage of ${FUNCNAME[0]}" >&2
    fi
}

# $1 src
# $2 merge dst
overlap_check() {
    local ldst lsame
    if (( $# == 2 )) && [ -f "$1" ] && [ -f "$1" ]; then
        ldst=$(wc -l "$2")
        lsame=$(diff -w --new-line-format="" --unchanged-line-format="" \
            <(sort -b "$1") <(sort -b "$2") | wc -l)
        if (( ((lsame * 100 / ldst)) < 70 )); then
            return 0
        else
            return 1
        fi
    fi

    echo "Error, $1 or $2 not regular file" >&2
    return 1;
}


bash_setup() {
    if [ -f $HOME/.bashrc ]; then
        echo "$HOME/.bashrc not exist, new created"
        cat /etc/skel/.bashrc linux/.bashrc > "$HOME/.bashrc"
    elif overlap_check ".bashrc" "$HOME/.bahrc"; then
        cat $HOME/.bashrc linux/.bashrc > "$HOME/.bashrc"
    else
        echo "$HOME/.bashrc seems have merged the content of .bashrc, skip."
        return 0
    fi
    for bash_file in linux/.inputrc linux/.bash_*; do
        if [ -f "$HOME/$bash_file" ]; then
            printf "bash_file: %s exist\n" "$bash_file"
            exit 1
        else
            ln -srL "$bash_file" "$HOME/"
        fi
    done
    . ~/.bashrc
}

vim_setup() {
    local features
    echo > common/.vim/.viminfo
    features=$(vim --version | sed -n -e '/+job/p' -e '/+channel/p' -e '/+timers/p' | wc -l)
    if ((features == 3)); then
        if [ -e "$HOME/.vimrc" ] || [ -L "$HOME/.vimrc" ]; then
            if read_bool "$HOME/.vimrc exist, overwrite it?"; then
                ln -srLf common/.vimrc "$HOME/"
            fi
        else
            ln -srL common/.vimrc "$HOME/"
        fi
        if [ -e "$HOME/.vim" ] || [ -L "$HOME/.vim" ]; then
            if read_bool "$HOME/.vim exist, replace it?"; then
                ln -srLf common/.vim "$HOME/"
            fi
        else
            ln -srL common/.vim "$HOME/"
        fi
    else
        echo -e "Vim version must above 8.0 with features +job +timer +channel for LSP support
        \rplease manually upgrade first!"
        return 1
    fi
}

nvim_setup() {
    if ! type -P nvim >/dev/null; then
        echo "nvim not installed, skip"
        return 0
    fi
    # .nvimrc reuses the vim config: prepends ~/.vim to runtimepath/packpath
    # and sources ~/.vimrc.
    mkdir -p "$HOME/.config/nvim"
    if [ -e "$HOME/.config/nvim/init.vim" ] || [ -L "$HOME/.config/nvim/init.vim" ]; then
        if read_bool "$HOME/.config/nvim/init.vim exist, overwrite it?"; then
            ln -srLf common/.nvimrc "$HOME/.config/nvim/init.vim"
        fi
    else
        ln -srL common/.nvimrc "$HOME/.config/nvim/init.vim"
    fi
}

git_setup() {
    if ! type -P git >/dev/null; then
        echo "git not installed"
        return 1
    fi
    local git_user, git_mail
    if [ -f $HOME/.gitconfig ]; then
        if read_bool "$HOME/.gitconfig exist, overwrite it?"; then
            git_user=$(git config user.name)
            git_mail=$(git config user.mail)
            for git_dir in .gitconfig  .git_*; do
                ln -srfL $git_dir $HOME/
            done
            git config -g user.name "$git_user" >/dev/null
            git config -g user.mail "$git_mail" >/dev/null
        else
            return 1
        fi
    else
        for git_dir in common/.gitconfig  common/.gitignore common/.git_*; do
            ln -srL $git_dir $HOME/
        done
    fi
}

editorconfig_setup() {
    # link like the other managed configs: repo updates reach home instantly,
    # and the lookup walks up from ~/Project/configs to ~/.editorconfig, so
    # the rules also govern this repo's own files outside common/.
    ln -srL common/.editorconfig "$HOME/.editorconfig"
}

tmux_setup() {
    ln -srfL common/.tmux.conf $HOME/
    # bootstrap tpm, the tmux plugin manager: it installs/serves the
    # plugins declared in .tmux.conf (prefix + I inside tmux).
    mkdir -p "$HOME/.tmux/plugins"
    if [ ! -d "$HOME/.tmux/plugins/tpm/.git" ]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
}

tldr_setup() {
    # tldr-py reads repo_directory from ~/.tldrrc (~/source/tldr);
    # formerly the tldr-pages git submodule.
    if [ -d "$HOME/source/tldr/.git" ]; then
        return 0
    fi
    mkdir -p "$HOME/source"
    git clone --depth 1 https://github.com/tldr-pages/tldr.git "$HOME/source/tldr"
}

plug_install() {
    if type -P nvim >/dev/null; then
        nvim --headless '+PlugInstall' '+qa' || echo "warn: PlugInstall failed, run :PlugInstall manually"
    elif type -P vim >/dev/null; then
        vim -es '+PlugInstall' '+qa' || echo "warn: PlugInstall failed, run :PlugInstall manually"
    fi
}

command_install() {
    local distro
    distro=$(sed -n 's/^ID=\([a-z]\+\)/\1/p' /etc/os-release)
    # FIXME: pacman use different pkg name
    pkg=linux/apt.pkglist


    case $distro in
        debian|ubuntu)
            apt-get update
            while read pkg; do
                apt install -y $pkg
            done < apt.pkglist
            ;;
        arch)
            pacman -Syu
            while read pkg; do
                pacman --noconfirm -S $pkg
            done < pacman.pkglist
            ;;
    esac
}

infect() {
    pushd $(git rev-parse --show-toplevel)
    echo $(dirname "${BASH_SOURCE[0]}")
    command_install
    bash_setup
    tmux_setup
    tldr_setup
    git_setup
    vim_setup
    nvim_setup
    plug_install
    popd
}

infect
