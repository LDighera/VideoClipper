#!/bin/ksh
# ff-size-target.sh			This script accepts input-file-name and output-file-size command line arguments
# LGD Fri Apr 19 11:59:49 AM PDT 2024
# Source: https://unix.stackexchange.com/questions/520597/how-to-reduce-the-size-of-a-video-to-a-target-size
#

# set -xv			# DEBUG
test $# -lt 2 && { echo -e "\n\tUsage: $0 <file-name> <size in MB>\n" >&2; exit 1 ; }		# USAGE

FFMPEG_RESIZE () {
    FILE=$1											# File Name on command line
    TARGET_SIZE_MB=$2										# target size in MB on command line
    TARGET_SIZE=$(( $TARGET_SIZE_MB * 1000 * 1000 * 8 ))					# target size in bits
    LENGTH=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FILE"`
    LENGTH_ROUND_UP=$(( ${LENGTH%.*} + 1 ))
    TOTAL_BITRATE=$(( $TARGET_SIZE / $LENGTH_ROUND_UP ))
    AUDIO_BITRATE=$(( 128 * 1000 )) # 128k bit rate
    VIDEO_BITRATE=$(( $TOTAL_BITRATE - $AUDIO_BITRATE ))
    ffmpeg -i "$FILE" -b:v $VIDEO_BITRATE -maxrate:v $VIDEO_BITRATE -bufsize:v $(( $TARGET_SIZE / 20 )) -b:a $AUDIO_BITRATE "${FILE}-${TARGET_SIZE_MB}mb.mp4"
}

FFMPEG_RESIZE  $*

