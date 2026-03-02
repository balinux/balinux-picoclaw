#!/bin/bash
# Script untuk membersihkan file-file temporary dan lama dari folder downloads
# Usage: ./cleanup_downloads.sh [days_to_keep] (default: 7 days)

DAYS_TO_KEEP=${1:-7}
DOWNLOADS_DIR="/home/balinux/.picoclaw/workspace/downloads/"

echo "Cleaning up files older than $DAYS_TO_KEEP days in $DOWNLOADS_DIR"

# Hapus file temporary yang biasanya dihasilkan oleh yt-dlp
find "$DOWNLOADS_DIR" -name "*.f*.webm" -type f -mtime +$DAYS_TO_KEEP -delete 2>/dev/null
find "$DOWNLOADS_DIR" -name "*.f*.mp4" -type f -mtime +$DAYS_TO_KEEP -delete 2>/dev/null
find "$DOWNLOADS_DIR" -name "*.temp.*" -type f -mtime +$DAYS_TO_KEEP -delete 2>/dev/null
find "$DOWNLOADS_DIR" -name "*_temp.*" -type f -mtime +$DAYS_TO_KEEP -delete 2>/dev/null

# Hapus file hasil download yang sudah lebih dari DAYS_TO_KEEP hari
find "$DOWNLOADS_DIR" -type f -mtime +$DAYS_TO_KEEP -delete 2>/dev/null

echo "Cleanup completed"