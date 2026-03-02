#!/bin/bash
# Skrip simulasi posting ke Facebook untuk testing

CONTENT_FILE="/tmp/facebook_content.txt"
LOG_FILE="/home/balinux/.picoclaw/workspace/skills/pertanian/data/pertanian_log.txt"

# Ambil konten dari argumen
echo "$1" > "$CONTENT_FILE"

# Simulasikan posting
echo "=== SIMULASI POSTING KE FACEBOOK ===" > /tmp/simulated_post.log
echo "Tanggal: $(date)" >> /tmp/simulated_post.log
echo "Konten:" >> /tmp/simulated_post.log
cat "$CONTENT_FILE" >> /tmp/simulated_post.log
echo "" >> /tmp/simulated_post.log
echo "===============================" >> /tmp/simulated_post.log

# Tambahkan ke log
echo "$(date '+%Y-%m-%d %H:%M') | Simulasi posting konten pertanian | BERHASIL" >> "$LOG_FILE"

echo "Simulasi posting berhasil!"
echo "Konten telah ditambahkan ke log di: $LOG_FILE"