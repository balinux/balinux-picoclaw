#!/bin/bash
# Script sederhana untuk download video dari social media
# Usage: ./download_video_simple.sh <url> <output_path>

URL="$1"
OUTPUT_PATH="$2"

if [ -z "$URL" ] || [ -z "$OUTPUT_PATH" ]; then
    echo "Usage: $0 <url> <output_path>"
    exit 1
fi

# Buat direktori output jika belum ada
mkdir -p "$(dirname "$OUTPUT_PATH")"

echo "Downloading from: $URL"
echo "Output to: $OUTPUT_PATH"

# Deteksi platform dari URL
if [[ "$URL" =~ youtube\.com/shorts ]] || [[ "$URL" =~ youtu\.be/.*t= ]] || [[ "$URL" =~ youtube\.com/watch\?.*t= ]]; then
    # Ini adalah YouTube Shorts atau video YouTube dengan timestamp
    echo "Detected YouTube Shorts/Video"
    if yt-dlp -o "$OUTPUT_PATH" --merge-output-format mp4 --recode-video mp4 "$URL"; then
        if [ -f "$OUTPUT_PATH" ]; then
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        else
            echo "Download failed - file not created"
            exit 1
        fi
    else
        echo "Download failed"
        exit 1
    fi
elif [[ "$URL" =~ instagram\.com ]]; then
    # Untuk Instagram
    echo "Detected Instagram"
    if yt-dlp -o "$OUTPUT_PATH" --merge-output-format mp4 --recode-video mp4 "$URL"; then
        if [ -f "$OUTPUT_PATH" ]; then
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        else
            echo "Download failed - file not created"
            exit 1
        fi
    else
        echo "Download failed"
        exit 1
    fi
else
    # Platform lainnya
    echo "Detected other platform"
    if yt-dlp -o "$OUTPUT_PATH" --merge-output-format mp4 --recode-video mp4 "$URL"; then
        if [ -f "$OUTPUT_PATH" ]; then
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        else
            echo "Download failed - file not created"
            exit 1
        fi
    else
        echo "Download failed"
        exit 1
    fi
fi