#!/bin/bash
# Script untuk download video/gambar dari social media - versi fixed
# Usage: ./download_video_fixed.sh <url> <output_path>

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

# Ambil ekstensi dari output path untuk menentukan format
EXT="${OUTPUT_PATH##*.}"

# Deteksi platform dari URL
if [[ "$URL" =~ youtube\.com/shorts ]] || [[ "$URL" =~ youtu\.be/.*t= ]] || [[ "$URL" =~ youtube\.com/watch\?.*t= ]]; then
    # Ini adalah YouTube Shorts atau video YouTube dengan timestamp
    echo "Detected YouTube Shorts/Video"
    # Gunakan format tunggal saja, bukan merge
    if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 "$URL"; then
        if [ -f "$OUTPUT_PATH" ]; then
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        else
            # Jika format mp4 tidak tersedia, coba download best dan konversi
            TEMP_FILE="${OUTPUT_PATH%.*}_temp.$EXT"
            if yt-dlp -o "$TEMP_FILE" --format "best" "$URL"; then
                # Konversi ke mp4 jika bukan mp4
                if [ "$EXT" = "mp4" ]; then
                    ffmpeg -i "$TEMP_FILE" -c copy "$OUTPUT_PATH" 2>/dev/null || ffmpeg -i "$TEMP_FILE" -c:v libx264 -c:a aac "$OUTPUT_PATH"
                    rm "$TEMP_FILE"
                else
                    mv "$TEMP_FILE" "$OUTPUT_PATH"
                fi
                if [ -f "$OUTPUT_PATH" ]; then
                    echo "Download completed successfully"
                    echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
                    exit 0
                else
                    echo "Download failed - conversion unsuccessful"
                    exit 1
                fi
            else
                echo "Download failed"
                exit 1
            fi
        fi
    else
        echo "Download failed"
        exit 1
    fi
elif [[ "$URL" =~ instagram\.com ]]; then
    # Untuk Instagram - coba pake cookies dulu
    echo "Detected Instagram"
    COOKIES_FILE="/home/balinux/.picoclaw/workspace/skills/social-media-downloader/instagram_cookies.txt"
    if [ -f "$COOKIES_FILE" ]; then
        echo "[INFO] Using cookies file: $COOKIES_FILE"
        if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 --cookies "$COOKIES_FILE" "$URL"; then
            if [ -f "$OUTPUT_PATH" ]; then
                echo "Download completed successfully"
                echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
                exit 0
            else
                echo "Download failed - file not created"
                exit 1
            fi
        else
            echo "[WARNING] Download failed with cookies, trying without cookies..."
            if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 "$URL"; then
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
    else
        echo "[WARNING] Cookies file not found: $COOKIES_FILE, trying without cookies..."
        if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 "$URL"; then
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
else
    # Platform lainnya
    echo "Detected other platform"
    if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 "$URL"; then
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