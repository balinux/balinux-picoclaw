#!/usr/bin/env python3
# scripts/generate_draft.py
import os
import sys
from datetime import datetime, timedelta
import json

def load_env():
    env = {}
    try:
        with open('.env', 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#'):
                    k, v = line.split('=', 1)
                    env[k.strip()] = v.strip().strip('"').strip("'")
    except Exception as e:
        print(f"⚠️  Warning: .env not loaded: {e}", file=sys.stderr)
    return env

def get_today_info():
    now = datetime.now()
    kemarin = now - timedelta(days=1)
    hari_nama = now.strftime('%A')
    hari_id = {
        'Monday': 'Senin',
        'Tuesday': 'Selasa',
        'Wednesday': 'Rabu',
        'Thursday': 'Kamis',
        'Friday': 'Jumat',
        'Saturday': 'Sabtu',
        'Sunday': 'Minggu'
    }.get(hari_nama, hari_nama)
    tanggal = now.strftime('%d %B %Y')
    kemarin_str = kemarin.strftime('%d %B %Y')
    tahunbulan = now.strftime('%Y%m')
    tahun = now.strftime('%Y')

    return {
        'hari': hari_id,
        'tanggal': tanggal,
        'kemarin': kemarin_str,
        'tahunbulan': tahunbulan,
        'tahun': tahun
    }

def generate_draft():
    env = load_env()
    info = get_today_info()

    # ⚠️ Demo: hardcode harga untuk sekarang (nanti ganti ke API)
    data = {
        'harga_cabai': '74.650',
        'trend_cabai': 'turun dari Rp83.850 (2 Mar)',
        'harga_bawang': '44.750',
        'harga_jagung': '8.500',
        'trend_jagung': 'stabil',
        'harga_beras_min': '14.300',
        'harga_beras_max': '17.000',
        'trend_beras': 'stok aman'
    }

    # Gabung info + data
    placeholders = {**info, **data}

    template_path = 'data/template_harga.txt'
    try:
        with open(template_path, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"❌ Template not found: {template_path}", file=sys.stderr)
        sys.exit(1)

    # Replace placeholders
    for key, value in placeholders.items():
        placeholder = f'{{{{{key}}}}}'
        content = content.replace(placeholder, str(value))

    # Simpan ke file draft harian
    now = datetime.now()  # 🔧 Fix: define 'now' here
    draft_filename = f"data/fb_draft_harga_{info['tahunbulan']}{now.strftime('%d')}.txt"
    with open(draft_filename, 'w') as f:
        f.write(content)

    print(f"✅ Draft generated: {draft_filename}")
    print(f"📄 Content preview:\n{content[:200]}...")
    return draft_filename

if __name__ == '__main__':
    draft_path = generate_draft()
    # Output path for chaining (e.g., by facebook_post_auto.py)
    print(f"OUTPUT_PATH={draft_path}")