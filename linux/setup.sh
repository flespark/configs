#!/bin/bash

##############################
# TODO LIST:
# swith shell prompt to starship
# bash config reentry defence 
# switch tmux system to .tmux or tmuxp
#############################
set -e
thold=70
RPATH="${BASH_SOURCE[0]}"

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
        if [ -f $HOME/.vimrc ]; then
            read_bool "$HOME/.vimrc exist, overwrite it?" && \
                ln -srLf /common/.vimrc $HOME/
        fi
        if [ -d .vim ]; then
            read_bool "$HOME/.vim exist, replace it?" && \
                ln -srLf common/.vim $HOME/
        fi
    else
        echo -e "Vim version must above 8.0 with features +job +timer +channel for LSP support
        \rplease manually upgrade first!"
        return 1
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

tmux_setup() {
    ln -srfL common/.tmux.conf $HOME/
    ln -srfL common/.tmux $HOME/
}

command_install() {
    local distro
    local machtype
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
    git submodule update --init
    echo $(dirname "${BASH_SOURCE[0]}")
    command_install
    bash_setup
    tmux_setup
    git_setup
    vim_setup
    popd
}

infect
