#!/bin/bash
# Skrip untuk menyimpan postingan ke log
LOG_FILE="/home/balinux/.picoclaw/workspace/skills/pertanian/data/pertanian_log.txt"
POST_CONTENT="UPDATE HARGA KOMODITAS - 4 Maret 2026

Cabai Rawit Merah : Rp74.650/kg
Cabai Merah Besar  : Rp44.150/kg
Bawang Merah       : Rp44.750/kg
Jagung Pipil       : Rp5.500/kg 
Gabah Kering       : Rp7.500/kg

Sumber: PIHPS Nasional, Bappebti

#HargaTani #KomoditasPertanian

#Pertanian #TipsPetani #Agribisnis #PetaniCerdas"

echo "Postingan telah disiapkan dan siap dikirim ke Facebook:"
echo "$POST_CONTENT"
echo ""
echo "Tanggal: $(date)" >> $LOG_FILE
echo "Status: Siap dikirim ke Facebook" >> $LOG_FILE