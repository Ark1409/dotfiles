#!/usr/bin/env bash

update_count=$(checkupdates --nocolor | wc -l)

if [[ $update_count == 0 ]]; then
    cat <<< '{"text": "", "alt": "", "tooltip": "", "class": "", "percentage": 0 }'
    exit 0
fi

cat <<EOF
{"text": "$update_count", "alt": "", "tooltip": "$update_count pending package(s)", "class": "", "percentage": 100 }
EOF
