#!/usr/bin/env bash
# Network Auditor
# Dibuat oleh Kyurahany


SUBNET=$(ip route | grep default | awk '{print $3}' | cut -d. -f1-3)

echo "=== PHASE 1: IP DISCOVERY ==="
echo ""

# Inisialisasi
down_start=0
down_end=0
in_down_block=false
declare -a UP_IPS=()

for (( i=1; i<=254; i++ ))
do
    TARGET_IP="$SUBNET.$i"

    if ping -c 1 -W 1 "$TARGET_IP" > /dev/null 2>&1; then
        if [ "$in_down_block" = true ]; then
            echo "ip $SUBNET.$down_start-$SUBNET.$down_end is down"
            in_down_block=false
        fi
        echo "ip $TARGET_IP is up"
        UP_IPS+=("$TARGET_IP")  # Simpan ke array
    else
        if [ "$in_down_block" = false ]; then
            down_start=$i
            in_down_block=true
        fi
        down_end=$i
    fi
done

if [ "$in_down_block" = true ]; then
    echo "ip $SUBNET.$down_start-$SUBNET.$down_end is down"
fi

echo ""
echo "=== PHASE 2: PORT SCANNING ==="
echo ""

if [ ${#UP_IPS[@]} -eq 0 ]; then
    echo "Tidak ada IP aktif untuk di-scan."
    exit 0
fi

for TARGET_IP in "${UP_IPS[@]}"; do
    echo "[+] Scanning $TARGET_IP..."
    nmap -p 22,80,443 --open "$TARGET_IP"
    echo "-----------------------------------"
done

echo ""
echo "=== SELESAI ==="
