#!/bin/bash
source ~/secret-keys
	ffmpeg -video_size 1280x720 -framerate 20 -f x11grab -show_region 1 -i :0.0+1922,34  -f jack -i ffmpeg -vcodec libx264 -preset veryfast -pix_fmt yuv420p  -profile:v high -level 4.0 -g 60  -b:v 1800k -minrate 1800k -maxrate 1800k -bufsize 1800k -c:a aac -b:a 160k -ar 44100 test.mp4 #-f flv "rtmp://${TWITCH_STREAM_URL_IOTKU}"
# -f pulse -ac 2 -i default 
# -filter:v scale=1024:576 -sws_flags lanczos
