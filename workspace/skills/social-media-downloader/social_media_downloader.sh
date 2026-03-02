#!/bin/bash
# Main script untuk social media downloader skill (fixed version with multi-channel support)
# Usage: ./social_media_downloader_fixed.sh <url> <chat_id>

URL="$1"
CHAT_ID="$2"

if [ -z "$URL" ] || [ -z "$CHAT_ID" ]; then
    echo "Usage: $0 <url> <chat_id>"
    exit 1
fi

echo "DEBUG: Processing download request"
echo "DEBUG: URL: $URL"
echo "DEBUG: Target Chat ID: $CHAT_ID"
if [ "$CHAT_ID" = "207853653" ]; then
    echo "DEBUG: This is a private chat request"
elif [[ "$CHAT_ID" =~ ^-[0-9]+$ ]]; then
    echo "DEBUG: This is a group chat request"
else
    echo "DEBUG: This is an unknown chat type"
fi

# Ambil token dari environment variable dulu, baru dari config jika tidak ada
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
    TOKEN="$TELEGRAM_BOT_TOKEN"
    echo "Using token from environment variable"
else
    echo "Environment variable TELEGRAM_BOT_TOKEN not found, trying config file..."
    TOKEN=$(grep -o '"token": "[^"]*' /home/balinux/.picoclaw/config.json | cut -d'"' -f4)
fi

if [ -z "$TOKEN" ]; then
    echo "Error: Could not retrieve Telegram token from environment variable or config"
    exit 1
fi

# Generate filename unik
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="social_video_$TIMESTAMP.mp4"
DOWNLOAD_PATH="/home/balinux/.picoclaw/workspace/downloads/$FILENAME"

echo "Starting download from: $URL"
echo "Will save to: $DOWNLOAD_PATH"

# Download video
cd /home/balinux/.picoclaw/workspace/skills/social-media-downloader
./download_video_fixed.sh "$URL" "$DOWNLOAD_PATH"

if [ $? -ne 0 ]; then
    echo "Download failed"
    exit 1
fi

# Cek ukuran file sebelum upload
FILESIZE=$(stat -c%s "$DOWNLOAD_PATH")
MAXSIZE=$((50*1024*1024)) # 50MB dalam bytes

if [ $FILESIZE -gt $MAXSIZE ]; then
    echo "File too large: $(du -h "$DOWNLOAD_PATH" | cut -f1)"
    echo "Telegram has 50MB limit"
    
    # Coba konversi ke ukuran lebih kecil
    COMPRESSED_PATH="${DOWNLOAD_PATH%.mp4}_compressed.mp4"
    echo "Compressing video to fit Telegram limit..."
    
    ffmpeg -i "$DOWNLOAD_PATH" -vcodec libx264 -crf 28 -preset fast "$COMPRESSED_PATH"
    
    if [ $? -eq 0 ]; then
        # Gunakan file yang sudah dikompresi
        DOWNLOAD_PATH="$COMPRESSED_PATH"
    else
        echo "Compression failed, using original file"
    fi
fi

# Upload ke Telegram
./upload_telegram.sh "$DOWNLOAD_PATH" "$CHAT_ID" "$TOKEN"

if [ $? -eq 0 ]; then
    echo "Process completed successfully"
else
    echo "Upload failed"
    exit 1
fi

