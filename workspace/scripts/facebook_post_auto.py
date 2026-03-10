#!/usr/bin/env python3
import os
import datetime
import urllib.request
import urllib.parse
import json
from pathlib import Path

# Load .env from pertanian skill (more reliable for FB config)
env = {}
env_path = Path(__file__).parent.parent / "skills" / "pertanian" / ".env"
if env_path.exists():
    with open(env_path) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                k, v = line.split("=", 1)
                env[k.strip()] = v.strip().strip('"').strip("'")

FACEBOOK_PAGE_ID = env.get("FACEBOOK_PAGE_ID")
FACEBOOK_ACCESS_TOKEN = env.get("FACEBOOK_ACCESS_TOKEN")
TELEGRAM_BOT_TOKEN = env.get("TELEGRAM_BOT_TOKEN", "your_bot_token_here")
TELEGRAM_CHAT_ID = env.get("TELEGRAM_CHAT_ID", "your_chat_id_here")

now = datetime.datetime.now()
draft_filename = f"fb_draft_harga_{now.strftime('%Y%m%d')}.txt"
draft_path = Path(__file__).parent.parent / "data" / draft_filename

log_path = Path(__file__).parent.parent / "post_log.txt"

def send_telegram(message):
    if TELEGRAM_BOT_TOKEN == "your_bot_token_here":
        print("⚠️ Telegram token not configured — skipping notification.")
        return
    url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
    data = {
        "chat_id": TELEGRAM_CHAT_ID,
        "text": message,
        "parse_mode": "Markdown"
    }
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers={'Content-Type': 'application/json'})
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            res = json.loads(response.read().decode())
            if not res.get("ok"):
                print(f"❌ Telegram send failed: {res}")
            else:
                print("✅ Telegram notification sent.")
    except Exception as e:
        print(f"⚠️ Telegram error: {e}")

def post_to_facebook(message):
    if not FACEBOOK_PAGE_ID or not FACEBOOK_ACCESS_TOKEN:
        print("❌ Facebook credentials missing — skipping FB post.")
        return False

    url = f"https://graph.facebook.com/v20.0/{FACEBOOK_PAGE_ID}/feed"
    data = {
        "message": message,
        "access_token": FACEBOOK_ACCESS_TOKEN
    }
    req = urllib.request.Request(url, data=urllib.parse.urlencode(data).encode(), method="POST")
    try:
        with urllib.request.urlopen(req, timeout=15) as response:
            res = json.loads(response.read().decode())
            if "id" in res:
                print(f"✅ FB post success! ID: {res['id']}")
                return True
            else:
                print(f"❌ FB post failed: {res}")
                return False
    except Exception as e:
        print(f"⚠️ FB API error: {e}")
        return False

# Main logic
if not draft_path.exists():
    msg = f"❌ No draft found: {draft_filename}"
    print(msg)
    send_telegram(msg)
    with open(log_path, "a") as f:
        f.write(f"[{now}] SKIP: no draft\n")
    exit(1)

with open(draft_path) as f:
    content = f.read().strip()

print(f"📤 Posting to Facebook...")
success = post_to_facebook(content)

# Send Telegram notification (always, even if FB fails)
timestamp = now.strftime("%H:%M:%S")
status = "✅ Success" if success else "❌ Failed"
notif = f"📅 *Posting Pertanian*\n⏰ {timestamp}\n{status}\n📄 Draft: `{draft_filename}`\n📝 Content:\n{content}"
send_telegram(notif)

# Log
with open(log_path, "a") as f:
    f.write(f"[{now}] FB_POST: {draft_filename} → {'OK' if success else 'FAIL'}\n")

print("✅ Done.")