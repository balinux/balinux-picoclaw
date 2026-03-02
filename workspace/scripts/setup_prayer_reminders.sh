#!/bin/bash

# Script untuk mengatur reminder jadwal shalat harian
echo "Mengatur reminder jadwal shalat harian..."

# Hapus semua reminder jadwal shalat yang lama
picoclaw cron --action remove --job_id prayer_subuh 2>/dev/null || true
picoclaw cron --action remove --job_id prayer_dzuhur 2>/dev/null || true
picoclaw cron --action remove --job_id prayer_ashar 2>/dev/null || true
picoclaw cron --action remove --job_id prayer_maghrib 2>/dev/null || true
picoclaw cron --action remove --job_id prayer_isya 2>/dev/null || true

# Ambil jadwal shalat hari ini (diasumsikan dari file atau API)
# Untuk contoh, kita gunakan jadwal umum

# Ambil jadwal shalat dari hasil pencarian sebelumnya (Lombok Timur)
# Subuh: 05:08, Dzuhur: 12:27, Ashar: 15:29, Maghrib: 18:36, Isya: 19:46

# Set reminder untuk Subuh
picoclaw cron --action add --at_time="05:08" --message="Waktu Shalat Subuh telah tiba. Ayo shalat!" --job_id="prayer_subuh"

# Set reminder untuk Dzuhur
picoclaw cron --action add --at_time="12:27" --message="Waktu Shalat Dzuhur telah tiba. Ayo shalat!" --job_id="prayer_dzuhur"

# Set reminder untuk Ashar
picoclaw cron --action add --at_time="15:29" --message="Waktu Shalat Ashar telah tiba. Ayo shalat!" --job_id="prayer_ashar"

# Set reminder untuk Maghrib
picoclaw cron --action add --at_time="18:36" --message="Waktu Shalat Maghrib telah tiba. Ayo shalat!" --job_id="prayer_maghrib"

# Set reminder untuk Isya
picoclaw cron --action add --at_time="19:46" --message="Waktu Shalat Isya telah tiba. Ayo shalat!" --job_id="prayer_isya"