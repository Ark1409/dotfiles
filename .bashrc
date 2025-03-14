#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Allow dotfiles to be caught in glob
shopt -s dotglob

# YES
set -o vi

# We like color
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias xxdc='xxd -R always'

alias lg='lazygit'
alias ff='fastfetch'
alias fzf="fzf --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
alias yf='yayfzf'
alias clock='tty-clock -cstB -C 4'

# yay alias to update waybar module
yay() {
    command yay "$@"
    local _ret=$?
    killall -35 waybar &> /dev/null
    return $_ret
}

# Yazi remap
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Default PS1 if not using other prompt applications
PS1='[\u@\h \W]\$ '

# Of course
export EDITOR=nvim

if [[ "$TERM" =~ ^xterm- ]]; then
    eval "$(starship init bash)"
    eval "$(zoxide init bash)"
    eval "$(fzf --bash)"

    export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

    alias fzf="fzf --preview '(highlight -O xterm256 {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

    echo && pfetch | lolcat -F 0.07
fi

# Bash completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion
