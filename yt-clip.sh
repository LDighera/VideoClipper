#!/bin/bash
# This script will download YouTube video clips
# LGD Sun Feb 18 12:41:28 PM PST 2024

# USAGE
  if [[ $1 == "--help" ]]; then
    # echo -e "\n\tUsage: $0 <video-url> <start-point hh:mm:ss> <end-point hh:mm:ss> <output-directory> <output-file-name>" >&2	# youtube-downloader
    echo -e "\n\tUsage: $0 <video-url> <start-point hh:mm:ss> <end-point hh:mm:ss> <output-directory> <output-file-name>\n" >&2	# yt-dlp
    exit
  fi

echo -e "\n\n\tTest Data: URL: https://youtu.be/wzoJy26tIAI\tStart: 00:07:56\t\tEnd: 00:08:12\tDIR: /home/larry/Videos\tFile Name:  FaniWillisNotOnTrial.mp4\n"
#
    if [[ $# != 5 ]]; then                                    # EDIT: Add more through error checking with awk and test
    echo -e "\n\tUsage: $0 <video-url> <start-point hh:mm:ss> <end-point hh:mm:ss> <output-directory> <output-file-name>\n" >&2		# yt-dlp
    # Prompt user for video URL
    read -r -p "Enter the video URL: " URL
    # Prompt user for video start point in HH:MM:SS format  # EDIT: Add format validation parsing with awk, test
    read -r -p "Enter the video start point in HH:MM:SS format (Enter = 00:00:00): " SHHMMSS
    # Prompt user for video end point in HH:MM:SS format    # EDIT: Add format validation parsing with awk, test
    read -r -p "Enter the video end point in HH:MM:SS format: " EHHMMSS
    # Prompt user for output folder
    read -r -p "Enter the output folder: " OUTPUT_FOLDER
    # Prompt user for the desired filename
    read -r -p "Enter the desired filename (without extension): " FILENAME
else	# Parse command argument parameters
    echo -e "\n\tUsage: $0 <video-url> <start-point hh:mm:ss> <end-point hh:mm:ss> <output-directory> <output-file-name>\n" >&2    # Display syntax for yt-dlp
    # Evaluate  video URL from command line argument
    URL="$1"
    # Evaluate start-point from command line argument
    START_TIME_FORMATTED="$2"
    # Evaluate end-point from command line argument
    END_TIME_FORMATTED="$3"
    # Evaluate  output folder from command line argument
    OUTPUT_FOLDER="$(echo "$4" | sed 's|[/\/*]*$||g')"    # Remove any trailing / characters from output folder path
    # Evaluate  desired filename from command line argument
    FILENAME="$(echo "$5" | sed 's|[/\/*]*$||g')"        # Remove any trailing / characters from filename
fi

# Download the specified clip
yt-dlp  --ignore-errors --ffmpeg-location /usr/bin/ffmpeg -f mp4 -o "$OUTPUT_FOLDER/$FILENAME.%(ext)s" --postprocessor-args "-ss $SHHMMSS -to $EHHMMSS" "$URL"
exit $?
