#!/bin/sh

mkfile() {
    mkdir -p "$(dirname "$1")" || return
    [ -f "$1" ] || touch "$1"
}

mkfile /tmp/hypr/hyprclose.log

# Close a few times for any confirmation messages
for i in "$(seq 1 3)"; do
    HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
    hyprctl --batch "$HYPRCMDS" > /tmp/hypr/hyprclose.log 2>&1
done

systemctl --user stop hyprpolkitagent
systemctl --user stop swaync

sleep 0.25 && hyprctl dispatch exit
