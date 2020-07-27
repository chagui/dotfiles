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

export PYTHON_ENVS="${HOME}/Work/python_envs"

#### tune history ####
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

function share_history {
    # remember everything from every terminal on the machine while having that history accessible from every terminal
    # shout-out to https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
    export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
}

#### alias ####
# beautifiers
alias ccat='pygmentize'

# move around
alias cdw='cd ~/Work'
alias cdr="cd ~/Work/github.com"
alias goplay='cd ~/Work/playground'
alias gotmp='cd /tmp'

# search
alias rgcpp='rg -tcpp'
alias rgcmake='rg -tcmake'
alias rgtext='rg -ttxt'
alias rgconf='rg -tconfig -tyaml -tjson -txml'
alias rgsh='rg -tsh'
alias rgpy='rg -tpy'

# git
alias gs='git status -s'
alias ga='git add'
alias gbr='git branch'
complete -F _complete_alias gbr
alias gc='git c'
complete -F _complete_alias gc
alias gcm='git cm'
complete -F _complete_alias gcm
alias gacm='git cam'
complete -F _complete_alias gcam
alias gpatch='git commit --amend'
alias gfixup='git commit --amend --no-edit'
alias gp='git push'
complete -F _complete_alias gp
alias gr='git rebase'
complete -F _complete_alias gr
alias gd='git diff'
complete -F _complete_alias gd
alias gdt='git difftool'
complete -F _complete_alias gdt
alias gco='git checkout'
complete -F _complete_alias gco
alias gcp='git cherry-pick'
complete -F _complete_alias gcp
alias gtree='git tree'
alias clone='git_clone'

# docker
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcb='docker-compose up -d --build'
alias dstats='docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"'
alias dports='docker ps --format "table {{.Names}}\t{{.Ports}}"'
alias garbage-collect-docker='docker rm $(docker ps -aq)'
alias dl='docker logs -ft'
complete -F _complete_alias dl
alias dps='docker ps'
alias dimgs='docker images'
complete -F _complete_alias dimgs
alias dvol='docker volume'
complete -F _complete_alias dvol
alias dnet='docker network'
complete -F _complete_alias dnet
alias dsys='docker system'
complete -F _complete_alias dsys

# misc
alias apti='sudo apt install'
complete -F _complete_alias apti
alias aptu='sudo apt update && sudo apt upgrade -y'
alias snapi='sudo snap install'
complete -F _complete_alias snapi
if [ -e ~/.local/bin/exa ]; then
    alias ls='exa'
    alias l='ls -F'
fi
alias root='sudo su - root'

# ascii art
alias no-idea='echo "¯\_(ツ)_/¯"'


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

