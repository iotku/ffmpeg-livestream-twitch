#!/bin/bash
wininfo=$(xwininfo)
width=$(echo "$wininfo" | grep Width  | cut -c 10-)
height=$(echo "$wininfo" | grep Height | cut -c 11-)
posx=$(echo "$wininfo" | grep "Absolute upper-left X" | cut -c 27-)
posy=$(echo "$wininfo" | grep "Absolute upper-left Y" | cut -c 27-)

echo SCREENCAP_AREA=\"${posx},${posy}\" > screencast-settings
echo SCREENCAP_SIZE=\"${width}x${height}\" >> screencast-settings
