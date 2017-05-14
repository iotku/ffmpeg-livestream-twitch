#!/bin/bash
source ~/secret-keys # Has variables for stream urls/stream keys
source ./screencast-settings
# Options
AUDIO_DELAY="470" # in ms
AUDIO_BITRATE="160k"
VIDEO_BITRATE="1550k"
X264_PRESET="faster"
SPLIT_SIZEW=300
SPLIT_SIZEH=580
STREAM_H=448
STREAM_W=786
CALC_SPLIT_H=$(awk '{printf("%.0f", ($1/$2) * 200)}' <<<" $SPLIT_SIZEH $SPLIT_SIZEW ")

if [ $CALC_SPLIT_H -gt $STREAM_H ]; then
    CALC_SPLIT_H=$STREAM_H
fi

v4lctl setinput s-video
v4lctl setnorm ntsc
ffmpeg -f v4l2 -video_size 640x480 -framerate 29.97 -thread_queue_size 50k -i /dev/video0 -thread_queue_size 50k \
    -f x11grab -video_size ${SPLIT_SIZEW}x${SPLIT_SIZEH} -framerate 29.97 -draw_mouse 0 -show_region 1 -i :0.0+1247,132 \
    -f jack -i ffmpeg -ac 2 -c:a libfdk_aac -b:a $AUDIO_BITRATE -ar 44100 -vcodec libx264 -preset $X264_PRESET -pix_fmt yuv420p -profile:v high -level 4.0 -g 59.94 \
    -b:v $VIDEO_BITRATE -minrate $VIDEO_BITRATE -maxrate $VIDEO_BITRATE -bufsize $VIDEO_BITRATE -vsync 1 \
    -filter_complex "[0:v]bwdif[deint];[deint]crop=w=570:h=448:x=32[deint];[1:v]scale=220:${CALC_SPLIT_H}[splits];[splits]pad=${STREAM_W}:${STREAM_H}[splits];[splits][deint]overlay=220:0[vid];[2:a]adelay=${AUDIO_DELAY}|${AUDIO_DELAY}[daudio]"\
    -map [vid] -map [daudio] \
    480poutput.mkv
    #-f flv "rtmp://${RESTREAM_URL_IOTKU}"
 #   -f flv "rtmp://${TWITCH_STREAM_URL_IOTKU}"

