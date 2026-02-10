#!/usr/bin/env bash

hyprctl dispatch exec '[workspace special:teams silent] teams-for-linux'

hyprctl dispatch exec '[workspace special:email silent] thunderbird'

hyprctl dispatch workspace 2
sleep 0.1
brave --disable-gpu --disable-features=VaapiVideoDecoder --password-store=basic --profile-directory="Profile 1" --new-window &

hyprctl dispatch exec '[workspace 10 silent] kitty -e "${SHELL:-/bin/bash}" -ic "vpn"'
