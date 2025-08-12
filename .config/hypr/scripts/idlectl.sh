#!/bin/sh

print_help() {
    local prog_name=$(basename "$0")

    cat <<EOF
usage: $prog_name [level]
Manages stages of screen idle process.

    level: an integer in the range [0, 4], with 0 representing the default state.
EOF
}

case "$1" in
    0)
        hyprctl dispatch dpms on
        brightnessctl -r
        ;;
    1)
        brightnessctl -s
        brightnessctl s $(($(brightnessctl g)*3/4))
        ;;
    2)
        brightnessctl s $(($(brightnessctl g)/3))
        ;;
    3)
        hyprctl dispatch dpms off &
        loginctl lock-session
        ;;
    4)
        systemctl suspend
        ;;
    *)
        print_help
        exit 1
        ;;
esac
