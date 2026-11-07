#!/usr/bin/env bash
# File Integrity Monitor (FIM)
# Dibuat oleh Kyurahany


DB_DIR="/tmp/fim"
mkdir -p "$DB_DIR"

echo "=+=+=+=+= Pilihan =+=+=+=+="
echo "1. Create Baseline"
echo "2. Check Integrity"
echo
read -p "Jawaban: " Jawaban
echo "=========================="

case "$Jawaban" in
  "1")
        read -p "Silahkan masukkan Lokasi yang ingin di Check: " Lokasi
        echo "Create Baseline"
        find "$Lokasi" -type f -exec sha256sum {} \; > "$DB_DIR/baseline.db"
        echo "Finish"
        ;;
  "2")
        read -p "Silahkan masukkan Lokasi: " Lokasi
        find "$Lokasi" -type f -exec sha256sum {} \; > "$DB_DIR/current_scan.db"
        
        Integrity=$(diff "$DB_DIR/baseline.db" "$DB_DIR/current_scan.db")
        
        if [ -z "$Integrity" ]; then
            echo "Sistem Aman"
        else
            echo "ANOMALI TERDETEKSI"
            echo "$Integrity"
        fi
        ;;
  *)
        echo "Input Tidak Valid"
        ;;
esac
