#Software used
- FFmpeg (Streaming/Screen Capture)
    - x11grab for screen capture
    - libx264 for h264 encoding
    - built in ffmpeg aac encoder, should change to fdk at some point

- Jack Audio
    - qjackctl to set up routing/patchbay and launch jack
    - pulseaudio sink -> jack audio for general non-jack audio sources
    - Non-mixer for handling and monitoring audio levels + ladspa effects on microphone


#Known issues
- x11grab isn't incredibly light on resources, especially if capturing opengl windows
- things going fullscreen (and changing resolutions) will probably destroy everything
- lots of past duration errors which [may not actually mean anything](https://stackoverflow.com/questions/30782771/what-does-past-duration-x-xxx-too-large-mean)

#Why I'm not using obs
I'm currently on a system which doesn't have a gpu that supports OBS (old integrated intel graphics)

#How I do it....

## Audio
JACK is the main force behind audio routing and qjackctl is used as an easy method way to start/configure JACK.

Qjackctl is setup to launch jack2 (w/ dbus interface) which tells pulseaudio (with jack plugin installed) 
to create a jack sink, the additional startup scripts (in /jack-stuff) switch the default pulseaudio sink to the JACK sink
and switch current clients over so I don't have to do it manually.

Before going to FFmpeg's jack input everything is routed into Non-mixer so I can control volume levels (and add ladspa effects to my microphone)
and then routed out from there to FFmpeg.

Qjackctl's patchbay remembers the connections used and automatically applies them.

## Video
Video is currently very basic and unflexable, I can select a window in order to capture a specific area of my desktop, 
however after it is set it can not be modified nor does it follow changing window position.

My Dazzle is cropped and deinterlaced, however the yandif interlacing seems to be not perfect for N64 material and sometimes the color seems to get desynced with the rest of the image.

TODO: Figure out how to properly use overlay so I can have splits + a video source, espcially for Dazzle
