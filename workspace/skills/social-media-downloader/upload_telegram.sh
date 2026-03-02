#!/bin/bash
# Script untuk upload media (gambar/video) ke Telegram
# Usage: ./upload_telegram.sh <file_path> <chat_id> <token>

FILE_PATH="$1"
CHAT_ID="$2"
TOKEN="$3"

if [ -z "$FILE_PATH" ] || [ -z "$CHAT_ID" ] || [ -z "$TOKEN" ]; then
    echo "Usage: $0 <file_path> <chat_id> <token>"
    exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
    echo "File not found: $FILE_PATH"
    exit 1
fi

echo "Uploading $FILE_PATH to chat $CHAT_ID"

# Deteksi apakah file adalah gambar atau video
FILE_EXT=$(echo "${FILE_PATH##*.}" | tr '[:upper:]' '[:lower:]')

if [[ "$FILE_EXT" =~ ^(jpg|jpeg|png|gif|bmp|webp)$ ]]; then
    # Ini adalah gambar, kirim sebagai foto
    RESPONSE=$(curl -s -X POST \
      -F "chat_id=$CHAT_ID" \
      -F "photo=@$FILE_PATH" \
      -F "caption=Image from social media download" \
      "https://api.telegram.org/bot$TOKEN/sendPhoto" \
      -H "Content-Type: multipart/form-data")
else
    # Ini adalah video, kirim sebagai video
    RESPONSE=$(curl -s -X POST \
      -F "chat_id=$CHAT_ID" \
      -F "video=@$FILE_PATH" \
      -F "caption=Video from social media download" \
      "https://api.telegram.org/bot$TOKEN/sendVideo" \
      -H "Content-Type: multipart/form-data")
fi

# Periksa apakah upload sukses
if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "Upload completed successfully"
    # Hapus file setelah upload sukses
    rm "$FILE_PATH"
    echo "File deleted: $FILE_PATH"
else
    echo "Upload failed"
    echo "Response: $RESPONSE"
    exit 1
fi