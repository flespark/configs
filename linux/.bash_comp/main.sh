#!/bin/bash                                                                                                                                                                                                                                

cwd="$(dirname "${BASH_SOURCE[0]}")"

# bash autocompletion script example
dc(){
        local param last_path path="$PWD"
        if [[ ($# != 1) || ("$1" =~ ^((-h)|(--help))$) ]]; then
                echo -e "usage:
                \rdc -[1-9] to Nth parent dir
                \rdc basedir to matched parent dir" >&2
                return 2
        elif [[ ("$1" =~ ^[0-9]+$) ]]; then
                param=$(($1))
                while ((param-- > 0)); do
                        path="${path%/*}" 2>/dev/null || break
                done
                cd "$path" || return 1
        else
                while [[ $last_path != "$path" ]]; do
                        [[ $(basename "$path" 2>/dev/null) == "$1" ]] && cd "$path" && return 0
                        last_path=$path
                        path="${path%/*}"
                done
                echo "dc: can't match parent dir $1" >&2
                return 1;
        fi
        return
}

_dc(){
	local opts
	if (( ${#COMP_WORDS[@]} > 2 )); then
		return
	fi
	local IFS=$'\n'
	opts="$( tr '/' '\n' <<<"$PWD" | tac )"
	# shellcheck disable=2207
	COMPREPLY=($(compgen -W "${opts}" -- "${COMP_WORDS[1]}"))
}

complete -F _dc dc

if type -P fzf >/dev/null; then
	. ${cwd}/fzf.sh
fi

if type -P rg >/dev/null; then
	. ${cwd}/rg.sh
fi

if type -P fd >/dev/null; then
	. ${cwd}/fd.sh
fi

if type -P hugo >/dev/null; then
	. ${cwd}/hugo.sh
fi
