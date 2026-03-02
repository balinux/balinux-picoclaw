#!/bin/bash

# Skrip utama untuk update jadwal shalat dan setup reminder
echo "Menjalankan update jadwal shalat dan reminder otomatis..."

# Jalankan script update jadwal shalat
bash /home/balinux/.picoclaw/workspace/scripts/update_prayer_times.sh

# Jalankan script setup reminder jadwal shalat
bash /home/balinux/.picoclaw/workspace/scripts/setup_prayer_reminders.sh

echo "Proses update jadwal shalat dan reminder selesai pada $(date)"