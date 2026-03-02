# Heartbeat Check List

This file contains tasks for the heartbeat service to check periodically.

## Examples

- Check for unread messages
- Review upcoming calendar events
- Check device status (e.g., MaixCam)

## Instructions

- Execute ALL tasks listed below. Do NOT skip any task.
- For simple tasks (e.g., report current time), respond directly.
- For complex tasks that may take time, use the spawn tool to create a subagent.
- The spawn tool is async - subagent results will be sent to the user automatically.
- After spawning a subagent, CONTINUE to process remaining tasks.
- Only respond with HEARTBEAT_OK when ALL tasks are done AND nothing needs attention.

---

Add your heartbeat tasks below this line:

## Task: Facebook Pertanian Otomatis
- Jalankan perintah `date +%H` untuk cek jam sekarang
- Jika jam 06: gunakan spawn tool dengan instruksi:
  "Baca ~/.picoclaw/workspace/skills/pertanian/SKILL.md, jalankan tugas posting pagi: cari info cuaca dan tips pertanian hari ini via web search, buat konten Format A (Tips Praktis), posting ke Facebook, catat di log"
- Jika jam 12: gunakan spawn tool dengan instruksi:
  "Baca ~/.picoclaw/workspace/skills/pertanian/SKILL.md, jalankan tugas posting siang: cari harga komoditas pertanian terkini via web search, buat konten Format B (Info Harga Komoditas), posting ke Facebook, catat di log"
- Jika jam 16: gunakan spawn tool dengan instruksi:
  "Baca ~/.picoclaw/workspace/skills/pertanian/SKILL.md, jalankan tugas posting sore: cari fakta atau tips menarik pertanian via web search, buat konten Format D (Edukasi), posting ke Facebook, catat di log"
- Jika bukan jam posting (06, 12, 16), skip task ini tanpa laporan.