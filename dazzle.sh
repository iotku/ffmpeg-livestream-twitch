#!/bin/bash
source ~/secret-keys
source ./screencast-settings
v4lctl setinput s-video
v4lctl setnorm ntsc
ffmpeg -f v4l2 -video_size 640x480 -framerate 29.97 -thread_queue_size 50k -i /dev/video0 -thread_queue_size 50k \
    -f x11grab -video_size 296x430 -framerate 29.97 -show_region 1 -i :0.0+1538,122 \
    -f jack -i ffmpeg -ac 2 -c:a aac -b:a 160k -ar 44100 -vcodec libx264 -preset veryfast -pix_fmt yuv420p  -profile:v high -level 4.0 -g 59.94 \
    -b:v 1500k -minrate 1500k -maxrate 1500k -bufsize 1500k -vsync 1 \
    -filter_complex "[0:v]bwdif[deint];[deint]crop=w=570:h=448:x=28[deint];[1:v]scale=220:448[splits];[splits]pad=786:448[splits];[splits][deint]overlay=220:0[vid]"\
    -map [vid] -map 2:a\
    out.mkv

