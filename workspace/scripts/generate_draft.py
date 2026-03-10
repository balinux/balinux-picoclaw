#!/usr/bin/env python3
import os
import datetime
from pathlib import Path

# Load .env manually (no external lib)
env = {}
env_path = Path(__file__).parent.parent / ".env"
if env_path.exists():
    with open(env_path) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                k, v = line.split("=", 1)
                env[k.strip()] = v.strip().strip('"').strip("'")

# Generate today's date: "09 Maret 2026"
now = datetime.datetime.now()
tanggal_str = now.strftime("%d %B %Y")  # e.g., "09 March 2026"

# Try to get real price from latest_harga.txt
harga_cabai = "35.000"
harga_path = Path(__file__).parent.parent / "data" / "latest_harga.txt"
if harga_path.exists():
    try:
        with open(harga_path) as f:
            raw = f.read().strip()
            # Clean: remove 'Rp', dots, spaces
            clean = raw.replace('Rp', '').replace('.', '').replace(',', '').strip()
            if clean.isdigit():
                harga_cabai = clean
            else:
                # If not digit, keep raw (e.g., "82.300")
                harga_cabai = raw.replace('Rp', '').strip()
    except Exception as e:
        print(f"⚠️ Warning: failed to read harga: {e}")

# Read template
template_path = Path(__file__).parent.parent / "data" / "template_harga.txt"
if not template_path.exists():
    print(f"Error: template not found at {template_path}")
    exit(1)

with open(template_path) as f:
    template = f.read()

# Replace placeholders
draft = template.replace("{{tanggal}}", tanggal_str).replace("{{harga_cabai}}", harga_cabai)

# Write draft
draft_filename = f"fb_draft_harga_{now.strftime('%Y%m%d')}.txt"
draft_path = Path(__file__).parent.parent / "data" / draft_filename

with open(draft_path, "w") as f:
    f.write(draft)

print(f"✅ Draft generated: {draft_path}")
print(f"Content:\n{draft}")