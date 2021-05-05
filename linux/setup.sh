#!/bin/bash

read_bool() {
    if (($# == 1));then
        read -p "$1 [Y/n] >"
        if [[ "$REPLY" =~ [Yy] ]]; then
            return 0
        else
            return 1
        fi

        echo "internal error: bad useage of ${FUNCNAME[0]}" >&2
    fi
}

bash_setup() {
    test -f $HOME/.bashrc && \
        cat $HOME/.bashrc .bashrc > $HOME/.bashrc || \
        printf "$HOME/.bashrc not find, exit!"; exit 1
    for bash_file in .inputrc .bash_*; do
       test -f "$HOME/$bash_file" && \
           printf "bash_file: %s exist" "$bash_file" || \
           ln -srL "$bash_file" "$HOME/"
    done
    . ~/.bashrc
}

vim_setup() {
    local features
    features=$(vim --version | sed -n -e '/+job/p' -e '/+channel/p' -e '/+timers/p' | wc -l)
    if ((features == 3)); then
        if [ -f $HOME/.vimrc ]; then
            read_bool "$HOME/.vimrc exist, overwrite it?" && \
                ln -srLf .vimrc $HOME/
        fi
        if [ -d .vim ]; then
            read_bool "$HOME/.vim exist, replace it?" && \
                ln -srLf .vim $HOME/
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
        for git_dir in .gitconfig  .gitignore .git_*; do
            ln -srL $git_dir $HOME/
        done
    fi
}

tmux_setup() {
    ln -srfL .tmux.conf $HOME/
    ln -srfL .tmux $HOME/
}

command_install() {
    local distro
    local machtype
    declare -a mirror_url
    declare -a ip_info

    if [ $(whoami) != root ];then
        echo "${FUNCNAME[0]} need root privilege" >2
        return 1;
    fi
    distro=$(cat /etc/issue | cut -f 2 | xargs)
    machtype=$(uname -m)
    # TODO: support any machine
    if [ $machtype -ne x86_64 ]; then
        echo "${FUNCNAME[0]} only support x86_64 machine" >2
        return 1
    fi
    # ip info format
    # ip    cn_code country province    city    latitude    longtigude
    # TODO: alternative json parse
    read -r -a ip_info <<< "$(curl -s -m2 https://api.myip.la/en?toml)"
    if (( ${#ip_info[@]} < 6 )) then
        echo "${FUNCNAME[0]} get ip info fail" >2
        return 1
    fi
    
    # TODO: nearby mirrors selection
    if [ ${ip_info[2]} -e "CN" ]; then
        case $distro in
            Debian)
                mv /etc/apt/source.list /etc/apt/source.list.bak
                cp etc/apt/tencent.debian.list /etc/apt/source.list
                ;;
            Ubuntu)
                mv /etc/apt/source.list /etc/apt/source.list.bak
                cp etc/apt/tencent.ubuntu.list /etc/apt/source.list
                ;;
            Arch)
                ;;
            *)
                echo "unsupport distro, please change package source manuall" >2
                ;;
        esac
    fi

    # ubuntu borrow package from debian unstable
    if [ $distro -e Ubuntu ];then
        apt install add-apt-key
        cat <<- EOF >>/etc/apt/source.list
        deb https://mirrors.cloud.tencent.com/debian/ unstable main contrib non-free
        deb-src https://mirrors.cloud.tencent.com/debian/ unstable main contrib non-free
        EOF
        wget -O - https://ftp-master.debian.org/keys/archieve-key-10.asc | sudo apt-key add -
    fi
        
    case $distro in
        Debain|Ubuntu)
            apt-get update
            while read pkg; do
                apt install -y $pkg
            done < depedency.txt
            ;;
        Arch)
            # FIXME: pacman use different pkg name
            pacman -Syu
            while read pkg; do
                pacman -Sy $pkg
            done < depedency.txt
            ;;
    esac
}

infect() {
    pushd $(dirname "{$BASH_SOURCE[0]}")
    pushd $(git rev-parse --show-toplevel)
    git submodule init
    git submodule update
    popd
    command_install
    bash_setup
    git_setup
    vim_setup
    tmux_setup
    popd
}
