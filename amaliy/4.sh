#!/usr/bin/env bash

# 4-kun: Tizim Metrikalari Monitoringi (Sleep mexanizmi bilan)
# CPU, RAM, Disk monitoring + xizmat holatini tekshirish va boshqarish

set -u  # aniqlanmagan o'zgaruvchilardan foydalanish xato

# ------------------------------------------------------------
# Funksiyalar
# ------------------------------------------------------------

show_header() {
    clear
    echo "========================================="
    echo "      TIZIM MONITORING DASHBOARD        "
    echo "========================================="
    echo "Joriy vaqt: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
}

show_metrics() {
    echo "--- Asosiy Tizim Metrikalari ---"
    echo ""

    # CPU yuklamasi (oddiy usul – 1 soniya kutish bilan aniqroq)
    cpu=$(top -bn1 | grep '%Cpu(s)' | awk '{printf "%.1f%%", 100 - $8}')
    echo "CPU yuklamasi     : $cpu"

    # RAM
    ram_used=$(free -h | awk '/Mem:/ {print $3}')
    ram_total=$(free -h | awk '/Mem:/ {print $2}')
    ram_perc=$(free | awk '/Mem:/ {printf "%.1f%%", $3/$2*100}')
    echo "RAM ishlatilmoqda : $ram_used / $ram_total ($ram_perc)"

    # Disk (root bo'limi uchun)
    disk_used=$(df -h / | tail -1 | awk '{print $3}')
    disk_total=$(df -h / | tail -1 | awk '{print $2}')
    disk_perc=$(df / | tail -1 | awk '{print $5}')
    echo "Disk (/) to'lgan  : $disk_used / $disk_total ($disk_perc)"
    echo ""
}

check_service() {
    local service="$1"
    
    if [[ -z "$service" ]]; then
        echo "Xato: Xizmat nomi kiritilmadi!"
        return 1
    fi

    # systemctl mavjudligini tekshirish (ba'zi eski tizimlarda bo'lmasligi mumkin)
    if ! command -v systemctl >/dev/null 2>&1; then
        echo "Xato: systemctl topilmadi (systemd yo'qmi?)"
        return 1
    fi

    echo "Xizmat tekshirilmoqda: $service"

    if systemctl is-active --quiet "$service"; then
        echo "[+] $service → ishlamoqda"
        local status=$(systemctl status "$service" --no-pager | head -n 3 | tail -n 1 | sed 's/^[[:space:]]*//')
        echo "    $status"
    else
        echo "[!] $service → to'xtatilgan yoki xato holatda"
        
        read -p "[?] Uni hozir ishga tushirishni xohlaysizmi? (y/n): " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            echo "→ sudo systemctl start $service"
            if sudo systemctl start "$service"; then
                sleep 2
                if systemctl is-active --quiet "$service"; then
                    echo "[+] Muvaffaqiyat: $service ishga tushirildi!"
                else
                    echo "[X] Xato: hali ham ishga tushmadi"
                    sudo systemctl status "$service" --no-pager --lines=8
                fi
            else
                echo "[X] Start qilishda xato (sudo huquqi yoki xizmat topilmadi?)"
            fi
        else
            echo "Amal bekor qilindi."
        fi
    fi
}

# ------------------------------------------------------------
# Asosiy dastur
# ------------------------------------------------------------

while true; do
    show_header

    echo "1. Metrikalarni doimiy kuzatish (continuous monitoring)"
    echo "2. Xizmat holatini tekshirish va boshqarish"
    echo "3. Chiqish"
    echo ""
    read -p "Tanlovingiz (1-3): " choice

    case "$choice" in
        1)
            read -p "Yangilanish oralig'i (sekundlarda, masalan 5): " interval
            if ! [[ "$interval" =~ ^[0-9]+$ ]] || [ "$interval" -lt 1 ]; then
                echo "Xato: Iltimos, musbat butun son kiriting!"
                sleep 2
                continue
            fi

            echo ""
            echo "Monitoring boshlandi... (to'xtatish uchun Ctrl+C)"
            echo "Oraliq: $interval sekund"
            echo "----------------------------------------"

            while true; do
                show_metrics
                echo "(keyingi yangilanish $interval soniyadan so'ng...)"
                sleep "$interval"
                # clear ni faqat loop ichida ishlatish mumkin, lekin ko'p joyda chiroyli emas
                # shuning uchun har safar header bilan yangilaymiz
            done
            ;;

        2)
            read -p "Qaysi xizmatni tekshirmoqchisiz? (masalan: nginx, ssh, docker): " svc
            if [[ -z "$svc" ]]; then
                echo "Xizmat nomi kiritilmadi."
            else
                check_service "$svc"
            fi
            echo ""
            read -p "Asosiy menyuga qaytish uchun Enter bosing..." dummy
            ;;

        3)
            echo "Dastur tugadi. Xayr!"
            exit 0
            ;;

        *)
            echo "Noto'g'ri tanlov! Iltimos 1, 2 yoki 3 ni tanlang."
            sleep 1
            ;;
    esac
done