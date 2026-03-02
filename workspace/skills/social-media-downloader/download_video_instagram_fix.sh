#!/bin/bash
# Script untuk download video/gambar dari social media - versi dengan Instagram fix
# Usage: ./download_video_instagram_fix.sh <url> <output_path>

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
    if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "$URL"; then
        if [ -f "$OUTPUT_PATH" ]; then
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        else
            # Jika format mp4 tidak tersedia, coba download best dan konversi
            TEMP_FILE="${OUTPUT_PATH%.*}_temp.$EXT"
            if yt-dlp -o "$TEMP_FILE" --format "best" --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "$URL"; then
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
    # Untuk Instagram - coba beberapa pendekatan
    echo "Detected Instagram"
    
    # Coba dengan user agent dan headers
    if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 \
        --user-agent "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1" \
        --add-header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
        --add-header "Accept-Language: en-US,en;q=0.5" \
        --add-header "Accept-Encoding: gzip, deflate" \
        --add-header "Connection: keep-alive" \
        --add-header "Upgrade-Insecure-Requests: 1" \
        --add-header "Sec-Fetch-Dest: document" \
        --add-header "Sec-Fetch-Mode: navigate" \
        --add-header "Sec-Fetch-Site: none" \
        --add-header "Cache-Control: max-age=0" \
        "$URL"; then
        if [ -f "$OUTPUT_PATH" ]; then
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        else
            echo "Download failed - file not created"
            exit 1
        fi
    else
        # Jika masih gagal, coba tanpa format spesifik
        if yt-dlp -o "$OUTPUT_PATH" --recode-video mp4 \
            --user-agent "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1" \
            --add-header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
            --add-header "Accept-Language: en-US,en;q=0.5" \
            --add-header "Accept-Encoding: gzip, deflate" \
            --add-header "Connection: keep-alive" \
            --add-header "Upgrade-Insecure-Requests: 1" \
            "$URL"; then
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
    if yt-dlp -o "$OUTPUT_PATH" --format "best[ext=mp4]" --recode-video mp4 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" "$URL"; then
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