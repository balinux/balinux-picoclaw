#!/usr/bin/env python3
import sys
import os
from urllib.parse import urlencode
from urllib.request import urlopen, Request
import json

# Load dari ~/.picoclaw/.env
# Baca file .env secara manual karena modul dotenv tidak tersedia
env_path = os.path.expanduser("~/.picoclaw/workspace/skills/pertanian/.env")
with open(env_path, 'r') as f:
    for line in f:
        if '=' in line:
            key, value = line.strip().split('=', 1)
            os.environ[key] = value

PAGE_ID = os.getenv("FACEBOOK_PAGE_ID")
ACCESS_TOKEN = os.getenv("FACEBOOK_ACCESS_TOKEN")

if not PAGE_ID or not ACCESS_TOKEN:
    print("❌ Error: FACEBOOK_PAGE_ID atau FACEBOOK_ACCESS_TOKEN belum diset di .env")
    sys.exit(1)

def post_to_facebook(message):
    url = f"https://graph.facebook.com/v19.0/{PAGE_ID}/feed"
    
    # Encode data
    data = {
        "message": message,
        "access_token": ACCESS_TOKEN
    }
    encoded_data = urlencode(data).encode('utf-8')
    
    # Create request
    req = Request(url, data=encoded_data, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")
    
    try:
        response = urlopen(req)
        result = json.loads(response.read().decode('utf-8'))
        
        if "id" in result:
            print(f"✅ Sukses posting! ID: {result['id']}")
        else:
            print(f"❌ Gagal: {result.get('error', {}).get('message', 'Unknown error')}")
    except Exception as e:
        print(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 facebook_post.py '<pesan>'")
        sys.exit(1)
    message = " ".join(sys.argv[1:])
    post_to_facebook(message)