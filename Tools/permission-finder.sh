#!/usr/bin/env bash
# Dibuat oleh Kyurahany - 2026/10/26

# --- Definisikan Variabel Warna ---
MERAH='\e[31m'
HIJAU='\e[32m'
KUNING='\e[33m'
BIRU='\e[34m'
CYAN='\e[36m'
BOLD='\e[1m'
RESET='\e[0m'

echo -e "${CYAN}${BOLD}#=========================#=======================# Dashboard #========================#===========================${RESET}"
echo -e "1. Normal Search Permission"
echo -e "2. Spesific Search Permission"
echo " "
read -p "Silahkan Pilih, Jawaban: " pilihan
echo
echo

case "$pilihan" in

    1|"Normal Search Permission")

        read -p "Masukkan folder yang ingin diperiksa: " folder
        read -p "Masukkan kode permission (contoh: 664): " perm

        # FIX 1: Resolve Path (Handle ~ dan relative path ke Home)
        folder="${folder/#\~/$HOME}"
        if [ ! -d "$folder" ] && [ -d "$HOME/$folder" ]; then
            folder="$HOME/$folder"
        fi

        if [ ! -d "$folder" ]; then
           echo -e "${MERAH}[✘] Folder tidak ditemukan: $folder${RESET}"
           exit 1
        fi

        echo -e "${BIRU}==================================================${RESET}"
        echo -e "Mencari file dengan permission: ${KUNING}$perm${RESET}"
        echo -e "Di dalam folder: ${KUNING}$folder${RESET}"
        echo -e "${BIRU}==================================================${RESET}"

        hasil=$(find "$folder" -type f -perm "$perm" 2>/dev/null)

        if [ -z "$hasil" ]; then
                echo -e "${MERAH}[✘] Tidak ada file dengan permission $perm yang ditemukan.${RESET}"
        else
                echo -e "${HIJAU}$hasil${RESET}"
                echo -e "${BIRU}--------------------------------------------------${RESET}"
                total=$(echo "$hasil" | wc -l)
                echo -e "Total file ditemukan: ${KUNING}$total${RESET}"
        fi
        ;;

    2|"Spesific Search Permission")

        read -p "Masukkan folder yang ingin diperiksa: " folder
        read -p "Silahkan Masukkan Format Permission yang anda inginkan. Contoh, 002: " format

        # FIX 1: Resolve Path
        folder="${folder/#\~/$HOME}"
        if [ ! -d "$folder" ] && [ -d "$HOME/$folder" ]; then
            folder="$HOME/$folder"
        fi

        if [ ! -d "$folder" ]; then
           echo -e "${MERAH}[✘] Folder tidak ditemukan: $folder${RESET}"
           exit 1
        fi

        echo -e "${BIRU}==================================================${RESET}"
        echo -e "Mencari file dengan permission bit: ${KUNING}$format${RESET}"
        echo -e "Di dalam folder: ${KUNING}$folder${RESET}"
        echo -e "${BIRU}==================================================${RESET}"

        hasil=$(find "$folder" -type f -perm -"$format" 2>/dev/null)

        if [ -z "$hasil" ]; then
                echo -e "${HIJAU}[✔] Tidak ada file dengan permission $format yang ditemukan (Aman).${RESET}"
        else
                echo -e "${MERAH}$hasil${RESET}"
                echo -e "${BIRU}--------------------------------------------------${RESET}"
                
                # Jika yang dicari adalah file bocor (others write), tawarkan remediasi
                if [ "$format" = "002" ] || [ "$format" = "2" ]; then
                    echo ""
                    echo -e "${MERAH}${BOLD}⚠️  PERINGATAN: File di atas bisa diedit/dihapus oleh orang lain (Rentan)!${RESET}"
                    read -p "Apakah Anda ingin menindak file-file tersebut? (y/n): " tindak

                    if [[ "$tindak" =~ ^[yY]$ ]]; then
                        # FIX 2: Handle spasi di nama file menggunakan while read
                        while IFS= read -r file; do
                            echo -e "${BIRU}--------------------------------------------------${RESET}"
                            echo -e "Memproses File: ${KUNING}$file${RESET}"
                            echo -e "Izin asli   : ${MERAH}$(stat -c '%A' "$file")${RESET}"
                            
                            read -p "Pilih aksi: [U]bah Izin / [H]apus / [A]baikan (u/h/a): " aksi

                            if [[ "$aksi" =~ ^[uU]$ ]]; then
                                chmod o-w "$file"
                                echo -e "${HIJAU}[+] BERHASIL: Izin write untuk others telah dicabut.${RESET}"
                                echo -e "    Izin baru : ${HIJAU}$(stat -c '%A' "$file")${RESET}"

                            elif [[ "$aksi" =~ ^[hH]$ ]]; then
                                rm -f "$file"
                                echo -e "${HIJAU}[+] BERHASIL: File telah dihapus.${RESET}"

                            else
                                echo -e "${KUNING}[-] File dibiarkan (tidak ada perubahan).${RESET}"
                            fi
                        done <<< "$hasil"
                        
                        echo -e "${BIRU}--------------------------------------------------${RESET}"
                        echo -e "${HIJAU}Selesai menindak file.${RESET}"
                    else
                        echo -e "${KUNING}[-] Tindakan dibatalkan. File tetap dibiarkan.${RESET}"
                    fi
                fi

                total=$(echo "$hasil" | wc -l)
                echo -e "Total file ditemukan: ${KUNING}$total${RESET}"
        fi
        ;;

    *)
        echo -e "${MERAH}Pilihan tidak valid.${RESET}"
        exit 1
        ;;
esac
