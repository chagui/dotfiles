
if [ -e ~/.local/bin ]; then
    export PATH="${PATH}:~/.local/bin"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [[ -e /usr/lib/git-core/git-sh-prompt ]]; then
    . /usr/lib/git-core/git-sh-prompt
    function set_prompt {
        local -r last_cmd=$?
        local -r reset='$(tput sgr0)'
        local -r bold='$(tput bold)'
        local -r red='$(tput setaf 1)'
        local -r green='$(tput setaf 2)'
        local -r yellow='$(tput setaf 3)'
        local -r blue='$(tput setaf 4)'
        local -r white='$(tput setaf 7)'
        # unicode "✗"
        local -r fancyx='\342\234\227'
        # unicode "✓"
        local -r checkmark='\342\234\223'

        # cwd
        PS1="\[$bold\]\[$blue\]\w\[$reset\]"

        # python
        if [[ -n ${VIRTUAL_ENV} ]]; then
            local -r prefix="(`basename "${VIRTUAL_ENV}"`)"
            PS1="${prefix}${PS1:-}"
        fi

        # git
        PS1+="\[$yellow\]$(__git_ps1)\[$white\]"
        GIT_PS1_SHOWDIRTYSTATE=true
        GIT_PS1_SHOWUPSTREAM=true

        # last command results
        if ((last_cmd == 0)); then
            PS1+="\[$green\]$checkmark\[$reset\] "
        else
            PS1+="\[$red\]$fancyx \[$white\]($last_cmd)\[$reset\] "
        fi
    }
    PROMPT_COMMAND='set_prompt'
fi

if hash go &>/dev/null; then
    export GOPATH="${HOME}/go"
    export PATH="${PATH}:${GOPATH}/bin"
fi

if hash bat &>/dev/null; then
    export BAT_THEME=1337
fi
export PYTHON_ENVS="${HOME}/Work/python_envs"

#### tune history ####
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

function share_history {
    # remember everything from every terminal on the machine while having that history accessible from every terminal
    # shout-out to https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
    export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
}

#### functions ####
function git_clone {
    local -r repos="$1"
    pushd ~/Work/github.com
    git clone git@github.com:${repos} ${repos}
    pushd ${repos}
}

function venv {
    local -r env="${PYTHON_ENVS}/${1}/bin/activate"
    if [[ -f ${env} ]]; then
        source "${env}"
    else
        >&2 echo "error: '$1' is not a valid virtual environment"
    fi
}

function github {
    firefox https://github.com/$1
}

function tgz_compress {
    tar cvf - $1 | gzip > $2
}

function mkd {
    mkdir -p $1 && cd $_
}

# get IP address for the given container and network
function get_container_network_ip {
    local -r container_name="${1}"
    local -r network_name="${2}"
    docker inspect "${container_name}" | jq -r ".[0].NetworkSettings.Networks.${network_name}.IPAddress"
}

if [ -f ~/.aliases ]; then
        . ~/.aliases
fi

