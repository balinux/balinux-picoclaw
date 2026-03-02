# 🌾 Skill: Pertanian Content Creator & Advisor

## Deskripsi
Skill ini digunakan untuk mencari informasi pertanian terkini, membuat konten edukatif seputar pertanian (cuaca, hama, teknik tanam, harga komoditas), dan mempostingnya ke Facebook secara otomatis. Cocok untuk halaman Facebook komunitas petani, penyuluh pertanian, atau agribisnis.

---

## Mode Penggunaan

### 🤖 Mode Otomatis (via HEARTBEAT/Cron)
Dijalankan otomatis sesuai jadwal. Agent memilih topik sendiri berdasarkan waktu
dan hasil web search terkini.

### 💬 Mode Manual (via Pesan Pengguna)
Dijalankan saat pengguna mengirim perintah langsung. Contoh:
- "gunakan skill pertanian: bagaimana merawat strawberry"
- "gunakan skill pertanian: buat konten hama padi"
- "gunakan skill pertanian: tips pupuk organik"

**Instruksi untuk mode manual:**
1. Identifikasi topik dari perintah pengguna
2. Lakukan web search untuk topik tersebut
3. Tentukan format konten yang paling sesuai (lihat bagian Format Konten)
4. Buat konten sesuai format
5. Tampilkan preview konten ke pengguna
6. Simulasikan posting ke Facebook (untuk testing)
7. Catat di log

---
## Topik yang Dicakup
- Teknik budidaya tanaman (padi, jagung, cabai, tomat, dll)
- Pengendalian hama dan penyakit tanaman
- Informasi cuaca dan musim tanam
- Harga komoditas pertanian terkini
- Pupuk dan nutrisi tanaman
- Pertanian organik dan modern
- Tips pascapanen dan penyimpanan hasil panen
- Berita kebijakan pertanian dari pemerintah

---

## Langkah-langkah Eksekusi

### 1. 🔍 Cari Informasi / Ide Konten
Gunakan web search dengan query yang relevan. Contoh:

```
"harga cabai hari ini [bulan tahun]"
"hama wereng terbaru 2025"
"tips tanam padi musim kemarau"
"berita pertanian Indonesia terbaru"
"cuaca musim tanam [wilayah]"
"pupuk subsidi terbaru pemerintah"
```

Pilih informasi yang:
- **Relevan dan terkini** (utamakan berita < 7 hari)
- **Praktis dan berguna** bagi petani kecil maupun besar
- **Lokal** jika memungkinkan (Indonesia, Jawa, Sumatera, dll)

---

### 2. ✍️ Buat Konten Postingan Facebook

Gunakan format berikut tergantung jenis konten:

#### Format A — Tips Praktis
```
💡 TIPS PERTANIAN HARI INI

[Judul tips singkat]

✅ [Poin 1]
✅ [Poin 2]
✅ [Poin 3]

Bagikan ke sesama petani! 🌾
#Pertanian #TipsPetani #Agribisnis
```

#### Format B — Info Harga Komoditas
```
📊 UPDATE HARGA KOMODITAS - [TANGGAL]

🌶️ Cabai Merah   : Rp [harga]/kg
🌽 Jagung Pipil   : Rp [harga]/kg
🍅 Tomat          : Rp [harga]/kg
🌾 Gabah Kering   : Rp [harga]/kg

Sumber: [nama sumber]
Info lengkap 👇 [link jika ada]

#HargaTani #KomoditasPertanian
```

#### Format C — Peringatan Hama/Cuaca
```
⚠️ WASPADA PETANI!

[Judul peringatan]

📍 Wilayah terdampak: [wilayah]
🐛 Jenis hama/masalah: [nama]
🛡️ Cara pengendalian:
   - [Langkah 1]
   - [Langkah 2]

Tetap waspada dan jaga tanaman kalian! 💪
#HamaTanaman #WaspadaPetani
```

#### Format D — Edukasi / Artikel Singkat
```
📚 TAHUKAH KAMU?

[Fakta atau informasi menarik seputar pertanian]

[Penjelasan singkat 2-3 kalimat yang mudah dipahami]

💬 Tulis pengalamanmu di kolom komentar!
#EdukasiPertanian #PetaniCerdas
```

**Panduan menulis konten:**
- Gunakan Bahasa Indonesia yang mudah dipahami petani umum
- Panjang ideal: **150–400 karakter** untuk postingan biasa, bisa lebih panjang untuk edukasi
- Gunakan emoji secukupnya agar menarik tapi tidak berlebihan
- Selalu sertakan hashtag relevan di akhir
- Hindari informasi yang belum terverifikasi

---

### 3. 📤 Posting ke Facebook

Setelah konten siap, jalankan script posting:

```bash
python3 ~/.picoclaw/workspace/skills/pertanian/scripts/facebook_post.py "<ISI KONTEN POSTINGAN>"
``` 

Untuk konten panjang (multi-baris), simpan dulu ke file lalu kirim:

```bash
cat << 'EOF' > /tmp/konten_pertanian.txt
[ISI KONTEN DI SINI]
EOF

python3 ~/.picoclaw/workspace/skills/pertanian/scripts/facebook_post.py "$(cat /tmp/konten_pertanian.txt)"
```

---

### 4. 📝 Log Hasil Posting

Catat setiap aktivitas ke file log:

```bash
echo "$(date '+%Y-%m-%d %H:%M') | [TOPIK] | [STATUS: SUKSES/GAGAL]" >> ~/.picoclaw/workspace/skills/pertanian/data/pertanian_log.txt
```

Contoh:
```bash
echo "$(date '+%Y-%m-%d %H:%M') | Harga Cabai Merah | SUKSES" >> ~/.picoclaw/workspace/skills/pertanian/data/pertanian_log.txt
```

---

## Jadwal Posting yang Direkomendasikan

| Waktu        | Jenis Konten                        |
|--------------|-------------------------------------|
| 06:00 pagi   | Info cuaca & kondisi hari ini       |
| 09:00 pagi   | Tips praktis / teknik budidaya      |
| 12:00 siang  | Update harga komoditas              |
| 16:00 sore   | Edukasi / artikel pertanian         |
| 19:00 malam  | Motivasi / quotes petani (opsional) |

> ⚠️ **Maksimal 3-4 posting per hari** agar tidak dianggap spam oleh Facebook.

---

## Sumber Referensi yang Direkomendasikan untuk Dicari

Saat melakukan web search, prioritaskan informasi dari sumber-sumber ini:

- **Kementan RI**: pertanian.go.id
- **Badan Pusat Statistik**: bps.go.id
- **Info Harga Pangan**: pihpsnas.bapanas.go.id
- **BMKG (cuaca)**: bmkg.go.id
- **Media pertanian**: tabloidsinartani.com, agrozine.id, cybex.pertanian.go.id
- **Berita lokal** yang relevan dengan wilayah target audiens

---

## Contoh Prompt untuk PicoClaw Agent

```
Gunakan skill pertanian. Cari berita atau tren pertanian terbaru hari ini 
di Indonesia menggunakan web search. Buat 1 postingan Facebook yang 
informatif dan menarik untuk petani, gunakan Format Tips Praktis atau 
Info Harga Komoditas tergantung informasi yang kamu temukan. 
Setelah konten siap, posting ke Facebook dan catat hasilnya di log.
```

---

## Catatan Penting

- Selalu **verifikasi keakuratan informasi** sebelum posting, terutama untuk data harga dan peringatan hama
- Jika informasi tidak ditemukan/tidak update, **jangan posting informasi lama** — cari topik lain
- Gunakan bahasa yang **inklusif dan ramah** untuk semua level petani
- Untuk konten peringatan hama atau bencana, **segera posting** tanpa menunggu jadwal rutin

---

*Skill ini dibuat untuk PicoClaw Agent Framework*
*Versi: 1.0 | Kategori: Pertanian & Agribisnis*
### 3. 📤 Simulasi Posting ke Facebook

Setelah konten siap, jalankan script simulasi posting:

```bash
bash ~/.picoclaw/workspace/skills/pertanian/run_agriculture.sh "<TOPIK KONTEN>" "<CHAT_ID>" "<TIPE_CHAT>"
```

Untuk implementasi sebenarnya dengan akses API Facebook, Anda perlu:
1. Mengisi informasi akun di `.env`
2. Mengganti skrip simulasi dengan skrip posting sebenarnya
3. Mengikuti pedoman API Facebook Graph

**Struktur .env:**
```
FACEBOOK_PAGE_ID=ID_HALAMAN_ANDA
FACEBOOK_ACCESS_TOKEN=AKSES_TOKEN_ANDA
FACEBOOK_POST_TO_FEED=true
FACEBOOK_DEFAULT_HASHTAGS="#Pertanian #TipsPetani #Agribisnis #PetaniCerdas"
```

---

### 4. 📝 Log Hasil Posting

Catat setiap aktivitas ke file log:

```bash
echo "$(date '+%Y-%m-%d %H:%M') | [TOPIK] | [STATUS: SUKSES/GAGAL]" >> ~/.picoclaw/workspace/skills/pertanian/data/pertanian_log.txt
```

Contoh:
```bash
echo "$(date '+%Y-%m-%d %H:%M') | Harga Cabai Merah | BERHASIL" >> ~/.picoclaw/workspace/skills/pertanian/data/pertanian_log.txt
```

File log dapat dicek dengan:
```bash
cat ~/.picoclaw/workspace/skills/pertanian/data/pertanian_log.txt
```

---

## Setup dan Testing

Untuk testing skill pertanian, gunakan perintah:

```bash
bash ~/.picoclaw/workspace/skills/pertanian/run_agriculture.sh "contoh topik" 207853653 private
```

Contoh output yang diharapkan:
- File konten dibuat di `/tmp/`
- Simulasi posting berhasil
- Entri log ditambahkan ke `data/pertanian_log.txt`

---

## Troubleshooting

**Jika log kosong padahal cron berjalan:**
- Pastikan skrip bisa diakses dan dieksekusi
- Periksa permission file
- Verifikasi path file log

**Jika konten tidak muncul sesuai harapan:**
- Periksa koneksi internet untuk web search
- Pastikan format konten sesuai standar
- Cek kapabilitas web search

---

*Skill ini dibuat untuk PicoClaw Agent Framework*
*Versi: 1.1 | Kategori: Pertanian & Agribisnis*