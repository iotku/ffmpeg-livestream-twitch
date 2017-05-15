#!/bin/bash
source ~/secret-keys # Has variables for stream urls/stream keys
source ./screencast-settings
# Options
AUDIO_DELAY="470" # in ms
AUDIO_BITRATE="128k"
VIDEO_BITRATE="1600k"
X264_PRESET="faster"
CROP_W="570"
CROP_H="448"
CROP_X="32"
CROP_Y="16"
SPLIT_SIZEW=300
SPLIT_SIZEH=580
STREAM_W=854
STREAM_H=480
# math stuff
CALC_CAP_W=$(awk '{printf("%.0f", ($1/$2) * $3)}' <<<" $CROP_W $CROP_H $STREAM_H ") # Orig w / Orig h  * new h = new w
WIDTH_LEFT=$(expr $STREAM_W - $CALC_CAP_W)
CALC_SPLIT_H=$(awk '{printf("%.0f", ($1/$2) * $3)}' <<<" $SPLIT_SIZEH $SPLIT_SIZEW $WIDTH_LEFT ")

if [ $CALC_SPLIT_H -gt $STREAM_H ]; then
    CALC_SPLIT_H=$STREAM_H
fi

v4lctl setinput s-video
v4lctl setnorm ntsc
ffmpeg -f v4l2 -video_size 640x480 -framerate 29.97 -thread_queue_size 50k -i /dev/video0 -thread_queue_size 50k \
    -f x11grab -video_size ${SPLIT_SIZEW}x${SPLIT_SIZEH} -framerate 29.97 -draw_mouse 0 -show_region 1 -i :0.0+1247,132 -thread_queue_size 50k \
    -f jack -i ffmpeg -ac 2 -c:a libfdk_aac -b:a $AUDIO_BITRATE -ar 44100 -vcodec libx264 -preset $X264_PRESET -pix_fmt yuv420p -profile:v high -level 4.0 -g 59.94 \
    -b:v $VIDEO_BITRATE -minrate $VIDEO_BITRATE -maxrate $VIDEO_BITRATE -bufsize $VIDEO_BITRATE -vsync 1 \
    -filter_complex "[0:v]yadif=3:0[deint];[deint]crop=w=${CROP_W}:h=${CROP_H}:x=${CROP_X}:y=${CROP_Y}[deint];[deint]scale=${CALC_CAP_W}:${STREAM_H}[deint];[1:v]scale=${WIDTH_LEFT}:${CALC_SPLIT_H}[splits];[splits]pad=${STREAM_W}:${STREAM_H}[splits];[splits][deint]overlay=${WIDTH_LEFT}:0[vid];[2:a]adelay=${AUDIO_DELAY}|${AUDIO_DELAY}[daudio]"\
    -map [vid] -map [daudio] \
    -f flv "rtmp://${RESTREAM_URL_IOTKU}"
 #   -f flv "rtmp://${TWITCH_STREAM_URL_IOTKU}"

