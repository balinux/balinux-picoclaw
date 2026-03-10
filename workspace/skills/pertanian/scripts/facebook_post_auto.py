# scripts/facebook_post_auto.py
# Skrip posting Facebook otomatis — tanpa konfirmasi, dengan deteksi draft berbasis tanggal hari ini
# Dipakai untuk jadwal otomatis (cron) — langsung POST jika draft tersedia

import os
import urllib.request
import urllib.parse
import json
import sys
import datetime

def get_today_draft_path():
    today = datetime.date.today()
    base_names = [
        f"fb_draft_harga_{today.strftime('%Y%m%d')}.txt",
        f"fb_draft_{today.strftime('%Y%m%d')}.txt",
        "fb_draft_2026.txt"
    ]
    for name in base_names:
        path = os.path.join("data", name)
        if os.path.isfile(path):
            return path
    return None

def main():
    # Baca .env manual
    TOKEN = None
    PAGE_ID = "me"
    try:
        with open(".env", "r") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if line.startswith("FACEBOOK_ACCESS_TOKEN="):
                    TOKEN = line.split("=", 1)[1].strip().strip('"').strip("'")
                elif line.startswith("FACEBOOK_PAGE_ID="):
                    PAGE_ID = line.split("=", 1)[1].strip().strip('"').strip("'")
    except FileNotFoundError:
        print("⚠️  File .env tidak ditemukan.")
        print("   → Salin .env.template ke .env, lalu isi FACEBOOK_ACCESS_TOKEN")
        sys.exit(1)

    if not TOKEN:
        print("❌ Token Facebook belum diisi di .env")
        sys.exit(1)

    # Cari draft berdasarkan tanggal hari ini
    draft_path = get_today_draft_path()
    if not draft_path:
        print("❌ Draft konten tidak ditemukan untuk hari ini.")
        print("   → Pastikan file ada di: data/fb_draft_harga_YYYYMMDD.txt")
        sys.exit(1)

    try:
        with open(draft_path, "r", encoding="utf-8") as f:
            message = f.read().strip()
    except Exception as e:
        print(f"❌ Gagal baca draft {draft_path}: {e}")
        sys.exit(1)

    # Siapkan request
    url = f"https://graph.facebook.com/v19.0/{PAGE_ID}/feed"
    data = urllib.parse.urlencode({
        "message": message,
        "access_token": TOKEN
    }).encode("utf-8")

    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")

    print(f"📤 Mengirim ke Facebook... (draft: {os.path.basename(draft_path)})")
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read().decode())
            print("✅ Posting berhasil!")
            print("ID:", result.get("id"))
            if result.get("id"):
                post_link = f"https://facebook.com/{result['id']}"
                print("Link publik:", post_link)
            # Catat ke log
            log_entry = f"[{datetime.datetime.now()}] SUCCESS: {result.get('id')} | {draft_path}\n"
            with open("data/post_log.txt", "a", encoding="utf-8") as log:
                log.write(log_entry)

            # 🔔 Kirim notifikasi Telegram
            try:
                tg_token = None
                tg_chat_id = None
                with open(".env", "r") as f:
                    for line in f:
                        line = line.strip()
                        if line.startswith("TELEGRAM_BOT_TOKEN="):
                            tg_token = line.split("=", 1)[1].strip().strip('"').strip("'")
                        elif line.startswith("TELEGRAM_CHAT_ID="):
                            tg_chat_id = line.split("=", 1)[1].strip().strip('"').strip("'")
                if tg_token and tg_chat_id:
                    tg_url = f"https://api.telegram.org/bot{tg_token}/sendMessage"
                    tg_message = f"🎉 Posting Facebook berhasil!\n\n{message[:200]}...\n\n🔗 {post_link}"
                    data = urllib.parse.urlencode({
                        "chat_id": tg_chat_id,
                        "text": tg_message,
                        "parse_mode": "Markdown"
                    }).encode("utf-8")
                    tg_req = urllib.request.Request(tg_url, data=data, method="POST")
                    tg_req.add_header("Content-Type", "application/x-www-form-urlencoded")
                    with urllib.request.urlopen(tg_req, timeout=10) as tg_resp:
                        tg_result = json.loads(tg_resp.read().decode())
                        if tg_result.get("ok"):
                            print("📱 Notifikasi Telegram terkirim!")
                        else:
                            print(f"⚠️  Notifikasi Telegram gagal: {tg_result}")
                else:
                    print("ℹ️  Skip Telegram notif: token/chat_id tidak tersedia di .env")
            except Exception as e:
                print(f"⚠️  Gagal kirim notif Telegram: {e}")

    except urllib.error.HTTPError as e:
        print(f"❌ Gagal: {e.code} {e.reason}")
        try:
            err_detail = e.read().decode()
            print("Detail error:", err_detail)
        except:
            pass
        # Catat error
        log_entry = f"[{datetime.datetime.now()}] ERROR: {e.code} {e.reason} | {draft_path}\n"
        with open("data/post_log.txt", "a", encoding="utf-8") as log:
            log.write(log_entry)
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error tak terduga: {e}")
        log_entry = f"[{datetime.datetime.now()}] EXCEPTION: {e} | {draft_path}\n"
        with open("data/post_log.txt", "a", encoding="utf-8") as log:
            log.write(log_entry)
        sys.exit(1)

if __name__ == "__main__":
    main()