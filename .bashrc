#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Allow dotfiles to be caught in glob
shopt -s dotglob

# We like color
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias lg='lazygit'

# Default PS1 if not using other prompt applications
PS1='[\u@\h \W]\$ '

# Of course
export EDITOR=nvim

if [[ "$TERM" == "xterm-kitty" ]]; then
    eval "$(starship init bash)"
    eval "$(zoxide init bash)"

    echo && pfetch | lolcat -F 0.08
fi

# Yazi remap
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Bash completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
