#!/usr/bin/env bash

update_output=$(checkupdates --nocolor)
update_count=$(wc -l <<< "$update_output")
update_packages=$(sed 's/ .*//g' <<< "$update_output")

if [[ $update_count == 0 ]]; then
    cat <<< '{"text": "", "alt": "", "tooltip": "", "class": "", "percentage": 0 }'
    exit 0
fi

tooltip=""

if [[ $update_count == 1 ]]; then
    tooltip="$update_count pending package"
else
    tooltip="$update_count pending packages"
fi

tooltip+="\n\n$update_packages"

cat <<EOF
{"text": "$update_count", "alt": "", "tooltip": "$tooltip", "class": "", "percentage": 100 }
EOF
