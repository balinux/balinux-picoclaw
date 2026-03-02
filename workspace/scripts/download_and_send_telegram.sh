#!/bin/bash

# Script untuk download video dari Instagram dan kirim ke Telegram
# Usage: ./download_and_send_telegram.sh <instagram_url> <chat_id> [filename]

TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
INSTAGRAM_URL="$1"
CHAT_ID="$2"
FILENAME="${3:-video_$(date +%Y%m%d_%H%M%S).mp4}"

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$INSTAGRAM_URL" ] || [ -z "$CHAT_ID" ]; then
    echo "Usage: $0 <instagram_url> <chat_id> [filename]"
    echo "Make sure TELEGRAM_BOT_TOKEN environment variable is set"
    exit 1
fi

echo "Downloading video from Instagram..."
yt-dlp -o "$FILENAME" "$INSTAGRAM_URL"

if [ $? -eq 0 ]; then
    echo "Download completed: $FILENAME"
    
    echo "Sending to Telegram..."
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument" \
        -F "chat_id=$CHAT_ID" \
        -F "document=@$FILENAME" \
        -F "caption=Instagram video downloaded via yt-dlp"
    
    if [ $? -eq 0 ]; then
        echo "File sent to Telegram successfully!"
        # Optional: hapus file setelah dikirim
        # rm "$FILENAME"
    else
        echo "Failed to send file to Telegram"
        exit 1
    fi
else
    echo "Download failed"
    exit 1
fi