#!/bin/bash
# Script untuk download video/gambar dari social media
# Usage: ./download_video.sh <url> <output_path>

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

# Fungsi untuk mencoba download dengan berbagai pendekatan
try_download() {
    local url="$1"
    local output_path="$2"
    local extra_args=("$@")
    
    # Coba beberapa pendekatan untuk download
    # 1. Coba dulu tanpa opsi khusus
    echo "Trying basic download..."
    if yt-dlp -o "$output_path" --ignore-errors --no-warnings "${extra_args[@]}" "$url" 2>/dev/null; then
        return 0
    fi
    
    # 2. Coba dengan user-agent khusus
    echo "Trying with user-agent..."
    if yt-dlp -o "$output_path" --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" --ignore-errors --no-warnings "${extra_args[@]}" "$url" 2>/dev/null; then
        return 0
    fi
    
    # 3. Coba dengan referer
    echo "Trying with referer..."
    if yt-dlp -o "$output_path" --referer "https://www.instagram.com/" --ignore-errors --no-warnings "${extra_args[@]}" "$url" 2>/dev/null; then
        return 0
    fi
    
    # 4. Coba dengan headers tambahan
    echo "Trying with custom headers..."
    if yt-dlp -o "$output_path" --add-header "Accept-Language: en-US,en;q=0.9" --ignore-errors --no-warnings "${extra_args[@]}" "$url" 2>/dev/null; then
        return 0
    fi
    
    # 5. Jika masih gagal, coba dengan format spesifik untuk Instagram
    echo "Trying with Instagram-specific options..."
    if yt-dlp -o "$output_path" --extractor-args "instagram:sleep=2;skip_comments=true;skip_replies=true" --ignore-errors --no-warnings "${extra_args[@]}" "$url" 2>/dev/null; then
        return 0
    fi
    
    return 1
}

# Deteksi platform dari URL
if [[ "$URL" =~ youtube\.com/shorts ]] || [[ "$URL" =~ youtu\.be/.*t= ]] || [[ "$URL" =~ youtube\.com/watch\?.*t= ]]; then
    # Ini adalah YouTube Shorts atau video YouTube dengan timestamp, gunakan pendekatan YouTube
    if try_download "$URL" "$OUTPUT_PATH" "--merge-output-format" "mp4" "--recode-video" "mp4"; then
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
    # Untuk Instagram, coba download semua media (gambar/video)
    # Buat output pattern untuk menangani berbagai format
    TEMP_OUTPUT="${OUTPUT_PATH%.mp4}"
    
    # Coba download dengan pendekatan khusus Instagram
    if try_download "$URL" "${TEMP_OUTPUT}.%(ext)s" "--format" "best"; then
        # Cek file hasil download
        DOWNLOADED_FILE=$(ls -t "${TEMP_OUTPUT}".* 2>/dev/null | head -n1)
        
        if [ -n "$DOWNLOADED_FILE" ] && [ -f "$DOWNLOADED_FILE" ]; then
            # Pindahkan file ke nama yang diminta
            mv "$DOWNLOADED_FILE" "$OUTPUT_PATH"
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        fi
    fi
    
    # Jika masih gagal, coba tanpa ekstensi spesifik
    if try_download "$URL" "$OUTPUT_PATH" "--format" "best"; then
        if [ -f "$OUTPUT_PATH" ]; then
            echo "Download completed successfully"
            echo "File size: $(du -h "$OUTPUT_PATH" | cut -f1)"
            exit 0
        fi
    fi
    
    echo "Download failed - no files found"
    exit 1
else
    # Download video menggunakan yt-dlp (behavior asal untuk non-Instagram)
    if try_download "$URL" "$OUTPUT_PATH" "--merge-output-format" "mp4" "--recode-video" "mp4"; then
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