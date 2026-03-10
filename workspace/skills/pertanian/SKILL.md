# Skill: pertanian

## Deskripsi
Skill ini membantu menyebarkan konten edukasi pertanian (organik, teknologi, kearifan lokal) ke Facebook secara otomatis. Dirancang untuk petani, penyuluh, dan komunitas pertanian.

## Struktur
```
skills/pertanian/
├── SKILL.md            # dokumentasi ini
├── .env.template       # template konfigurasi token
├── data/
│   ├── fb_draft_harga_20260308.txt  # contoh draft berbasis tanggal
│   └── post_log.txt      # log posting otomatis
└── scripts/
    ├── facebook_post_simple.py     # versi manual (masih tersedia)
    └── facebook_post_auto.py       # ✅ versi otomatis — tanpa konfirmasi, deteksi draft berdasarkan tanggal hari ini
```

## Persyaratan
- Token akses Facebook (dapat dari [Meta Developer](https://developers.facebook.com/))
- Python 3.8+ (skrip hanya pakai stdlib — tidak butuh `requests`)

## Cara Pakai

### 🚀 Mode Otomatis (rekomendasi untuk jadwal)
1. Pastikan draft konten disimpan di `data/fb_draft_harga_YYYYMMDD.txt` (misal: `fb_draft_harga_20260309.txt`)
2. Jalankan langsung — tanpa interaksi:
   ```bash
   python scripts/facebook_post_auto.py
   ```
   → Skrip akan:
   - Mencari draft berdasarkan tanggal hari ini
   - Langsung POST ke Facebook
   - Log hasil ke `data/post_log.txt`

### ⚙️ Mode Manual (untuk uji coba)
Gunakan `facebook_post_simple.py` seperti sebelumnya.

## Jadwalkan Otomatis (contoh: tiap Senin pukul 08:00)
```bash
# Tambahkan ke crontab (jalankan sebagai user yang punya akses ke skill)
0 8 * * 1 cd /home/balinux/.picoclaw/workspace/skills/pertanian && python scripts/facebook_post_auto.py >> logs/cron.log 2>&1
```

## Catatan
- Konten harus mematuhi kebijakan Facebook (tidak spam, tidak menyesatkan)
- Draft disimpan di `memory/` sebagai backup — lihat `memory/pertanian_backup_20260308/` jika perlu restore

> 💡 *“Setiap post adalah benih kesadaran — tanam dengan fakta, panen dengan kepercayaan.”* — PicoClaw