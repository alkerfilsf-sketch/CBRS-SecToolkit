#!/usr/bin/env bash
# CBRS Security Dashboard
# Dibuat oleh Kyurahany


# Definisi Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Path ke folder tool
TOOLS_DIR="$HOME/Folder-CBRS-Tools"

clear

while true; do
    echo -e "${CYAN}====================================================${NC}"
    echo -e "${YELLOW}           CBRS SECURITY DASHBOARD v1.0           ${NC}"
    echo -e "${CYAN}====================================================${NC}"
    echo -e "  1) ${GREEN}Mini Fail2Ban${NC}       (Blokir IP Brute Force)"
    echo -e "  2) ${GREEN}File Integrity Monitor${NC} (Cek Anomali File)"
    echo -e "  3) ${GREEN}Local Network Auditor${NC} (Scan IP & Port)"
    echo -e "  4) ${RED}Keluar${NC}"
    echo -e "${CYAN}====================================================${NC}"
    echo -ne "  Pilih opsi [1-4]: "
    read pilihan

    case $pilihan in
        1)
            echo -e "\n${YELLOW}[*] Menjalankan Mini Fail2Ban...${NC}\n"
            sudo bash "$TOOLS_DIR/mini-fail2ban.sh"
            ;;
        2)
            echo -e "\n${YELLOW}[*] Menjalankan File Integrity Monitor...${NC}\n"
            bash "$TOOLS_DIR/fim.sh"
            ;;
        3)
            echo -e "\n${YELLOW}[*] Menjalankan Local Network Auditor...${NC}\n"
            sudo bash "$TOOLS_DIR/network-auditor.sh"
            ;;
        4)
            echo -e "\n${GREEN}[+] Exiting CBRS Dashboard. Stay safe!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}[-] Input tidak valid. Silakan pilih 1-4.${NC}\n"
            ;;
    esac
    
    echo -e "\n${CYAN}Tekan [Enter] untuk kembali ke menu utama...${NC}"
    read
    clear
done
