#!/usr/bin/env bash

HEADSET_SINK="alsa_output.usb-Logitech_G_series_G435_Wireless_Gaming_Headset_202105190004-00.analog-stereo"
ANALOG_SINK="alsa_output.pci-0000_69_00.6.analog-stereo"

# Get the current default sink
default_sink=$(pactl info | grep 'Default Sink:' | awk '{print $3}')

# Determine which sink to switch to
if [ "$default_sink" = "$HEADSET_SINK" ]; then
    next_sink="$ANALOG_SINK"
else
    next_sink="$HEADSET_SINK"
fi

# Set the new default sink
pactl set-default-sink "$next_sink"

# Move all active streams to the new sink
for input in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$input" "$next_sink"
done

