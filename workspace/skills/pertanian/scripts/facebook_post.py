#!/usr/bin/env python3
import sys
import os
import requests
from dotenv import load_dotenv

# Load dari ~/.picoclaw/.env
load_dotenv(os.path.expanduser("~/.picoclaw/workspace/skills/pertanian/.env"))

PAGE_ID = os.getenv("FACEBOOK_PAGE_ID")
ACCESS_TOKEN = os.getenv("FACEBOOK_ACCESS_TOKEN")

if not PAGE_ID or not ACCESS_TOKEN:
    print("❌ Error: FACEBOOK_PAGE_ID atau FACEBOOK_ACCESS_TOKEN belum diset di .env")
    sys.exit(1)

def post_to_facebook(message):
    url = f"https://graph.facebook.com/v19.0/{PAGE_ID}/feed"
    response = requests.post(url, data={
        "message": message,
        "access_token": ACCESS_TOKEN
    })
    result = response.json()
    if "id" in result:
        print(f"✅ Sukses posting! ID: {result['id']}")
    else:
        print(f"❌ Gagal: {result.get('error', {}).get('message', 'Unknown error')}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 facebook_post.py '<pesan>'")
        sys.exit(1)
    message = " ".join(sys.argv[1:])
    post_to_facebook(message)