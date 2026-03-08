# Skill: pertanian

## Deskripsi
Skill ini membantu menyebarkan konten edukasi pertanian (organik, teknologi, kearifan lokal) ke Facebook secara otomatis. Dirancang untuk petani, penyuluh, dan komunitas pertanian.

## Struktur
```
skills/pertanian/
├── SKILL.md            # dokumentasi ini
├── .env.template       # template konfigurasi token
├── data/
│   └── fb_draft_2026.txt   # draft konten siap-post (contoh: 3 fakta pertanian 2026)
└── scripts/
    └── facebook_post_simple.py  # skrip posting ke Facebook API
```

## Persyaratan
- Token akses Facebook (dapat dari [Meta Developer](https://developers.facebook.com/))
- Python 3.8+ dengan modul `requests`

## Cara Pakai
1. Copy `.env.template` → `.env`
   ```bash
   cp .env.template .env
   ```
2. Edit `.env`: isi `FACEBOOK_ACCESS_TOKEN=xxx`
3. Sesuaikan draft di `data/fb_draft_2026.txt` (opsional)
4. Jalankan skrip:
   ```bash
   python scripts/facebook_post_simple.py
   ```

## Catatan
- Konten harus mematuhi kebijakan Facebook (tidak spam, tidak menyesatkan)
- Draft disimpan di `memory/` sebagai backup — lihat `memory/pertanian_backup_20260308/` jika perlu restore

> 💡 *“Setiap post adalah benih kesadaran — tanam dengan fakta, panen dengan kepercayaan.”* — PicoClaw