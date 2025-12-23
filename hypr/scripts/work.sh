#!/usr/bin/env bash

nohup teams-for-linux >/dev/null 2>&1 &

nohup /opt/outlook-for-linux/outlook-for-linux >/dev/null 2>&1 &

hyprctl dispatch workspace 2
sleep 0.1
brave --disable-gpu --disable-features=VaapiVideoDecoder --password-store=basic --profile-directory="Profile 1" --new-window &

hyprctl dispatch exec '[workspace 10 silent] kitty -e "${SHELL:-/bin/bash}" -ic "vpn"'
