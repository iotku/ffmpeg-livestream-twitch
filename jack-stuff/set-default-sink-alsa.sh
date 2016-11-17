#!/bin/bash
SINK=$(pacmd list-sinks | grep \<alsa_output.pci-0000_00_1b.0.analog-stereo\> -B 1 | grep index | cut -c 12-)

pacmd set-default-sink $SINK

pactl list short sink-inputs|while read inputs; do
    pulse_client_id=$(echo $inputs|cut '-d ' -f1)
        pactl move-sink-input "$pulse_client_id" $SINK
done
