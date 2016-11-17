#!/bin/bash
source ~/secret-keys
source ./screencast-settings
echo ${SCREENCAP_AREA}
ffmpeg -video_size $SCREENCAP_SIZE -framerate 30 -thread_queue_size 50k -f x11grab -show_region 1 -i :0.0+${SCREENCAP_AREA}   -thread_queue_size 50k -f jack -threads 2 -i ffmpeg -vcodec libx264 -preset veryfast -pix_fmt yuv420p  -profile:v high -level 4.0 -g 60  -b:v 1800k -minrate 1800k -maxrate 1800k -bufsize 1800k -c:a aac -b:a 160k -ar 44100 -filter:v scale=1024:576 -sws_flags bicubic -f flv "rtmp://${TWITCH_STREAM_URL_IOTKU}"
# -f pulse -ac 2 -i default 
# -filter:v scale=1024:576 -sws_flags lanczos
# -sws_flags fast_bilinear
