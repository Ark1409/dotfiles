#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Allow dotfiles to be caught in glob
shopt -s dotglob

# Allow **
shopt -s globstar

# YES
set -o vi

# We like color
alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias lg='lazygit'
alias ff='fastfetch'
alias fzf="fzf --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
alias yf='yayfzf'
alias clock='tty-clock -cstB -C 4'
alias t='tmux'
alias ta='tmux a'
alias nv='nvim'
alias mktmpcd='cd $(mktemp -dp "/tmp")'
alias mkeditmp='mkedittmp'


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
export PAGER="nvimpager -a"
export EDITOR=nvim

if [[ "$TERM" =~ ^xterm- || "$TERM" =~ ^tmux- ]]; then
    eval "$(starship init bash)"

    if [[ $TERM == "xterm-kitty" ]]; then
        alias fzf="fzf --preview '(highlight -O truecolor {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    else
        alias fzf="fzf --preview '(highlight -O xterm256 {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    fi

    echo && pfetch | lolcat -F 0.07
elif [[ $TERM == linux ]]; then
    :;
    # BASE16_SHELL="$HOME/.config/base16-shell"
    # [ -n "$PS1" ] && \
    #     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    #         source "$BASE16_SHELL/profile_helper.sh"
fi

eval "$(fzf --bash)"
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

eval "$(zoxide init bash)"

# Bash completion
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion


zipedit() {
    (( $# != 1 )) && echo "$(tput sgr0)usage: zipedit $(tput smul)ZIPFILE$(tput rmul)" 2>&1 && return 1

    [[ -f "$1" ]] || { echo "error: file '$1' does not exist" 2>&1; return 1; }

    local zipedit_dir=$(mktemp -d 'zipedit.tmp.XXXXXXXXXX' -p '/tmp')
    unzip "$1" -d "$zipedit_dir"
    touch "$1"

    local old_pwd=$PWD
    cd "$zipedit_dir"

    "$EDITOR" .

    local zipedit_link=$(mktemp 'zipedit.tmp.zip.XXXXXXXXXX' -p "$zipedit_dir")
    cd "$old_pwd"
    ln -sf "$(realpath "$1")" "$zipedit_link"

    cd "$zipedit_dir"
    zip --filesync -r "$zipedit_link" .

    cd "$old_pwd"

    rm -r "$zipedit_dir"
}

mkdircd() { (( $# != 1 )) && { echo -e 'usage: mkcd DIRNAME\n\tCreates a directory and changes into it.\n\tNo options are available.' 2>&1; return 1; }; mkdir -p "$1" && cd "$1"; }
alias mkcd='mkdircd'
mkfile() { (( $# != 1 )) && { echo -e 'usage: mkfile FILENAME\n\tCreates a file as well as its parent directories.\n\tNo options are available.' 2>&1; return 1; }; mkdir -p "$(dirname $1)"; touch "$1"; }
mkedit() { (( $# != 1 )) && { echo -e 'usage: mkedit FILENAME\n\tCreates a file and starts editing it.\n\tNo options are available.' 2>&1; return 1; }; mkfile "$@" && "$EDITOR" "$@"; }
mkedittmp() { local tmp_file="$(mktemp)"; "$EDITOR" "$tmp_file"; echo "$tmp_file"; }
