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

}

infect() {

for dotfile in ls;do
done

}
