# scripts/facebook_post_simple.py
# Skrip posting Facebook minimal — hanya pakai stdlib Python (tanpa requests/dotenv)

import os
import urllib.request
import urllib.parse
import json
import sys

def main():
    # Baca .env manual
    TOKEN = None
    PAGE_ID = "me"  # default ke profil pengguna
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

    # Baca draft konten
    try:
        with open("data/fb_draft_2026.txt", "r", encoding="utf-8") as f:
            message = f.read().strip()
    except FileNotFoundError:
        print("❌ Draft konten tidak ditemukan di data/fb_draft_2026.txt")
        sys.exit(1)

    # Siapkan request
    url = f"https://graph.facebook.com/v19.0/{PAGE_ID}/feed"
    data = urllib.parse.urlencode({
        "message": message,
        "access_token": TOKEN
    }).encode("utf-8")

    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")

    print("📤 Mengirim ke Facebook... (API v19.0)")
    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read().decode())
            print("✅ Posting berhasil!")
            print("ID:", result.get("id"))
            if result.get("id"):
                print("Link publik:", f"https://facebook.com/{result['id']}")
    except urllib.error.HTTPError as e:
        print(f"❌ Gagal: {e.code} {e.reason}")
        try:
            err_detail = e.read().decode()
            print("Detail error:", err_detail)
        except:
            pass
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error tak terduga: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()