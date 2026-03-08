#!/usr/bin/env python3
"""
Skrip sederhana untuk posting ke Facebook
Gunakan format ini untuk posting otomatis dari PicoClaw
"""

import os
import sys
import json
from datetime import datetime

def load_config():
    """Load konfigurasi dari file .env"""
    config = {}
    env_path = os.path.join(os.path.dirname(__file__), '..', '.env')
    
    if os.path.exists(env_path):
        with open(env_path, 'r') as f:
            for line in f:
                if '=' in line and not line.startswith('#'):
                    key, value = line.strip().split('=', 1)
                    config[key] = value
    
    return config

def post_to_facebook(content):
    """Simulasikan posting ke Facebook - untuk debugging"""
    config = load_config()
    
    # Log aktivitas
    log_entry = f"{datetime.now().strftime('%Y-%m-%d %H:%M')} | {content[:50]}... | SIMULASI"
    
    log_file = os.path.join(os.path.dirname(__file__), '..', 'data', 'pertanian_log.txt')
    with open(log_file, 'a', encoding='utf-8') as f:
        f.write(log_entry + '\n')
    
    print(f"POSTING CONTENT TO FACEBOOK:")
    print(f"Page ID: {config.get('FACEBOOK_PAGE_ID', 'NOT SET')}")
    print(f"Content:\n{content}")
    print(f"Timestamp: {datetime.now()}")
    print("="*50)
    
    return True

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 facebook_post.py \"your content here\"")
        sys.exit(1)
    
    content = sys.argv[1]
    
    # Tambahkan hashtag default jika tidak ada
    config = load_config()
    default_hashtags = config.get('FACEBOOK_DEFAULT_HASHTAGS', '#Pertanian #TipsPetani')
    
    if not any(tag in content for tag in ['#Pertanian', '#TipsPetani', '#Agribisnis']):
        content += f"\n\n{default_hashtags}"
    
    success = post_to_facebook(content)
    
    if success:
        print("Posting berhasil disimulasikan!")
    else:
        print("Gagal melakukan posting.")
        sys.exit(1)

if __name__ == "__main__":
    main()