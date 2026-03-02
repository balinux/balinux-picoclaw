#!/bin/bash
# Main script untuk social media downloader skill
# Usage: ./social_media_downloader.sh <url> <chat_id> <token>

URL="$1"
CHAT_ID="$2"
TOKEN="$3"

if [ -z "$URL" ] || [ -z "$CHAT_ID" ] || [ -z "$TOKEN" ]; then
    echo "Usage: $0 <url> <chat_id> <token>"
    exit 1
fi

# Generate filename unik
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="social_video_$TIMESTAMP.mp4"
DOWNLOAD_PATH="/home/balinux/.picoclaw/workspace/downloads/$FILENAME"

echo "Starting download from: $URL"
echo "Will save to: $DOWNLOAD_PATH"

# Download video
./download_video.sh "$URL" "$DOWNLOAD_PATH"

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

# Hapus file setelah berhasil dikirim
rm "$DOWNLOAD_PATH"
echo "Temporary file cleaned up"