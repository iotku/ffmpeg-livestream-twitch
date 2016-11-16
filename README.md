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
- lots of past duration errors which may not actually mean anything

#Why I'm not using obs
I'm currently on a system which doesn't have a gpu that supports OBS (old integrated intel graphics)
