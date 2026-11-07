#!/usr/bin/env bash
# Mini Fail2Ban - SSH Brute Force Protector
# Dibuat oleh Kyurahany

# Konfigurasi
THRESHOLD=5
LOG_FILE="/var/log/auth.log"

echo "=== MINI FAIL2BAN - SSH BRUTE FORCE DETECTOR ==="
echo "Threshold: $THRESHOLD kegagalan"
echo ""

# Fase 1: Observasi & Analisis
echo "[*] Memindai log: $LOG_FILE"
DATA_LOG=$(grep "sshd.*Failed password" "$LOG_FILE" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr)

if [ -z "$DATA_LOG" ]; then
    echo "[✔] Tidak ada percobaan login gagal terdeteksi. Sistem aman."
    exit 0
fi

echo "[*] Ditemukan IP mencurigakan:"
echo "$DATA_LOG"
echo ""

# Fase 2: Eksekusi Blokir
echo "[*] Memproses pemblokiran IP (threshold >= $THRESHOLD)..."
echo ""

echo "$DATA_LOG" | while read count ip; do
    if [ "$count" -ge "$THRESHOLD" ]; then
        # Cek apakah IP sudah diblokir sebelumnya
        if sudo ufw status | grep -q "$ip"; then
            echo "[!] IP $ip sudah diblokir sebelumnya. Skip."
        else
            sudo ufw deny from "$ip" to any
            echo "[✔] IP $ip diblokir. Jumlah kegagalan: $count"
        fi
    fi
done
cek=$(sudo ufw status)
echo ""
echo "=== SELESAI ==="
echo "Cek status firewall: $cek"
