#!/bin/bash
source ~/secret-keys
v4lctl setinput s-video
v4lctl setnorm ntsc
ffmpeg -f v4l2 -video_size 640x480 -framerate 29.97 -thread_queue_size 50k -i /dev/video0 -thread_queue_size 50k -f jack -i ffmpeg -ac 2 -c:a aac -b:a 160k -ar 44100 -vcodec libx264 -preset veryfast -pix_fmt yuv420p  -profile:v high -level 4.0 -g 59.94  -b:v 1800k -minrate 1800k -maxrate 1800k -bufsize 1800k -vf "yadif,crop=w=570:h=440:x=28" -f flv "rtmp://${TWITCH_STREAM_URL_IOTKU}"
