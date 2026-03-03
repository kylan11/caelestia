#!/usr/bin/env bash

# Teams and Thunderbird → special workspaces (pinned to DP-3)
hyprctl dispatch exec '[workspace special:teams silent] teams-for-linux'
hyprctl dispatch exec '[workspace special:email silent] thunderbird'

# Brave work profile → monitor 1, workspace 2
hyprctl dispatch focusmonitor DP-1
hyprctl dispatch split-workspace 2
sleep 0.1
brave --disable-gpu --disable-features=VaapiVideoDecoder --password-store=basic --profile-directory="Profile 1" --new-window &

# VPN → monitor 2, workspace 10 (key "0")
hyprctl dispatch focusmonitor DP-3
hyprctl dispatch split-workspace 10
sleep 0.1
hyprctl dispatch exec 'foot fish -c "sudo -n /usr/bin/openvpn --config /home/kylan11/francesco.lauritano-dbridge-root-vpn.ovpn"'
