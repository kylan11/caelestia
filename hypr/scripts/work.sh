#!/usr/bin/env bash

hyprctl dispatch exec '[workspace special:teams silent] teams-for-linux'
hyprctl dispatch exec '[workspace special:email silent] thunderbird'

hyprctl dispatch focusmonitor DP-1
hyprctl dispatch workspace 2
sleep 0.1
hyprctl dispatch exec 'brave --disable-gpu --disable-features=VaapiVideoDecoder --password-store=basic --profile-directory="Profile 1" --new-window'

hyprctl dispatch focusmonitor DP-3
hyprctl dispatch workspace 20
sleep 0.1
hyprctl dispatch exec 'foot fish -c "sudo -n /usr/bin/openvpn --config /home/kylan11/francesco.lauritano-dbridge-root-vpn.ovpn"'
